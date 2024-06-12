import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/managers/model/StoreManagersResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/widgets/textfield/MyTextFieldWidget.dart';
import 'package:jakel_pos/modules/shiftclose/ui/widgets/shift_close_inherited_widget.dart';
import 'package:jakel_pos/modules/utils/focus_scope.dart';

import '../../../storemanagers/StoreManagersViewModel.dart';

class StoreManagerAuthorization extends StatefulWidget {
  final Function onStoreManagerSelected;

  const StoreManagerAuthorization(
      {Key? key, required this.onStoreManagerSelected})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StoreManagerAuthorizationState();
  }
}

class _StoreManagerAuthorizationState extends State<StoreManagerAuthorization> {
  StoreManagers? selectedStoreManager;
  List<StoreManagers>? allStoreManagers;
  final storeManagerViewModel = StoreManagersViewModel();

  final passCodeController = TextEditingController();
  final staffIdController = TextEditingController();

  String? staffId;
  String? passCode;

  final passCodeNode = FocusNode();
  final staffIdNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    selectedStoreManager =
        ShiftCloseInheritedWidget.of(context).shiftDeclaration.storeManagers;

    return IntrinsicHeight(child: getAllStoreManagers());
  }

  Widget getAllStoreManagers() {
    return FutureBuilder(
        future: storeManagerViewModel.getAllStoreManagers(),
        builder: (BuildContext context,
            AsyncSnapshot<List<StoreManagers>?> snapshot) {
          if (snapshot.hasError) {
            MyLogUtils.logDebug("getStoreManager snapshot :$snapshot");

            return const Text("Failed to fetch data. Please try again later!");
          }
          if (snapshot.hasData) {
            allStoreManagers = snapshot.data;
            return getRootWidget();
          }
          return const Text("Loading ...");
        });
  }

  Widget getRootWidget() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(
      MyTextFieldWidget(
        controller: staffIdController,
        node: staffIdNode,
        hint: 'Employee Id',
        onSubmitted: (value) {
          setState(() {
            staffId = value;
            onDataEntered();
              focusSocpeNext(context,passCodeNode);
          });
        },
      ),
    );

    widgets.add(const SizedBox(
      height: 10,
    ));

    if (staffId != null) {
      widgets.add(MyTextFieldWidget(
        controller: passCodeController,
        node: passCodeNode,
        hint: 'Passcode',
        obscureText: true,
        onSubmitted: (value) {
          setState(() {
            passCode = value;
            onDataEntered();
          });
        },
      ));
    }

    widgets.add(const SizedBox(
      height: 10,
    ));

    if (staffId != null && passCode != null) {
      widgets.add(getMessageWidget());
    }

    return Column(
      children: widgets,
    );
  }

  Widget getMessageWidget() {
    if (selectedStoreManager == null) {
      return const Text("Invalid staff id or passcode.");
    }
    return Text("Authorized by ${selectedStoreManager?.firstName}");
  }

  void onDataEntered() {
    selectedStoreManager = storeManagerViewModel.filterStoreManager(
        allStoreManagers ?? [], staffId, passCode);
    if (selectedStoreManager != null) {
      widget.onStoreManagerSelected(selectedStoreManager);
    }
  }
}
