import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/database/vouchers/VoucherConfigLocalApi.dart';
import 'package:jakel_base/database/vouchers/VouchersLocalApi.dart';
import 'package:jakel_base/jakel_base.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/restapi/vouchers/VoucherApi.dart';
import 'package:jakel_base/restapi/vouchers/model/BirthdayVoucherResponse.dart';
import 'package:jakel_base/restapi/vouchers/model/VoucherConfigurationResponse.dart';
import 'package:jakel_base/restapi/vouchers/model/VouchersListResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/my_date_utils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:jakel_pos/modules/vouchers/validate/configurations/vc_birthday_customer_flat.dart';
import 'package:jakel_pos/modules/vouchers/validate/configurations/vc_birthday_customer_percentage.dart';
import 'package:jakel_pos/modules/vouchers/validate/voucher_config_service.dart';
import 'package:jakel_pos/modules/vouchers/validate/voucher_config_service_impl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synchronized/synchronized.dart';

class VouchersViewModel extends BaseViewModel {
  List<Vouchers> mVouchersList = [];

  // Use this object to prevent concurrent access to data
  var lock = Lock();

  var responseSubject = PublishSubject<BirthdayVoucherResponse>();

  Stream<BirthdayVoucherResponse> get responseStream => responseSubject.stream;

  var responseVouchersListSubject = PublishSubject<VouchersListResponse>();

  Stream<VouchersListResponse> get responseVouchersListStream =>
      responseVouchersListSubject.stream;

  void closeObservable() {
    responseSubject.close();
    responseVouchersListSubject.close();
  }

  VoucherConfiguration? canGenerateBirthdayVoucher(
      List<VoucherConfiguration> allVoucherConfigs, Customers customer) {
    var api = locator.get<VoucherConfigService>();
    return api.getBirthdayVoucherConfig(allVoucherConfigs, customer);
  }

  void generateBirthdayVoucher(
      Customers customer, VoucherConfiguration voucherConfiguration) async {
    await lock.synchronized(() async {
      var api = locator.get<VoucherApi>();

      String number = "";

      if (voucherConfiguration.flatAmount != null) {
        number = VcBirthdayCustomerFlat().createVoucherNumber(
            CartSummary(customers: customer), voucherConfiguration);
      } else {
        number = VcBirthdayCustomerPercentage().createVoucherNumber(
            CartSummary(customers: customer), voucherConfiguration);
      }

      try {
        var response = await api.generateBirthdayVoucher(
            customer.id ?? 0, voucherConfiguration, number);

        if (response.birthdayVoucher != null) {
          printBirthdayVoucher(
              "Birthday Voucher", customer, response.birthdayVoucher!);
        }

        responseSubject.sink.add(response);
      } catch (e) {
        MyLogUtils.logDebug("generateBirthdayVoucher exception $e");
        responseSubject.sink.addError(e);
      }
    });
  }

  Vouchers? printBirthdayVoucherIfAvailable(Customers customer) {
    Vouchers? bDayVoucher;
    customer.customerVouchers?.forEach((element) {
      if (element.voucherType == birthdayVoucher) {
        bDayVoucher = Vouchers.fromJson(element.toJson());
      }
    });

    if (bDayVoucher != null) {
      printBirthdayVoucher("Birthday Voucher", customer, bDayVoucher!);
    }
    return bDayVoucher;
  }

  ///get All VoucherList LocalApi
  Future<List<Vouchers>> getAllVoucherList() async {
    var api = locator.get<VouchersLocalApi>();
    return await api.getAll();
  }

  ///get all Voucher List and search call from Vouchers List Widget
  Future<void> getVoucherListOffline({String sSearch = ""}) async {
    List<Vouchers> mVouchersSubList = [];
    try {
      if (mVouchersList.isEmpty) {
        mVouchersList = await getAllVoucherList();
      }
      if (sSearch.trim().isEmpty) {
        mVouchersSubList.addAll(mVouchersList);
      } else {
        mVouchersSubList
            .addAll(await onSearchVoucherList(sSearch.toLowerCase().trim()));
      }

      VouchersListResponse mVouchersListResponse =
          VouchersListResponse(vouchers: mVouchersSubList);
      responseVouchersListSubject.sink.add(mVouchersListResponse);
    } catch (e) {
      MyLogUtils.logDebug("getProducts exception $e");
      responseVouchersListSubject.sink.addError(e);
    }
  }

  ///Voucher List search Id and Discount Number
  Future<List<Vouchers>> onSearchVoucherList(String text) async {
    List<Vouchers> mVouchersSubList = [];
    for (var mVouchers in mVouchersList) {
      if (mVouchers.id.toString().toLowerCase().contains(text.toLowerCase())) {
        mVouchersSubList.add(mVouchers);
      } else if (mVouchers.number
          .toString()
          .toLowerCase()
          .contains(text.toLowerCase())) {
        mVouchersSubList.add(mVouchers);
      }
    }
    return mVouchersSubList;
  }

  Future<List<VoucherConfiguration>> getVoucherConfigs() async {
    var api = locator.get<VoucherConfigLocalApi>();
    List<VoucherConfiguration> voucherConfigs = await api.getAll();
    return voucherConfigs;
  }

  Future<Vouchers?> searchVoucher(String voucherCode) async {
    var api = locator.get<VouchersLocalApi>();

    var vouchers = await api.getAll();

    MyLogUtils.logDebug("searchVoucher vouchers : ${vouchers.length}");

    var voucher = api.getById(voucherCode);
    return voucher;
  }

  String? isValidVoucherForThisCart(
      Vouchers vouchers, CartSummary cartSummary) {
    if (vouchers.minimumSpendAmount == null) {
      return "Invalid voucher condition. Minimum threshold amount is not specified.";
    }

    // if ((cartSummary.cartPrice?.subTotal ?? 0) < vouchers.minimumSpendAmount!) {
    //   return "Voucher condition not satisfied. "
    //       "Sub Total amount should be greater than ${vouchers.minimumSpendAmount}";
    // }

    if (isVoucherDateExpired(vouchers.expiryDate)) {
      return "Voucher expired";
    }

    if (vouchers.customerId != null) {
      if (cartSummary.customers == null) {
        return "Voucher can be applied only to specific customer";
      }

      if (cartSummary.customers!.id != vouchers.customerId) {
        return "Voucher can be applied only to specific customer";
      }
    }

    return null;
  }

  String birthdayVoucherConfiguration(VoucherConfiguration voucher) {
    MyLogUtils.logDebug("voucherDescription voucher : ${voucher.toJson()}");

    String description = "";

    if (voucher.flatAmount != null && voucher.flatAmount! > 0) {
      description =
          "Voucher for Flat ${getCurrency()} ${voucher.flatAmount} off & valid for ${voucher.validityDays} days.";
    }

    if (voucher.percentage != null && voucher.percentage! > 0) {
      description =
          " Voucher ${voucher.percentage} % off & valid for ${voucher.validityDays} days.";
    }

    return description;
  }
}
