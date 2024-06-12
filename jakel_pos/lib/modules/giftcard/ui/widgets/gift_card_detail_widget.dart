import 'package:flutter/material.dart';
import 'package:jakel_base/constants.dart';
import 'package:jakel_base/restapi/giftcards/model/GiftCardsResponse.dart';
import 'package:jakel_base/widgets/custom/my_small_box_widget.dart';
import 'package:jakel_pos/modules/products/ProductsViewModel.dart';

class GiftCardDetailWidget extends StatefulWidget {
  final GiftCards selectedGiftCards;

  const GiftCardDetailWidget({Key? key, required this.selectedGiftCards})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GiftCardDetailWidgetState();
  }
}

class _GiftCardDetailWidgetState extends State<GiftCardDetailWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final viewModel = ProductsViewModel();

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    viewModel.closeObservable();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      constraints: const BoxConstraints.expand(),
      child: _getRootWidget(),
    );
  }

  _getRootWidget() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _getChildrenWidgets(),
      ),
    );
  }

  List<Widget> _getChildrenWidgets() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(SizedBox(
      width: double.infinity,
      child: MySmallBoxWidget(
          title: "Name", value: widget.selectedGiftCards.type!.name ?? noData),
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(SizedBox(
      width: double.infinity,
      child: MySmallBoxWidget(
          title: "Number", value: widget.selectedGiftCards.number ?? noData),
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(SizedBox(
      width: double.infinity,
      child: MySmallBoxWidget(
          title: "Expiry Date",
          value: widget.selectedGiftCards.expiryDate ?? noData),
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(SizedBox(
      width: double.infinity,
      child: MySmallBoxWidget(
          title: "Total Amount",
          value: widget.selectedGiftCards.totalAmount!.toStringAsFixed(2)),
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(SizedBox(
      width: double.infinity,
      child: MySmallBoxWidget(
          title: "Available Amount",
          value: widget.selectedGiftCards.availableAmount!.toStringAsFixed(2)),
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(SizedBox(
      width: double.infinity,
      child: MySmallBoxWidget(
          title: "Status",
          value: widget.selectedGiftCards.status!.key ?? noData),
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));

    return widgets;
  }
}
