import 'package:flutter/material.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';

import 'package:jakel_base/widgets/textfield/MyTextFieldWidget.dart';
import 'package:jakel_pos/modules/newsale/ui/widgets/new_sale_inherited_widget.dart';

import 'package:jakel_base/database/sale/model/CartSummary.dart';

class NewSaleDiscountWidget extends StatefulWidget {
  final CartSummary cartSummary;
  final Function viewAllDiscount;
  final Function onVoucherEntered;

  const NewSaleDiscountWidget(
      {Key? key,
      required this.cartSummary,
      required this.viewAllDiscount,
      required this.onVoucherEntered})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NewSaleDiscountWidgetState();
  }
}

class _NewSaleDiscountWidgetState extends State<NewSaleDiscountWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  final promoController = TextEditingController();
  final promoNode = FocusNode();

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cartSummary.cartItems == null ||
        widget.cartSummary.cartItems!.isEmpty) {
      promoController.text = "";
    }

    if (widget.cartSummary.vouchers == null ||
        widget.cartSummary.voucherCode == null) {
      promoController.text = "";
    }

    return Card(
        margin: const EdgeInsets.only(left: 4, right: 4),
        child: Container(
            margin: const EdgeInsets.all(4),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Container(
                    width: 90,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                    ),
                    child: Center(
                      child: Text(
                        "Promotions",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 22,
                  ),
                  Expanded(child: getRootWidget()),
                  const SizedBox(
                    width: 22,
                  ),
                ],
              ),
            )));
  }

  Widget getRootWidget() {
    List<Widget> widgets = List.empty(growable: true);
    widgets.add(const SizedBox(
      height: 10,
    ));
    widgets.add(getPromoCode());
    widgets.add(const SizedBox(
      height: 10,
    ));

    //Add error message widget
    // if (NewSaleInheritedWidget.of(context).cartSummary.voucherErrorMessage !=
    //     null) {
    //   widgets.add(Text(
    //     NewSaleInheritedWidget.of(context).cartSummary.voucherErrorMessage!,
    //     style: const TextStyle(color: Colors.red),
    //   ));
    //   widgets.add(const SizedBox(
    //     height: 10,
    //   ));
    // } else {}

    widgets.add(SizedBox(
      height: 28,
      child: Row(
        children: [
          Expanded(
            flex: 2,
              child: NewSaleInheritedWidget.of(context)
                          .cartSummary
                          .voucherErrorMessage !=
                      null
                  ? Text(
                      NewSaleInheritedWidget.of(context)
                          .cartSummary
                          .voucherErrorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 10),
                    )
                  : Container()),
          Expanded(child: getDiscounts())
        ],
      ),
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));
    return Column(
      children: widgets,
    );
  }

  Widget getPromoCode() {
    return MyTextFieldWidget(
      controller: promoController,
      node: promoNode,
      hint: 'Enter promo code & press enter',
      onSubmitted: (promoCode) {
        setState(() {
          widget.onVoucherEntered(promoCode);
        });
      },
    );
  }

  Widget getDiscounts() {
    return Row(
      children: [
        Expanded(child: getAppliedDiscounts()),
        MyOutlineButton(
            text: "View All Discount",
            onClick: () {
              widget.viewAllDiscount();
            })
      ],
    );
  }

  Widget getAppliedDiscounts() {
    List<Widget> widgets = List.empty(growable: true);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widgets,
      ),
    );
  }
}
