import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jakel_base/constants.dart';
import 'package:jakel_base/database/sale/model/sale_returns_data.dart';
import 'package:jakel_base/jakel_base.dart';
import 'package:jakel_base/restapi/companyconfiguration/model/CompanyConfigurationResponse.dart';
import 'package:jakel_base/restapi/creditnotes/model/CreditNotesResponse.dart';
import 'package:jakel_base/restapi/managers/model/StoreManagersResponse.dart';
import 'package:jakel_base/restapi/sales/model/CancelLayawayAmountRequest.dart';

import 'package:jakel_base/restapi/sales/model/history/SalesResponse.dart';
import 'package:jakel_base/restapi/sales/model/history/SaveSaleResponse.dart';
import 'package:jakel_base/restapi/vouchers/model/VouchersListResponse.dart';
import 'package:jakel_base/sale/sale_helper.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/my_date_utils.dart';

import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/custom/MyIconTextWidget.dart';
import 'package:jakel_base/widgets/custom/MyLeftRightWidget.dart';
import 'package:jakel_base/widgets/custom/my_small_box_widget.dart';
import 'package:jakel_base/widgets/custom/my_vertical_divider.dart';
import 'package:jakel_pos/modules/newsale/NewSaleViewModel.dart';
import 'package:jakel_pos/modules/refundCreditNote/ui/widgets/refund_manager_authorization_widget.dart';
import 'package:jakel_pos/modules/saleshistory/SalesHistoryViewModel.dart';
import 'package:jakel_pos/modules/saleshistory/ui/sale_history_inherited_widget.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/dialog/initiate_sale_return_dialog.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/dialog/layaway_payment_dialog.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/history/manager_authorization_widget.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/voidsale/void_sale_widget.dart';

class RegularSalesDetailWidget extends StatefulWidget {
  final String titleInPrintReceipt;
  final Function proceedToSaleReturns;
  final bool showReturnButton;
  final bool showVoidSale;
  final Function refreshWidgetsWithSale;
  final Function refreshWidgetWithPendingLayawaySales;

  const RegularSalesDetailWidget(
      {Key? key,
      required this.showReturnButton,
      required this.refreshWidgetsWithSale,
      required this.refreshWidgetWithPendingLayawaySales,
      required this.proceedToSaleReturns,
      required this.showVoidSale,
      required this.titleInPrintReceipt})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegularSalesDetailWidgetState();
  }
}

class _RegularSalesDetailWidgetState extends State<RegularSalesDetailWidget> {
  final viewModel = SalesHistoryViewModel();
  final newSaleViewModel = NewSaleViewModel();
  late Sales sale;
  var companyConfigurationResponse = CompanyConfigurationResponse();

  @override
  void initState() {
    super.initState();
    //sale = widget.sale;
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.closeObservable();
  }

  @override
  Widget build(BuildContext context) {
    sale = SaleHistoryInheritedWidget.of(context)
        .saleHistoryDataModel
        .selectedSale!;
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        constraints: const BoxConstraints.expand(),
        child: _getRootWidget(),
      ),
    );
  }

  _getRootWidget() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _getChildrenWidgets(),
      ),
    );
  }

  List<Widget> getLayawayInfoWidget() {
    List<Widget> widgets = List.empty(growable: true);
    if (isLayawaySale(sale)) {
      if (isPendingLayawaySale(sale)) {
        widgets.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyOutlineButton(
                text: "Update Layaway Amount",
                onClick: () {
                  showDialog(
                      context: context,
                      builder: (context) => LayawayPaymentDialog(
                            pendingAmount: sale.layawayPendingAmount ?? 0,
                            onLayawayAmountUpdated: (updatedSale) {
                              widget.refreshWidgetsWithSale(updatedSale);
                            },
                            sale: sale,
                          ));
                }),
            MyOutlineButton(
                text: "Cancel Layaway Amount",
                onClick: () {
                  cancelLayawayAmount();
                }),
          ],
        ));
      } else {
        widgets.add(Text(
          "This layaway sale is completed.\n"
          "It will be removed from Pending Layaway Sales after refreshing.\n"
          "You will find this sale in Regular & Completed Layaway Sales.\n",
          style: Theme.of(context).textTheme.caption,
        ));
      }
      widgets.add(const Divider());
    }
    return widgets;
  }

  cancelLayawayAmount() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return RefundManagerAuthorizationWidget(
            sType: "Cancel Layaway Amount",
            onSuccess: (StoreManagers mStoreManagers, String sReason) async {
              MyLogUtils.logDebug(
                  " mStoreManagers cartSummary: ${jsonEncode(mStoreManagers)}");
              CancelLayawayAmountRequest mCancelLayawayAmountRequest =
                  CancelLayawayAmountRequest(
                happenedAt: dateTimeYmdHis24Hour(),
                passcode: mStoreManagers.passcode,
                storeManagerId: mStoreManagers.id,
                reason: sReason,
              );
              bool bCancelLayaway = await viewModel.cancelLayawayAmount(
                  (sale.id ?? 0), mCancelLayawayAmountRequest);
              if (bCancelLayaway) {
                widget.refreshWidgetWithPendingLayawaySales();
              }
            },
          );
        });
  }

  List<Widget> _getChildrenWidgets() {
    String titleInPrintReceipt = widget.titleInPrintReceipt;
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(getTopWidget());

    widgets.add(const Divider());

    widgets.addAll(getLayawayInfoWidget());

    widgets.add(SizedBox(
      width: double.infinity,
      child: MySmallBoxWidget(
          title: "Receipt No",
          value: '${sale.offlineSaleId ?? sale.offlineSaleReturnId}'),
    ));

    widgets.add(Row(
      children: [
        Expanded(
            child: MySmallBoxWidget(
                title: "Cashier", value: viewModel.getCashier(sale))),
        Expanded(
            child: MySmallBoxWidget(
                title: "Counter", value: viewModel.getCounter(sale))),
      ],
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));

    // widgets.add(SizedBox(
    //     width: double.infinity,
    //     child: MySmallBoxWidget(
    //         title: "Member", value: viewModel.getCustomerName(widget.sale))));

    if (sale.userDetails != null) {
      widgets.add(getMemberShipDetails(sale.userDetails!));

      widgets.add(const SizedBox(
        height: 10,
      ));
    }

    widgets.add(getItemsWidgets());

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(getPaymentTypes());

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(getVoucherUsed());

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(getCreditNotes());

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(getVoucherTypes());

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(getCashback());

    widgets.add(const SizedBox(
      height: 10,
    ));
    widgets.add(Padding(
      padding: const EdgeInsets.all(5),
      child: MyLeftRightWidget(
          lText: "Sub Total",
          rStyle: Theme.of(context).textTheme.bodyLarge,
          rText: (titleInPrintReceipt == "Pending Layaway Sale")
              ? viewModel.getPendingLayawaySalesHistorySubTotal(sale)
              : viewModel.getSalesHistorySubTotal(sale)),
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(Padding(
      padding: const EdgeInsets.all(5),
      child: MyLeftRightWidget(
          lText: "Discount",
          rStyle: Theme.of(context).textTheme.bodyLarge,
          rText: (titleInPrintReceipt == "Pending Layaway Sale")
              ? viewModel.getPendingLayawayTotalDiscountAmount(sale)
              : viewModel.getTotalDiscountAmount(sale)),
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(Padding(
      padding: const EdgeInsets.all(5),
      child: MyLeftRightWidget(
          lText: "Tax",
          rStyle: Theme.of(context).textTheme.bodyLarge,
          rText: viewModel.getTax(sale)),
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(Padding(
      padding: const EdgeInsets.all(5),
      child: MyLeftRightWidget(
          lText: "Rounding Adjustment",
          rStyle: Theme.of(context).textTheme.bodyLarge,
          rText: viewModel.getRoundingAdjustment(sale)),
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));
    widgets.add(Padding(
      padding: const EdgeInsets.all(5),
      child: MyLeftRightWidget(
          rStyle: Theme.of(context).textTheme.bodyLarge,
          lText: "Total",
          rText: viewModel.totalAmount(sale)),
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(Padding(
      padding: const EdgeInsets.all(5),
      child: MyLeftRightWidget(
          rStyle: Theme.of(context).textTheme.bodyLarge,
          lText: "Total Paid",
          rText: viewModel.getTotalPaid(sale)),
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));

    if (!isPendingLayawaySale(sale)) {
      widgets.add(Padding(
        padding: const EdgeInsets.all(5),
        child: MyLeftRightWidget(
            rStyle: Theme.of(context).textTheme.bodyLarge,
            lText: "Change Due",
            rText: viewModel.getChangeDue(sale)),
      ));

      widgets.add(const SizedBox(
        height: 10,
      ));
    }

    if (isPendingLayawaySale(sale)) {
      widgets.add(Padding(
        padding: const EdgeInsets.all(5),
        child: MyLeftRightWidget(
            rStyle: const TextStyle(fontSize: 15, color: Colors.red),
            lStyle: const TextStyle(fontSize: 15, color: Colors.red),
            lText: "Pending layaway amount",
            rText: viewModel.getPendingLayawayAmount(sale)),
      ));

      widgets.add(const SizedBox(
        height: 10,
      ));
    }

    widgets.add(SizedBox(
        width: double.infinity,
        child: MySmallBoxWidget(
            title: "Remarks", value: sale.saleNotes ?? noData)));

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(SizedBox(
        width: double.infinity,
        child: MySmallBoxWidget(
            title: "Bill Reference Number",
            value: sale.billReferenceNumber ?? noData)));

    widgets.add(const SizedBox(
      height: 10,
    ));

    return widgets;
  }

  Widget getTopWidget() {
    return getCompanyConfiguration();
  }

  Widget getCompanyConfiguration() {
    return FutureBuilder(
        future: newSaleViewModel.getCompanyConfig(),
        builder: (BuildContext context,
            AsyncSnapshot<CompanyConfigurationResponse?> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              companyConfigurationResponse = snapshot.data!;
            }
          }
          return IntrinsicHeight(child: getActionsWidget());
        });
  }

  Widget getActionsWidget() {
    List<Widget> widgets = List.empty(growable: true);
    if (widget.showVoidSale) {
      widgets.add(MyOutlineButton(
          text: "Void Sale",
          backgroundColor: MaterialStateProperty.all(Colors.grey),
          onClick: () async {
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return VoidSaleWidget(
                  sale: sale,
                );
              },
            );
          }));
    }
    if (widget.showReturnButton) {
      if ((sale.cashback == null || sale.cashback!.isEmpty) &&
          (checkIsValidDate(
              sale.happenedAt,
              salesReturnExpiredDate(
                  companyConfigurationResponse.salesReturnDaysLimit ?? 0,
                  sale.happenedAt ?? "")))) {
        widgets.add(const SizedBox(
          width: 4,
        ));
        widgets.add(MyOutlineButton(
            text: "Return Items",
            backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
            onClick: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return InitiateSaleReturnDialog(
                      returnType: ReturnType.returns,
                      sale: sale,
                      proceedToSaleReturns: (SaleReturnsData saleReturnData) {
                        if (saleReturnData.returnItems!.isNotEmpty) {
                          widget.proceedToSaleReturns(saleReturnData);
                        }
                      });
                },
              );
            }));
      }

      widgets.add(const SizedBox(
        width: 4,
      ));
      widgets.add(MyOutlineButton(
          text: "Exchange",
          onClick: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return InitiateSaleReturnDialog(
                  returnType: ReturnType.exchange,
                  sale: sale,
                  proceedToSaleReturns: widget.proceedToSaleReturns,
                );
              },
            );
          }));

      widgets.add(const SizedBox(
        height: 4,
      ));
    }
    widgets.add(const SizedBox(
      width: 10,
    ));

    widgets.add(Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      width: 60,
      child: MyIconTextWidget(
        iconData: Icons.local_print_shop_rounded,
        text: "Print",
        onTap: () async {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return ManagerAuthorizationWidget(
                onSuccess: () {
                  viewModel.rePrintSale(
                      widget.titleInPrintReceipt, Sale.fromJson(sale.toJson()));
                  showToast("Authorized to re print receipt.", context);
                },
              );
            },
          );
        },
        isRightAligned: false,
      ),
    ));

    widgets.add(const SizedBox(
      width: 10,
    ));

    widgets.add(Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      width: 60,
      child: MyIconTextWidget(
        iconData: Icons.mail_outlined,
        text: "Mail",
        onTap: () async {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return ManagerAuthorizationWidget(
                onSuccess: () {
                  showToast("Authorized to send email", context);
                },
              );
            },
          );
        },
        isRightAligned: false,
      ),
    ));
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: widgets,
    );
  }

  Widget getMemberShipDetails(UserDetails userDetails) {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(getLeftRightText("Name", userDetails.firstName ?? noData));

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(getLeftRightText(
        "Previous Points", '${getInValue(userDetails.previousPoints ?? 0)}'));

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(getLeftRightText("This Sale Points",
        '${getInValue(userDetails.currentSalePoints ?? 0)}'));

    widgets.add(const SizedBox(
      height: 10,
    ));
    widgets.add(getLeftRightText("Accumulated Points",
        '${getInValue(userDetails.accumulatedPoints ?? 0)}'));

    widgets.add(const SizedBox(
      height: 10,
    ));
    return Card(
      elevation: 2,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5),
          child: ExpansionTile(
            backgroundColor: getWhiteColor(context),
            collapsedBackgroundColor: getWhiteColor(context),
            initiallyExpanded: true,
            iconColor: Theme.of(context).primaryColor,
            title: Text("Member",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.subtitle2),
            children: widgets,
          ),
        ),
      ),
    );
  }

  Widget getLeftRightText(String text1, String text2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: SelectableText(
            text1,
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: SelectableText(
            text2,
            style: Theme.of(context).textTheme.caption,
          ),
        )
      ],
    );
  }

  Widget getItemsWidgets() {
    List<Widget> widgets = List.empty(growable: true);

    if (sale.saleItems != null) {
      int page = 1;
      for (SaleItems saleItem in sale.saleItems!) {
        widgets.add(Container(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: getItemsRow(saleItem, page),
        ));
        widgets.add(const Divider());
        page = page + 1;
      }
    }

    if (sale.saleReturnItems != null) {
      int page = 1;
      for (SaleItems saleItem in sale.saleReturnItems!) {
        widgets.add(Container(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: getItemsRow(saleItem, page),
        ));

        // Sale item return reason
        if (saleItem.saleReturnReason != null) {
          widgets.add(const SizedBox(
            height: 5,
          ));
          widgets.add(getLeftRightText(
              "Reason", saleItem.saleReturnReason?.reason ?? noData));
          widgets.add(const SizedBox(
            height: 5,
          ));
        }

        widgets.add(const Divider());
        page = page + 1;
      }
    }

    widgets.add(const Divider(
      color: Colors.black38,
    ));

    String totalItems = getTotalItems(Sale.fromJson(sale.toJson()));
    if (totalItems == "0") {
      totalItems = viewModel.getTotalReturnsItems(sale);
    }
    widgets.add(Container(
        child: getLeftRightText(
      "Total Items",
      totalItems,
    )));

    widgets.add(const SizedBox(
      height: 5,
    ));

    String totalQuantities = getTotalQuantity(Sale.fromJson(sale.toJson()));
    if (totalQuantities == "0") {
      totalQuantities = viewModel.getTotalReturnQuantities(sale);
    }

    widgets.add(Container(
      child: getLeftRightText("Total Quantities", totalQuantities),
    ));

    return Card(
      elevation: 2,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5),
          child: ExpansionTile(
            backgroundColor: getWhiteColor(context),
            collapsedBackgroundColor: getWhiteColor(context),
            initiallyExpanded: true,
            iconColor: Theme.of(context).primaryColor,
            title: Text("Sales Summary",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.subtitle2),
            children: widgets,
          ),
        ),
      ),
    );
  }

  Widget getItemsRow(SaleItems saleItem, int page) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$page. ${viewModel.getSaleItemName(saleItem)}",
                style: Theme.of(context).textTheme.caption,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                maxLines: 1,
              ),
              promoters(saleItem),
              const SizedBox(
                height: 5,
              ),
              Text(
                saleItem.product?.color?.name ?? noData,
                style: Theme.of(context).textTheme.caption,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                saleItem.product?.size?.name ?? noData,
                style: Theme.of(context).textTheme.caption,
              ),
              const SizedBox(
                height: 5,
              ),
              saleItem.complimentary != null
                  ? Text(
                      'FOC',
                      style: Theme.of(context).textTheme.caption,
                    )
                  : Container()
            ],
          ),
        ),
        const SizedBox(
          width: 5.0,
        ),
        Center(
          child: Text(
            viewModel.getSaleItemQty(saleItem),
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        const SizedBox(
          width: 5.0,
        ),
        Expanded(
          child: Text(
            viewModel.getSaleItemPrice(saleItem),
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.end,
          ),
        )
      ],
    );
  }

  Widget promoters(SaleItems item) {
    if (item.promoters == null || item.promoters!.isEmpty) {
      return Container();
    }

    List<InlineSpan> spanTexts = List.empty(growable: true);

    item.promoters?.forEach((element) {
      if (spanTexts.length == 1) {
        spanTexts.add(
          TextSpan(text: ',', style: Theme.of(context).textTheme.caption),
        );
        spanTexts.add(
          TextSpan(text: ' ', style: Theme.of(context).textTheme.caption),
        );
      }
      spanTexts.add(TextSpan(
          text: element.firstName ?? "",
          style: Theme.of(context).textTheme.caption));
    });

    return Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(0.2)),
        ),
        child: Text.rich(TextSpan(text: '', children: spanTexts)));
  }

  Widget getPaymentTypes() {
    if (sale.payments == null) {
      return Container();
    }
    List<Widget> widgets = List.empty(growable: true);

    if (sale.payments != null) {
      int page = 1;
      for (Payments payment in sale.payments!) {
        widgets.add(Container(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: getPaymentTypesRow(payment, page),
        ));
        widgets.add(const Divider());
        page = page + 1;
      }
    }
    return Card(
      elevation: 2,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5),
          child: ExpansionTile(
            backgroundColor: getWhiteColor(context),
            collapsedBackgroundColor: getWhiteColor(context),
            initiallyExpanded: true,
            iconColor: Theme.of(context).primaryColor,
            title: Text("Payments",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.subtitle2),
            children: widgets,
          ),
        ),
      ),
    );
  }

  Widget getPaymentTypesRow(Payments payment, int page) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            "$page. ${viewModel.getPaymentName(payment)}",
            style: Theme.of(context).textTheme.caption,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            maxLines: 1,
          ),
        ),
        const SizedBox(
          width: 5.0,
        ),
        payment.happenedAt != null
            ? Expanded(
                flex: 2,
                child: Text(
                  "at ${payment.happenedAt}",
                  style: Theme.of(context).textTheme.caption,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                ),
              )
            : Container(),
        const SizedBox(
          width: 5.0,
        ),
        Expanded(
          child: Text(
            viewModel.getPaymentAmount(payment),
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.end,
          ),
        )
      ],
    );
  }

  Widget getVoucherUsed() {
    if (sale.payments == null) {
      return Container();
    }
    List<Widget> widgets = List.empty(growable: true);

    if (sale.usedVoucher != null) {
      widgets.add(Container(
        padding: const EdgeInsets.only(left: 15.0, right: 15),
        child: getVoucherUsedRow(sale.usedVoucher!),
      ));
    }

    return Card(
      elevation: 2,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5),
          child: ExpansionTile(
            backgroundColor: getWhiteColor(context),
            collapsedBackgroundColor: getWhiteColor(context),
            initiallyExpanded: true,
            iconColor: Theme.of(context).primaryColor,
            title: Text("Vouchers Used In Sale",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.subtitle2),
            children: widgets,
          ),
        ),
      ),
    );
  }

  Widget getVoucherUsedRow(UsedVoucherInSale voucher) {
    MyLogUtils.logDebug("getVoucherUsedRow ${voucher.toJson()}");

    String type = 'Voucher';
    if (voucher.voucherType != null) {
      if (voucher.voucherType!.contains("BIRTHDAY")) {
        type = 'BIRTHDAY VOUCHER';
      }

      if (voucher.voucherType!.contains("WELCOME_MEMBER")) {
        type = 'WELCOME VOUCHER';
      }
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            type,
            style: Theme.of(context).textTheme.caption,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            maxLines: 1,
          ),
        ),
        const SizedBox(
          width: 5.0,
        ),
        Expanded(
          child: Text(
            getReadableAmount(getCurrency(), voucher.amount ?? 0),
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.end,
          ),
        )
      ],
    );
  }

  Widget getCreditNotes() {
    if (sale.creditNote == null &&
        (sale.creditNotes == null || sale.creditNotes!.isEmpty)) {
      return Container();
    }
    List<Widget> widgets = List.empty(growable: true);

    if (sale.creditNotes != null) {
      int page = 1;
      for (CreditNotes creditNote in sale.creditNotes!) {
        widgets.add(Container(
          child: getCreditNotesRow(creditNote, page),
        ));
        widgets.add(const Divider());
        page = page + 1;
      }
    }

    if (sale.creditNote != null) {
      widgets.add(Container(
        child: getCreditNotesRow(sale.creditNote!, 0),
      ));
    }
    return Card(
      elevation: 2,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5),
          child: ExpansionTile(
            backgroundColor: getWhiteColor(context),
            collapsedBackgroundColor: getWhiteColor(context),
            initiallyExpanded: true,
            iconColor: Theme.of(context).primaryColor,
            title: Text("Credit Note",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.subtitle2),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            expandedAlignment: Alignment.centerLeft,
            children: widgets,
          ),
        ),
      ),
    );
  }

  Widget getCreditNotesRow(CreditNotes creditNotes, int page) {
    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          page > 0
              ? Text(
                  "$page.",
                  style: Theme.of(context).textTheme.caption,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                )
              : Container(),
          const SizedBox(
            height: 5.0,
          ),
          getLeftRightText("ID", '${creditNotes.id ?? noData}'),
          const SizedBox(
            height: 5.0,
          ),
          getLeftRightText("Status", creditNotes.status ?? noData),
          const SizedBox(
            height: 5.0,
          ),
          getLeftRightText("Expiry", creditNotes.expiryDate ?? noData),
          const SizedBox(
            height: 5.0,
          ),
          getLeftRightText("Total",
              getReadableAmount(getCurrency(), creditNotes.totalAmount)),
          const SizedBox(
            height: 5.0,
          ),
          getLeftRightText("Available",
              getReadableAmount(getCurrency(), creditNotes.availableAmount)),
        ],
      ),
    );
  }

  Widget getCreditNoteId(int page, CreditNotes creditNotes) {
    return page > 0
        ? Text(
            "$page. ID: ${creditNotes.id ?? noData}",
            style: Theme.of(context).textTheme.caption,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            maxLines: 1,
          )
        : Text(
            "ID: ${creditNotes.id ?? noData}",
            style: Theme.of(context).textTheme.caption,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            maxLines: 1,
          );
  }

  Widget getVoucherTypes() {
    if (sale.vouchers == null || sale.vouchers!.isEmpty) {
      return Container();
    }

    List<Widget> widgets = List.empty(growable: true);

    if (sale.vouchers != null) {
      int page = 1;
      for (Vouchers voucher in sale.vouchers!) {
        widgets.add(Container(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: getVoucherTypesRow(voucher, page),
        ));
        widgets.add(Container(
          padding: const EdgeInsets.only(left: 10.0, right: 15),
          child: getLeftRightText("Number", voucher.number ?? noData),
        ));
        widgets.add(Container(
          padding: const EdgeInsets.only(left: 10.0, right: 15),
          child: getLeftRightText("Expiry", voucher.expiryDate ?? noData),
        ));
        widgets.add(const Divider());
        page = page + 1;
      }
    }
    return Card(
      elevation: 2,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5),
          child: ExpansionTile(
            backgroundColor: getWhiteColor(context),
            collapsedBackgroundColor: getWhiteColor(context),
            initiallyExpanded: true,
            iconColor: Theme.of(context).primaryColor,
            title: Text("Vouchers Generated",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.subtitle2),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: widgets,
          ),
        ),
      ),
    );
  }

  Widget getVoucherTypesRow(Vouchers payment, int page) {
    var message =
        "$page) Flat RM ${payment.flatAmount} Voucher generated for next sale.";
    if (payment.percentage != null && payment.percentage! > 0) {
      message =
          "$page) ${payment.percentage} % Off Voucher generated for next sale.";
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          message,
          style: Theme.of(context).textTheme.caption,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
          maxLines: 1,
        ),
      ],
    );
  }

  Widget getCashback() {
    if (sale.cashback == null || sale.cashback!.isEmpty) {
      return Container();
    }

    List<Widget> widgets = List.empty(growable: true);

    if (sale.cashback != null) {
      int page = 1;
      for (Cashback payment in sale.cashback!) {
        widgets.add(Container(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: getCashbackRow(payment, page),
        ));
        widgets.add(const Divider());
        page = page + 1;
      }
    }
    return Card(
      elevation: 2,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5),
          child: ExpansionTile(
            backgroundColor: getWhiteColor(context),
            collapsedBackgroundColor: getWhiteColor(context),
            initiallyExpanded: true,
            iconColor: Theme.of(context).primaryColor,
            title: Text("Cashbacks",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.subtitle2),
            children: widgets,
          ),
        ),
      ),
    );
  }

  Widget getCashbackRow(Cashback cashback, int page) {
    var message =
        "${cashback.name} of ${getReadableAmount("RM", cashback.amount)}";

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          message,
          style: Theme.of(context).textTheme.caption,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
          maxLines: 1,
        ),
      ],
    );
  }

  ///Get expire date of the sales return config
  String? salesReturnExpiredDate(
      int? salesReturnDaysLimit, String? happenedAt) {
    return addDaysToTargatedDate(salesReturnDaysLimit ?? 0, happenedAt ?? "");
  }
}
