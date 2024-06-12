import 'dart:convert';

import 'package:jakel_base/database/loyaltypointvoucherconfiguration/LoyaltyPointVoucherConfigurationLocalApi.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/restapi/customers/model/MemberShipPointsData.dart';
import 'package:jakel_base/restapi/customers/model/MembershipResponse.dart';
import 'package:jakel_base/restapi/generatememberloyaltypointvoucher/GenerateMemberLoyaltyPointVoucherApi.dart';
import 'package:jakel_base/restapi/generatememberloyaltypointvoucher/model/GenerateMemberLoyaltyPointVoucherRequest.dart';
import 'package:jakel_base/restapi/generatememberloyaltypointvoucher/model/GenerateMemberLoyaltyPointVoucherResponse.dart';
import 'package:jakel_base/restapi/loyaltypointvoucherconfiguration/model/LoyaltyPointVoucherConfigurationResponse.dart';

import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';

import 'package:rxdart/rxdart.dart';

class CustomersRedeemPointToVouchersViewModel extends BaseViewModel {
  var responseSubject =
      PublishSubject<LoyaltyPointVoucherConfigurationResponse>();

  Stream<LoyaltyPointVoucherConfigurationResponse> get responseStream =>
      responseSubject.stream;

  void closeObservable() {
    responseSubject.close();
  }

  ///Get all Loyalty Point Voucher Configuration from local
  Future<void> getAllLoyaltyPointVoucherConfigurationFromDB() async {
    var api = locator.get<LoyaltyPointVoucherConfigurationLocalApi>();

    try {
      LoyaltyPointVoucherConfigurationResponse?
          mLoyaltyPointVoucherConfigurationResponse = await api.getConfig();
      MyLogUtils.logDebug(
          "_downloadLoyaltyPointVoucherConfiguration  ${jsonEncode(mLoyaltyPointVoucherConfigurationResponse)}");
      responseSubject.sink.add(mLoyaltyPointVoucherConfigurationResponse ??
          LoyaltyPointVoucherConfigurationResponse());
    } catch (e) {
      MyLogUtils.logDebug("createCustomer exception $e");
      responseSubject.sink.addError(e);
    }
  }

  Future<GenerateMemberLoyaltyPointVoucherResponse>
      getGenerateMemberLoyaltyPointVouchers(
          GenerateMemberLoyaltyPointVoucherRequest request) async {
    MyLogUtils.logDebug(
        "GenerateMemberLoyaltyPointVoucherRequest exception ${jsonEncode(request)}");
    try {
      var localApi = locator.get<GenerateMemberLoyaltyPointVoucherApi>();
      GenerateMemberLoyaltyPointVoucherResponse memberships =
          await localApi.generateMemberLoyaltyPointVoucher(request);

      if (memberships != null) {
        return memberships;
      }
      return GenerateMemberLoyaltyPointVoucherResponse();
    } catch (e) {
      MyLogUtils.logDebug(
          "GenerateMemberLoyaltyPointVoucherRequest exception ${e.toString()}");
      return GenerateMemberLoyaltyPointVoucherResponse();
    }
  }

  var responseVoucherTypeSubject =
  PublishSubject<String>();

  Stream<String> get responseVoucherTypeStream =>
      responseVoucherTypeSubject.stream;

  void closeVoucherTypeObservable() {
    responseVoucherTypeSubject.close();
  }

   getVoucherType(PromotionTiers mPromotionTiers,double minimumSpendAmount) {
    responseVoucherTypeSubject.sink.add(voucherType(mPromotionTiers,minimumSpendAmount));
  }

  String voucherType(PromotionTiers? mPromotionTiers ,double minimumSpendAmount) {
    if (mPromotionTiers == null) {
      return "--";
    } else {
      if (mPromotionTiers.percentage != 0) {
        return "Spaned ${mPromotionTiers.loyaltyPoint} Point to get ${mPromotionTiers.percentage} % off with minimum spend amount of $minimumSpendAmount";
      } else {
        return "Spaned ${mPromotionTiers.loyaltyPoint} Point to get ${mPromotionTiers.flatAmount} RM off with minimum spend amount of $minimumSpendAmount";
      }
    }
  }

  bool loyaltyPointsCheck(String value, int loyaltyPoints, int  voucherRequiredLoyaltyPoints) {
    if (isNumeric(value)) {

      if (int.parse(value) > voucherRequiredLoyaltyPoints) {
        return false;
      }

      if (int.parse(value) <= loyaltyPoints) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  bool isNumeric(String str) {
    if (int.tryParse(str) != null) {
      return true;
    } else {
      return false;
    }
  }
}
