import 'package:flutter/material.dart';
import 'package:jakel_base/jakel_base.dart';
import 'package:jakel_base/restapi/counters/model/ShiftDetailsResponse.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/custom/MyDataContainerWidget.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_pos/modules/shiftclose/ShiftCloseViewModel.dart';

class SalesInfoWidget extends StatelessWidget {
  final CounterClosingDetails counter;

  SalesInfoWidget({Key? key, required this.counter}) : super(key: key);
  final viewModel = ShiftCloseViewModel();

  @override
  Widget build(BuildContext context) {
    return MyDataContainerWidget(
      child: IntrinsicHeight(
        child: getWidget(context),
      ),
    );
  }

  Widget getWidget(BuildContext context) {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(getCashDetails(
        context, "Opening Balance", counter.openingBalance ?? 0.0));

    widgets.add(const Divider());

    widgets.add(getCashDetails(
        context, "Sales Amount", counter.totalSalesAmount ?? 0.0));

    widgets.add(const Divider());

    widgets.add(getCashDetails(
        context, "Round off", counter.totalSalesRoundOff ?? 0.0));

    widgets.add(const Divider());

    widgets.add(getCashDetails(
        context, "Discount Amount", counter.totalDiscountAmount ?? 0.0));

    widgets.add(const Divider());

    widgets.add(getCashDetails(
        context, "Sale Returns Amount", counter.totalSaleReturnsAmount ?? 0.0));

    widgets.add(const Divider());

    widgets.add(getCashDetails(context, "Item wise discount",
        counter.totalItemWiseDiscountAmount ?? 0.0));

    widgets.add(const Divider());

    widgets.add(getCashDetails(context, "Cart Wide discount",
        counter.totalCartWideDiscountAmount ?? 0.0));

    widgets.add(const Divider());

    widgets.add(getCashDetails(
        context, "Layaway Sales", counter.totalLayawaySalesAmount ?? 0.0));

    widgets.add(const Divider());

    widgets.add(getCashDetails1(context, "Layaway Sale Transactions",
        getInValue(counter.totalLayawaySales)));

    widgets.add(const Divider());

    widgets.add(getCashDetails1(
        context, "Total Voided Sales", getInValue(counter.totalVoidedSales)));

    widgets.add(const Divider());

    widgets.add(getCashDetails(
        context, "Void Sales Amount", counter.totalVoidedSalesAmount ?? 0.0));

    widgets.add(const Divider());

    widgets.add(
        getCashDetails(context, "Total Tax", counter.totalTaxAmount ?? 0.0));

    widgets.add(const Divider());

    widgets.add(
        getCashDetails(context, "Cash In", counter.totalCashInsAmount ?? 0.0));

    widgets.add(const Divider());

    widgets.add(getCashDetails(
        context, "Cash Out", counter.totalCashOutsAmount ?? 0.0));

    widgets.add(const Divider());

    widgets.add(getCashDetails(context, "Credit Notes Used",
        counter.totalCreditNotesUsedAmount ?? 0.0));

    widgets.add(const Divider());

    widgets.add(getCashDetails(context, "Credit Notes Refunded",
        counter.totalCreditNotesRefundedAmount ?? 0.0));

    widgets.add(const Divider());

    widgets.add(getCashDetails(
        context, "Booking Payments", counter.totalBookingPaymentAmount ?? 0.0));

    widgets.add(const Divider());

    widgets.add(getCashDetails(context, "Booking Payments Refunded",
        counter.totalBookingPaymentRefundedAmount ?? 0.0));

    widgets.add(const Divider());

    widgets.add(getCashDetails(context, "Booking Payments Used",
        counter.totalBookingPaymentUsedAmount ?? 0.0));

    widgets.add(const Divider());

    widgets.add(getCashDetails(
      context,
      "Petty Cash Used",
      counter.totalPettyCashUsageAmount ?? 0.0,
    ));

    widgets.add(const Divider());

    widgets.add(getCashDetails(
      context,
      "Total Cashback Amount",
      counter.totalCashbackAmount ?? 0,
    ));

    widgets.add(const Divider());

    widgets.add(getCashDetails(
      context,
      "Total Vouchers Discount Amount",
      counter.totalVoucherDiscountAmount ?? 0,
    ));

    widgets.add(const Divider());

    // widgets.add(getCashDetails(
    //     context, "Petty Cash Used", counter.totalPettyCashUsageAmount ?? 0.0,
    //     onClick: () {
    //   showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (context) {
    //       return const PettyCashReportDialog(
    //         showAsDialog: true,
    //       );
    //     },
    //   );
    // }));

    return Column(
      children: widgets,
    );
  }

  Widget getCashDetails(BuildContext context, String key, double value,
      {GestureTapCallback? onClick}) {
    return MyInkWellWidget(
        onTap: onClick,
        child: Row(children: [
          Expanded(
            flex: 2,
            child: Text(
              key,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Text(
            getCurrency(),
            style: Theme.of(context).textTheme.caption,
          ),
          Expanded(
              flex: 1,
              child: Text(
                getOnlyReadableAmount(value),
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.bodyLarge,
              )),
          onClick != null
              ? const Icon(
                  Icons.chevron_right_sharp,
                  size: 20,
                )
              : const SizedBox(
                  width: 20,
                )
        ]));
  }

  Widget getCashDetails1(BuildContext context, String key, int? value,
      {GestureTapCallback? onClick}) {
    return MyInkWellWidget(
        onTap: onClick,
        child: Row(children: [
          Expanded(
            flex: 2,
            child: Text(
              key,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Text(
            "Count",
            style: Theme.of(context).textTheme.caption,
          ),
          Expanded(
              flex: 1,
              child: Text(
                '$value',
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.bodyLarge,
              )),
          onClick != null
              ? const Icon(
                  Icons.chevron_right_sharp,
                  size: 20,
                )
              : const SizedBox(
                  width: 20,
                )
        ]));
  }
}
