import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_base/widgets/text/HeaderTextWidget.dart';
import 'package:jakel_base/widgets/textfield/MyTextFieldWidget.dart';
import 'package:jakel_pos/modules/saleshistory/SalesHistoryViewModel.dart';
import 'package:jakel_pos/modules/storemanagers/StoreManagersViewModel.dart';

class RefundManagerWidget extends StatefulWidget {
  final Function onSuccess;

  const RefundManagerWidget({Key? key, required this.onSuccess})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RefundManagerWidgetState();
  }
}

class _RefundManagerWidgetState extends State<RefundManagerWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

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

  final storeManagerViewModel = StoreManagersViewModel();
  final viewModel = SalesHistoryViewModel();

  var callApi = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          width: 250,
          child: IntrinsicHeight(
            child: getRootWidget(),
          ),
        ));
  }

  Widget getRootWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HeaderTextWidget(
                text: "Refund",
                color: getPrimaryColor(context),
              ),
              MyInkWellWidget(
                  child: Icon(
                    Icons.close,
                    color: Theme.of(context).primaryColor,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  })
            ],
          ),
          const Divider(),
          const SizedBox(
            height: 20,
          ),
          Expanded(
              child: SizedBox(
            width: 250,
            height: 30,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.tertiary),
              onPressed: () {
                _save("Credit Note");
              },
              child: const Text("Credit Note"),
            ),
          )),
          const SizedBox(
            height: 20,
          ),
          Expanded(
              child: SizedBox(
                  width: 250,
                  height: 30,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).colorScheme.tertiary),
                    onPressed: () {
                        _save("Booking Payment");
                    },
                    child: const Text("Booking Payment"),
                  ))),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  void _save(String sRefundType) async {
    widget.onSuccess(sRefundType);
  }
}
