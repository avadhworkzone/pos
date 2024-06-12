import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:jakel_base/constants.dart';
import 'package:jakel_base/restapi/counters/model/ShiftDetailsResponse.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/utils/num_utils.dart';

import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/button/MyPrimaryButton.dart';
import 'package:jakel_base/widgets/custom/MyDataContainerWidget.dart';

import 'package:jakel_base/widgets/custom/my_small_box_widget.dart';
import 'package:jakel_base/widgets/custom/my_square_content_widget.dart';

import 'package:jakel_pos/modules/shiftclose/ShiftCloseViewModel.dart';
import 'package:jakel_pos/modules/shiftclose/ui/widgets/payments_declaration_widget.dart';
import 'package:jakel_pos/modules/shiftclose/ui/widgets/payments_info_widget.dart';

import 'package:jakel_pos/modules/shiftclose/ui/widgets/sales_info_widget.dart';
import 'package:jakel_pos/modules/shiftclose/ui/widgets/shift_close_inherited_widget.dart';
import 'package:jakel_pos/modules/shiftclose/ui/widgets/store_manager_authorization.dart';
import 'package:jakel_pos/routing/route_names.dart';

class ShiftDetailsWidget extends StatefulWidget {
  final CounterClosingDetails counter;
  final Function onDeclarationDone;
  final Function onDeclarationUpdated;
  final Function onRemoveDeclaration;
  final Function onStoreManagerSelected;
  final Function printDeclaration;
  final bool isHoldSalesAvailable;

  const ShiftDetailsWidget({
    Key? key,
    required this.counter,
    required this.printDeclaration,
    required this.onDeclarationDone,
    required this.onRemoveDeclaration,
    required this.onDeclarationUpdated,
    required this.onStoreManagerSelected,
    required this.isHoldSalesAvailable,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ShiftDetailsWidgetState();
  }
}

class _ShiftDetailsWidgetState extends State<ShiftDetailsWidget>
    with SingleTickerProviderStateMixin {
  bool isShiftDeclarationDone = false;

  AnimationController? _controller;
  final viewModel = ShiftCloseViewModel();

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
    viewModel.closeObservable();
  }

  @override
  Widget build(BuildContext context) {
    isShiftDeclarationDone = ShiftCloseInheritedWidget.of(context)
        .shiftDeclaration
        .isDeclarationDone!;

    return SingleChildScrollView(
      controller: ScrollController(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: getWidgets(),
      ),
    );
  }

  List<Widget> getWidgets() {
    List<Widget> widgets = List.empty(growable: true);
    widgets.add(const SizedBox(
      height: 20,
    ));

    widgets.add(Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("User Info",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold)),
          MyOutlineButton(
              text: "Print Opening Balance",
              onClick: () {
                viewModel
                    .printOpeningBalance(widget.counter.openingBalance ?? 0);
              })
        ],
      ),
    ));
    widgets.add(const SizedBox(
      height: 20,
    ));

    widgets.add(Wrap(
      children: [
        MySmallBoxWidget(
            title: "Counter", value: widget.counter.counterName ?? noData),
        MySmallBoxWidget(
            title: "Cashier Name", value: widget.counter.cashierName ?? noData),
        MySmallBoxWidget(
            title: "Business Day",
            value: widget.counter.openingDateTime ?? noData),
      ],
    ));
    widgets.add(const SizedBox(
      height: 20,
    ));

    widgets.add(Padding(
      padding: const EdgeInsets.all(8),
      child: Text("Transaction Info",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold)),
    ));

    widgets.add(const SizedBox(
      height: 20,
    ));

    widgets.add(getBasicDetails());

    widgets.add(const SizedBox(
      height: 20,
    ));

    //Show only declaration is done.

    if (widget.isHoldSalesAvailable) {
      widgets.add(Padding(
        padding: const EdgeInsets.all(8),
        child: Text("Please clear hold sales to proceed with declaration.",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold)),
      ));
    } else {
      if (isShiftDeclarationDone) {
        if (ShiftCloseInheritedWidget.of(context).isPaymentMisMatch()) {
          widgets.add(Padding(
            padding: const EdgeInsets.all(8),
            child: Text("Authorizer Info",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold)),
          ));

          widgets.add(const SizedBox(
            height: 20,
          ));

          widgets.add(MyDataContainerWidget(
              child: StoreManagerAuthorization(
                  onStoreManagerSelected: widget.onStoreManagerSelected)));

          widgets.add(const SizedBox(
            height: 20,
          ));
        }

        widgets.add(Padding(
          padding: const EdgeInsets.all(8),
          child: Text("Payments Info",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold)),
        ));

        widgets.add(const SizedBox(
          height: 20,
        ));

        widgets.add(getPaymentsWidgets());

        widgets.add(const SizedBox(
          height: 20,
        ));

        widgets.add(Padding(
          padding: const EdgeInsets.all(8),
          child: Text("Sales Info",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold)),
        ));

        widgets.add(const SizedBox(
          height: 20,
        ));

        widgets.add(Container(
          margin: const EdgeInsets.only(left: 8, right: 8),
          child: SalesInfoWidget(counter: widget.counter),
        ));

        widgets.add(const SizedBox(
          height: 20,
        ));

        widgets.add(Row(
          children: [
            MyOutlineButton(
              text: "Redo Declaration",
              onClick: () {
                widget.onRemoveDeclaration();
              },
            ),
            const SizedBox(
              width: 10,
            ),
            MyOutlineButton(
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                // If the button is pressed, return green, otherwise blue
                if (states.contains(MaterialState.pressed)) {
                  return Colors.blueGrey;
                }
                return Colors.green;
              }),
              text: "Print Declaration",
              onClick: () {
                widget.printDeclaration();
              },
            ),
            const SizedBox(
              width: 10,
            ),
            MyOutlineButton(
              text: "Declaration Attempts",
              onClick: () {
                Navigator.pushNamed(context, PaymentDeclarationAttemptsRoute,
                    arguments: false);
              },
            ),
          ],
        ));

        widgets.add(const SizedBox(
          height: 10,
        ));
      } else {
        widgets.add(Padding(
          padding: const EdgeInsets.all(8),
          child: Text("Payments Declaration",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold)),
        ));

        widgets.add(const SizedBox(
          height: 20,
        ));

        widgets.add(PaymentsDeclarationWidget(
          counter: widget.counter,
          onPaymentDeclaration: (HashMap<int, double> declaration) {
            widget.onDeclarationUpdated(declaration);
          },
        ));
        widgets.add(const SizedBox(
          height: 15,
        ));
        widgets.add(Row( children: getUsedBookingChildren()));
        widgets.add(const SizedBox(
          height: 30,
        ));

        widgets.add(MyOutlineButton(
          text: "Declaration Done",
          onClick: () {
            widget.onDeclarationDone();
          },
        ));

        widgets.add(const SizedBox(
          height: 20,
        ));
      }
    }

    return widgets;
  }

  ///Used Booking
  List<Widget> getUsedBookingChildren() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(const SizedBox(
      width: 15,
    ));
    widgets.add(Expanded(
      flex: 1,
      child: Text(
        "Used Booking",
        style: Theme.of(context).textTheme.bodyMedium,
        ),
    ));
    widgets.add(const SizedBox(
      width: 15,
    ));
    widgets.add(Expanded(
      flex: 1,
      child: Text(
       // getReadableAmount("RM",customRound((widget.counter.totalBookingPaymentUsedAmount ?? 0.00),2)),
       "${customRound((widget.counter.totalBookingPaymentUsedAmount ?? 0.00),2)}",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    ));
    widgets.add(const SizedBox(
      width: 10,
    ));

    widgets.add(const SizedBox(
      width: 10,
    ));

    return widgets;
  }

  Widget getBasicDetails() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(MySquareContentWidget(
        title: "Sales",
        value: '${widget.counter.totalSales ?? 0}',
        color: Colors.black,
        isSelected: true,
        size: 115));

    widgets.add(MySquareContentWidget(
        title: "Layaway",
        value: '${getInValue(widget.counter.totalLayawaySales ?? 0)}',
        color: Colors.green,
        isSelected: true,
        size: 115));

    widgets.add(MySquareContentWidget(
        title: "Voided",
        value: '${widget.counter.totalVoidedSales ?? 0}',
        color: Colors.brown,
        isSelected: true,
        size: 115));

    widgets.add(MySquareContentWidget(
        title: "Returns",
        value: '${widget.counter.totalSaleReturns ?? 0}',
        color: Colors.grey,
        isSelected: true,
        size: 115));

    widgets.add(MySquareContentWidget(
        title: "Vouchers",
        value: '${widget.counter.totalVouchersUsed ?? 0}',
        color: Colors.orangeAccent,
        isSelected: true,
        size: 115));

    widgets.add(MySquareContentWidget(
        title: "CashBack",
        value: '${widget.counter.totalCashback ?? 0}',
        color: Colors.blueGrey,
        isSelected: true,
        size: 115));

    widgets.add(MySquareContentWidget(
        title: "Vouchers Generated",
        value: '${widget.counter.totalVouchersGenerated ?? 0}',
        color: Colors.teal,
        isSelected: true,
        size: 115));

    widgets.add(MySquareContentWidget(
        title: "New Booking",
        value: '${widget.counter.totalNewBookingPayments ?? 0}',
        color: Colors.blue,
        isSelected: true,
        size: 115));

    widgets.add(MySquareContentWidget(
        title: "User Booking",
        value: '${widget.counter.totalUsedBookingPayments ?? 0}',
        color: Colors.indigo,
        isSelected: true,
        size: 115));

    return IntrinsicHeight(
      child: Wrap(
        runSpacing: 5.0,
        spacing: 5.0,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: widgets,
      ),
    );
  }

  Widget getPaymentsWidgets() {
    return PaymentsInfoWidget(counter: widget.counter);
  }
}
