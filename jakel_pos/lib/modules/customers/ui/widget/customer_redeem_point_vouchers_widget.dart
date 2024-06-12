import 'package:flutter/material.dart';
import 'package:jakel_base/constants.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/restapi/generatememberloyaltypointvoucher/model/GenerateMemberLoyaltyPointVoucherRequest.dart';
import 'package:jakel_base/restapi/generatememberloyaltypointvoucher/model/GenerateMemberLoyaltyPointVoucherResponse.dart';
import 'package:jakel_base/restapi/loyaltypointvoucherconfiguration/model/LoyaltyPointVoucherConfigurationResponse.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/custom/MyDataContainerWidget.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_base/widgets/nodatawidget/NoDataWidget.dart';
import 'package:jakel_base/widgets/textfield/MyTextFieldWidget.dart';
import 'package:jakel_pos/modules/customers/CustomersRedeemPointToVouchersViewModel.dart';
import 'package:jakel_pos/modules/customers/ui/widget/customer_vouchers_type_widget.dart';

class CustomerRedeemPointToVouchersWidget extends StatefulWidget {
  final Customers customers;
  final Function? onSelected;

  const CustomerRedeemPointToVouchersWidget(
      {Key? key, required this.customers, this.onSelected})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CustomerRedeemPointToVouchersWidgetState();
  }
}

class _CustomerRedeemPointToVouchersWidgetState
    extends State<CustomerRedeemPointToVouchersWidget> {
  final loyaltyPointsController = TextEditingController();
  final loyaltyPointsNode = FocusNode();

  final customersRedeemPointToVouchersViewModel =
      CustomersRedeemPointToVouchersViewModel();
  Vouchers? selectedVoucher;

  @override
  void initState() {
    super.initState();
    customersRedeemPointToVouchersViewModel
        .getAllLoyaltyPointVoucherConfigurationFromDB();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(10.0),
          width: 600,
          height: 700,
          child: MyDataContainerWidget(
            child: getBodyWidget(),
          ),
        ));
  }

  Widget getBodyWidget() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(getHeader());

    widgets.add(const SizedBox(
      height: 10,
    ));
    widgets.add(const Divider());

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(const Text(
        'Please select voucher configuration to convert redeem points into a selected configuration voucher'));

    widgets.add(const SizedBox(
      height: 15,
    ));

    widgets.add(customerApiWidget());

    if (selectedVoucher != null) {
      widgets.add(const SizedBox(
        height: 10,
      ));

      widgets.add(Text(
          'Available loyalty points: ${getInValue(widget.customers.totalLoyaltyPoints)}'));

      widgets.add(const SizedBox(
        height: 15,
      ));

      widgets.add(SizedBox(
        height: 40,
        child: Row(
          children: [
            Expanded(
                flex: 3,
                child: MyTextFieldWidget(
                  enabled: false,
                  controller: loyaltyPointsController,
                  node: loyaltyPointsNode,
                  onChanged: (value) {
                    if (loyaltyPointsController.text.isNotEmpty) {
                      bool value = customersRedeemPointToVouchersViewModel
                          .loyaltyPointsCheck(
                              loyaltyPointsController.text.toString(),
                              getInValue(widget.customers.totalLoyaltyPoints),
                              selectedVoucher
                                      ?.promotionTiers?.first.loyaltyPoint ??
                                  0);

                      if (!value) {
                        setState(() {
                          loyaltyPointsController.text =
                              loyaltyPointsController.text.substring(
                                  0, loyaltyPointsController.text.length - 1);
                          loyaltyPointsController.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: loyaltyPointsController.text.length));
                        });
                      }
                    }
                  },
                  onSubmitted: (value) {},
                  hint: 'Selected Loyalty Points',
                )),
            const SizedBox(
              width: 15,
            ),
            Expanded(
                child: SizedBox(
                    height: 38,
                    child: selectedVoucher != null
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary:
                                    Theme.of(context).colorScheme.tertiary),
                            onPressed: () async {
                              if (loyaltyPointsController.text.isNotEmpty) {
                                if (int.parse(loyaltyPointsController.text
                                        .toString()) ==
                                    (selectedVoucher?.promotionTiers?.first
                                            .loyaltyPoint ??
                                        0)) {
                                  GenerateMemberLoyaltyPointVoucherRequest
                                      request =
                                      GenerateMemberLoyaltyPointVoucherRequest(
                                          loyaltyPoints: int.parse(
                                              loyaltyPointsController.text),
                                          voucherConfigurationId:
                                              selectedVoucher?.id ?? 0,
                                          memberId: widget.customers.id);
                                  GenerateMemberLoyaltyPointVoucherResponse
                                      memberships =
                                      await customersRedeemPointToVouchersViewModel
                                          .getGenerateMemberLoyaltyPointVouchers(
                                              request);
                                  if (memberships.voucher != null &&
                                      widget.onSelected != null) {
                                    widget.onSelected!(memberships);
                                    showToast(
                                        'Voucher create successfull', context);
                                  } else {
                                    showToast('Voucher not create successfull',
                                        context);
                                  }
                                  Navigator.pop(context);
                                } else {
                                  showToast(
                                      'Please add required loyaltyPoints as per selected configuration',
                                      context);
                                }
                              } else {
                                showToast(
                                    'Please add some loyaltyPoints', context);
                              }
                            },
                            child: Text("Go", style: TextStyle(fontSize: 15)),
                          )
                        : SizedBox()))
          ],
        ),
      ));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  Widget getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            child: Text(
          "${widget.customers.firstName}'s Redeem Points to Vouchers",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        )),
        MyInkWellWidget(
            child: const Icon(Icons.close),
            onTap: () {
              Navigator.pop(context);
            })
      ],
    );
  }

  Widget customerApiWidget() {
    return StreamBuilder<LoyaltyPointVoucherConfigurationResponse>(
      stream: customersRedeemPointToVouchersViewModel.responseSubject,
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return const MyLoadingWidget();
        // }
        if (snapshot.hasError) {
          showToast('Error generating birthday voucher.Please try again later!',
              context);
          return const NoDataWidget();
        }
        if (snapshot.connectionState == ConnectionState.active) {
          LoyaltyPointVoucherConfigurationResponse? response = snapshot.data;
          if (response != null &&
              response.vouchers != null &&
              response.vouchers!.isNotEmpty) {
            List<Widget> widgets = List.empty(growable: true);
            response.vouchers?.forEach((element) {
              widgets.add(customerVoucherRowWidget(element));
              widgets.add(const SizedBox(
                height: 10,
              ));
              widgets.add(const Divider());
            });
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: widgets,
            );
          } else {
            showToast(
                'Error generating birthday voucher.Please try again later!',
                context);
            return const NoDataWidget();
          }
        }
        return Container();
      },
    );
  }

  Vouchers? selectedVoucherType;

  Widget customerVoucherRowWidget(Vouchers voucher) {
    List<Widget> widgets = List.empty(growable: true);
    widgets.add(Text(
      "${voucher.voucherType?.replaceAll("_", " ")}",
      style: Theme.of(context).textTheme.labelLarge,
    ));
    widgets.add(const SizedBox(height: 10));
    widgets.add(Row(
      children: [
        Expanded(child: Text("Type : ${voucher.excludeByType}")),
        Expanded(
            child: Container(
          alignment: Alignment.center,
          child: Text(
            "Validity Days : ${voucher.validityDays ?? noData} day's",
          ),
        ))
      ],
    ));
    widgets.add(const SizedBox(height: 10));
    widgets.add(Row(
      children: [
        Expanded(
            child: Text(
          "Start Date: ${voucher.startDate ?? noData}",
          style: Theme.of(context).textTheme.labelMedium,
        )),
        Expanded(
            child: Container(
                alignment: Alignment.center,
                child: Text(
                  "End Date: ${voucher.endDate ?? noData}",
                  style: Theme.of(context).textTheme.labelMedium,
                )))
      ],
    ));
    widgets.add(const SizedBox(height: 15));
    widgets.add(Expanded(
        child: GestureDetector(
            onTap: () {
              if (voucher.promotionTiers != null &&
                  voucher.promotionTiers!.length > 1) {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return CustomerVouchersTypeWidget(
                          vouchers: voucher,
                          useMinimumSpendAmount:
                              voucher.useMinimumSpendAmount ?? 0.00,
                          onSelected: (int selectPromotionTiers) async {
                            voucher.selectPromotionTiers = selectPromotionTiers;
                            selectedVoucherType = voucher;
                            customersRedeemPointToVouchersViewModel
                                .getVoucherType(
                                    voucher.promotionTiers![
                                        voucher.selectPromotionTiers],
                                    voucher.useMinimumSpendAmount ?? 0.00);
                            selectedVoucher = null;
                            setState(() {});
                          });
                    });
              }
            },
            child: Container(
                color: Colors.transparent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            "Voucher Type ",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                            child: Container(
                                child: customerVoucherTypeWidget(voucher)))
                      ],
                    ),
                    const Expanded(
                        child: Center(
                      child: Icon(Icons.arrow_circle_down_sharp),
                    ))
                  ],
                )))));

    widgets.add(const SizedBox(height: 10));

    return MyInkWellWidget(
        child: Container(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            decoration: BoxDecoration(
                color: selectedVoucher == null
                    ? Colors.white
                    : selectedVoucher == voucher
                        ? Colors.red.shade50
                        : Colors.white,
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: IntrinsicHeight(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: widgets),
            )),
        onTap: () {
          setState(() {
            if (getInValue(widget.customers.totalLoyaltyPoints) >=
                (voucher.promotionTiers![voucher.selectPromotionTiers]
                        .loyaltyPoint ??
                    0)) {
              selectedVoucher = voucher;
              loyaltyPointsController.text = (voucher
                          .promotionTiers![voucher.selectPromotionTiers]
                          .loyaltyPoint ??
                      0)
                  .toString();
            } else {
              showToast(
                  'Loyalty Points are not enough for the selected configuration',
                  context);
            }
          });
        });
  }

  Widget customerVoucherTypeWidget(Vouchers voucher) {
    return StreamBuilder<String>(
      stream:
          customersRedeemPointToVouchersViewModel.responseVoucherTypeSubject,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          String response = snapshot.data ?? "--";
          if (selectedVoucherType == voucher) {
            return Text(
              response,
              style: Theme.of(context).textTheme.labelMedium,
            );
          }
        }
        return Text(
          customersRedeemPointToVouchersViewModel.voucherType(
              voucher.promotionTiers?[voucher.selectPromotionTiers],
              voucher.useMinimumSpendAmount ?? 0.00),
          style: Theme.of(context).textTheme.labelMedium,
        );
      },
    );
  }
}
