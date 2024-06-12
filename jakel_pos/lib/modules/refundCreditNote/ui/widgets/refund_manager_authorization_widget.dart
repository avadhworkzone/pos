import 'dart:async';
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
import 'package:jakel_pos/modules/utils/focus_scope.dart';

class RefundManagerAuthorizationWidget extends StatefulWidget {
  final Function onSuccess;
  final String? sType;

  const RefundManagerAuthorizationWidget({Key? key, required this.onSuccess, this.sType})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RefundManagerAuthorizationWidgetState();
  }
}

class _RefundManagerAuthorizationWidgetState extends State<RefundManagerAuthorizationWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  late String sType ;

  @override
  void initState() {
    sType = widget.sType??"";
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    passCodeNode.dispose();
    empIdNode.dispose();
    reasonNode.dispose();
    super.dispose();
  }

  final storeManagerViewModel = StoreManagersViewModel();
  final viewModel = SalesHistoryViewModel();


  final empIdController = TextEditingController();
  final empIdNode = FocusNode();

  final passCodeController = TextEditingController();
  final passCodeNode = FocusNode();

  final reasonController = TextEditingController();
  final reasonNode = FocusNode();

  var callApi = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          width: 400,
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
                text: "Authorize",
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
          const SizedBox(
            height: 20,
          ),
          MyTextFieldWidget(
            controller: empIdController,
            node: empIdNode,
            hint: "Enter store manager id",
            onSubmitted: (value){
              focusSocpeNext(context,passCodeNode);
            },
          ),
          const SizedBox(
            height: 20,
          ),
          MyTextFieldWidget(
            controller: passCodeController,
            node: passCodeNode,
            obscureText: true,
            hint: "Enter store manager passcode",
            onSubmitted: (value){
              focusSocpeNext(context,reasonNode);
            },
          ),
          const SizedBox(
            height: 20,
          ),
          (sType=="Cancel Layaway Amount")?
          MyTextFieldWidget(
            controller: reasonController,
            node: reasonNode,
            hint: "Enter the reason",
          ):SizedBox(),
          SizedBox(
            height: (sType=="Cancel Layaway Amount")?20:0,
          ),
          buttonWidget()
        ],
      ),
    );
  }

  Widget buttonWidget() {
    return MyOutlineButton(text: 'Authorize', onClick: () => {_save()});
  }

  void _save() async {
    if (passCodeController.text.isEmpty) {
      showToast('Please enter passcode', context);
      return;
    }

    if (empIdController.text.isEmpty) {
      showToast('Please enter employee id', context);
      return;
    }

    if (sType=="Cancel Layaway Amount" && reasonController.text.isEmpty) {
      showToast('Please enter reason', context);
      return;
    }

    try {
      final storeManager = await storeManagerViewModel.getStoreManager(
          passCodeController.text, empIdController.text);

      if (storeManager == null) {
        showToast('Invalid store manager id or passcode.', context);
        return;
      }
      MyLogUtils.logDebug("storeManager jsonEncode : ${jsonEncode(storeManager)}");
      (sType=="Cancel Layaway Amount")?widget.onSuccess( storeManager,reasonController.text):
      widget.onSuccess( storeManager);
      Navigator.of(context).pop();
    } catch (e) {
      showToast('Invalid store manager id or passcode.', context);
    }
  }
}
