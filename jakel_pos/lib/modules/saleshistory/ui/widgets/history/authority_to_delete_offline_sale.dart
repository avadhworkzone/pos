import 'package:flutter/material.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_base/widgets/text/HeaderTextWidget.dart';
import 'package:jakel_base/widgets/textfield/MyTextFieldWidget.dart';
import 'package:jakel_pos/modules/offline/synctoserver/OfflineSyncingViewModel.dart';
import 'package:jakel_pos/modules/saleshistory/SalesHistoryViewModel.dart';
import 'package:jakel_pos/modules/storemanagers/StoreManagersViewModel.dart';
import 'package:jakel_pos/modules/utils/focus_scope.dart';

class AuthorityToDeleteOfflineSale extends StatefulWidget {
  final Function onSuccess;

  const AuthorityToDeleteOfflineSale({Key? key, required this.onSuccess})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AuthorityToDeleteOfflineSaleState();
  }
}

class _AuthorityToDeleteOfflineSaleState
    extends State<AuthorityToDeleteOfflineSale>
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
    passCodeNode.dispose();
    empIdNode.dispose();
    super.dispose();
  }

  final offlineSyncViewModel = OfflineSyncingViewModel();
  final storeManagerViewModel = StoreManagersViewModel();
  final viewModel = SalesHistoryViewModel();

  final passCodeController = TextEditingController();
  final passCodeNode = FocusNode();
  final empIdController = TextEditingController();
  final empIdNode = FocusNode();

  final itKeyController = TextEditingController();
  final itKeyNode = FocusNode();

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
              focusSocpeNext(context,itKeyNode);
            },
          ),
          const SizedBox(
            height: 20,
          ),
          MyTextFieldWidget(
            controller: itKeyController,
            node: itKeyNode,
            obscureText: true,
            hint: "Enter key from IT team to delete the offline sale",
          ),
          const SizedBox(
            height: 20,
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

    try {
      final storeManager = await storeManagerViewModel.getStoreManager(
          passCodeController.text, empIdController.text);

      if (storeManager == null) {
        showToast('Invalid store manager id or passcode.', context);
        return;
      }

      if (itKeyController.text.isEmpty) {
        showToast('Invalid Key. Please check with IT team', context);
        return;
      }

      if (itKeyController.text != offlineSyncViewModel.keyToDelete) {
        showToast('Invalid Key. Please check with IT team', context);
        return;
      }

      widget.onSuccess();
      Navigator.of(context).pop();
    } catch (e) {
      showToast('Invalid store manager id or passcode.', context);
    }
  }
}
