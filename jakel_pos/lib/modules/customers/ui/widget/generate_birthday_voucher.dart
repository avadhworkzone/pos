import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/restapi/vouchers/model/BirthdayVoucherResponse.dart';
import 'package:jakel_base/restapi/vouchers/model/VoucherConfigurationResponse.dart';
import 'package:jakel_base/restapi/vouchers/model/VouchersListResponse.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_pos/modules/customers/CustomersViewModel.dart';
import 'package:jakel_pos/modules/customers/ui/widget/generate_birthday_voucher_dialog.dart';

import '../../../vouchers/VouchersViewModel.dart';

class GenerateBirthdayVoucher extends StatefulWidget {
  final Customers customer;
  final Function onCustomerUpdated;
  final List<VoucherConfiguration> allVoucherConfigurations;

  const GenerateBirthdayVoucher(
      {Key? key,
      required this.allVoucherConfigurations,
      required this.customer,
      required this.onCustomerUpdated})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GenerateBirthdayVoucherState();
  }
}

class _GenerateBirthdayVoucherState extends State<GenerateBirthdayVoucher> {
  final voucherViewModel = VouchersViewModel();
  final customerViewModel = CustomersViewModel();
  VoucherConfiguration? birthConfiguration;
  bool callApi = false;
  Vouchers? birthDayVoucher;
  bool canShowDialog = true;

  @override
  Widget build(BuildContext context) {
    birthConfiguration = voucherViewModel.canGenerateBirthdayVoucher(
        widget.allVoucherConfigurations, widget.customer);

    MyLogUtils.logDebug(
        "canGenerateBirthdayVoucher : ${birthConfiguration?.toJson()}");

    if (birthConfiguration != null) {
      if (canShowDialog && !(widget.customer.voucherGenerated ?? false)) {
        showPopup();
      }
      return getRootWidget();
    }

    return Container();
  }

  void showVoucherDialog() {
    canShowDialog = false;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return GenerateBirthdayVoucherDialog(
          customers: widget.customer,
          birthConfiguration: birthConfiguration!,
          generateVoucher: () {
            _generateVoucher();
          },
        );
      },
    );
  }

  Widget getRootWidget() {
    if (callApi) {
      return apiWidget();
    }

    if (widget.customer.voucherGenerated == true) {
      return MyOutlineButton(
          text: "Print Birthday Voucher",
          backgroundColor: MaterialStateProperty.all(Colors.green),
          onClick: () {
            voucherViewModel.printBirthdayVoucherIfAvailable(widget.customer);
          });
    }

    return MyOutlineButton(
        text: "Generate Birthday Voucher",
        backgroundColor: MaterialStateProperty.all(Colors.green),
        onClick: () {
          _generateVoucher();
        });
  }

  var isApiRequested = false; // To avoid duplicate request.

  void _generateVoucher() {
    setState(() {
      if (!isApiRequested) {
        isApiRequested = true;
        callApi = true;
        voucherViewModel.generateBirthdayVoucher(
            widget.customer, birthConfiguration!);
      }
    });
  }

  Widget apiWidget() {
    return StreamBuilder<BirthdayVoucherResponse>(
      stream: voucherViewModel.responseSubject,
      // ignore: missing_return, missing_return
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyLoadingWidget();
        }
        if (snapshot.hasError) {
          callApi = false;
          showToast('Error generating birthday voucher.Please try again later!',
              context);
          return getRootWidget();
        }
        if (snapshot.connectionState == ConnectionState.active) {
          var response = snapshot.data;
          if (response != null && response.birthdayVoucher != null) {
            birthDayVoucher = response.birthdayVoucher;
            customerViewModel.getCustomerDetails(widget.customer);
            return customerApiWidget();
          } else {
            callApi = false;
            showToast(
                response?.message ??
                    'Error generating birthday voucher.Please try again later!',
                context);
            return getRootWidget();
          }
        }
        return Container();
      },
    );
  }

  Widget customerApiWidget() {
    return StreamBuilder<CustomersResponse>(
      stream: customerViewModel.responseSubject,
      // ignore: missing_return, missing_return
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyLoadingWidget();
        }
        if (snapshot.hasError) {
          callApi = false;
          showToast('Error generating birthday voucher.Please try again later!',
              context);
          return getRootWidget();
        }
        if (snapshot.connectionState == ConnectionState.active) {
          var response = snapshot.data;
          if (response != null && response.customer != null) {
            showToast("Successfully generated birthday Voucher!", context);
            onCustomerUpdated(response.customer!);
            return const SizedBox();
          } else {
            callApi = false;
            showToast(
                'Error generating birthday voucher.Please try again later!',
                context);
            return getRootWidget();
          }
        }
        return Container();
      },
    );
  }

  Future<void> onCustomerUpdated(Customers customers) async {
    customerViewModel.closeObservable();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onCustomerUpdated(customers);
    });
  }

  Future<void> showPopup() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showVoucherDialog();
    });
  }
}
