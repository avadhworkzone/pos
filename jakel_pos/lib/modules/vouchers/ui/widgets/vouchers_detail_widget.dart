import 'package:flutter/material.dart';
import 'package:jakel_base/constants.dart';
import 'package:jakel_base/restapi/vouchers/model/VouchersListResponse.dart';
import 'package:jakel_base/widgets/custom/my_small_box_widget.dart';

class VouchersDetailWidget extends StatefulWidget {
  final Vouchers selectedVouchers;

  const VouchersDetailWidget({Key? key, required this.selectedVouchers})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VouchersDetailWidgetState();
  }
}

class _VouchersDetailWidgetState extends State<VouchersDetailWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
          title: "Discount Type",
          value: widget.selectedVouchers.discountType ?? noData),
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(SizedBox(
      width: double.infinity,
      child: MySmallBoxWidget(
          title: "Discount Number",
          value: widget.selectedVouchers.number ?? noData),
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(SizedBox(
      width: double.infinity,
      child: MySmallBoxWidget(
          title: "Expiry Date",
          value: widget.selectedVouchers.expiryDate ?? noData),
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(SizedBox(
      width: double.infinity,
      child: MySmallBoxWidget(
          title: "Minimum Spend Amount",
          value:
              "RM ${widget.selectedVouchers.minimumSpendAmount!.toStringAsFixed(2)}"),
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(SizedBox(
      width: double.infinity,
      child: MySmallBoxWidget(
          title: "Flat Amount",
          value:
              "RM ${widget.selectedVouchers.flatAmount!.toStringAsFixed(2)}"),
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(SizedBox(
      width: double.infinity,
      child: MySmallBoxWidget(
          title: "Percentage",
          value: "${widget.selectedVouchers.flatAmount!.toStringAsFixed(2)}%"),
    ));

    return widgets;
  }
}
