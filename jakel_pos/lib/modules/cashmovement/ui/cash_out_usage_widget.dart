import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jakel_base/constants.dart';
import 'package:jakel_base/restapi/cashmovement/model/CashMovementReasonResponse.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:jakel_base/restapi/managers/model/StoreManagersResponse.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_base/widgets/textfield/MyTextFieldWidget.dart';
import 'package:jakel_pos/modules/cashmovement/CashMovementViewModel.dart';
import 'package:jakel_pos/modules/utils/focus_scope.dart';

import '../../storemanagers/StoreManagersViewModel.dart';
import 'cash_movement_report_dialog.dart';

class CashOutUsageWidget extends StatefulWidget {
  const CashOutUsageWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CashOutUsageWidgetState();
  }
}

class _CashOutUsageWidgetState extends State<CashOutUsageWidget> {
  bool callApi = false;
  final amountController = TextEditingController();
  final amountNode = FocusNode();
  final viewModel = CashMovementViewModel();

  CashMovementReasons? selected;
  final storeManagerViewModel = StoreManagersViewModel();

  final passCodeController = TextEditingController();
  final staffIdController = TextEditingController();

  final passCodeNode = FocusNode();
  final staffIdNode = FocusNode();
  String? staffId;
  String? passCode;
  StoreManagers? selectedStoreManager;
  List<StoreManagers>? allStoreManagers;

  @override
  Widget build(BuildContext context) {
    selectedStoreManager = storeManagerViewModel.filterStoreManager(
        allStoreManagers ?? [], staffId, passCode);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        constraints: const BoxConstraints.expand(),
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getHeader(),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: Row(
              children: [
                Expanded(child: getAllStoreManagers()),
                const VerticalDivider(),
                selectedStoreManager != null
                    ? Expanded(
                        child: CashMovementReportDialog(
                        showAsDialog: false,
                        typeId: cashOutTypeId,
                      ))
                    : const SizedBox()
              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget getRootWidget() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Add New Cash Out',
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ));
    widgets.add(const SizedBox(
      height: 10,
    ));
    widgets.add(const Divider());
    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(
      MyTextFieldWidget(
        controller: staffIdController,
        node: staffIdNode,
        hint: 'Employee Id',
        onSubmitted: (value) {
          setState(() {
            staffId = value;
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
            focusSocpeNext(context,amountNode);
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

    if (selectedStoreManager != null) {
      widgets.add(const SizedBox(
        height: 10,
      ));
      widgets.add(
        MyTextFieldWidget(
          controller: amountController,
          node: amountNode,
          onChanged: (value) {},
          hint: "Enter amount",
        ),
      );

      widgets.add(const SizedBox(
        height: 10,
      ));

      widgets.add(reasonSelection());

      widgets.add(const SizedBox(
        height: 10,
      ));

      widgets.add(buttonWidget());

      widgets.add(const SizedBox(
        height: 10,
      ));
    }

    return Column(
      children: widgets,
    );
  }

  Widget reasonSelection() {
    return SizedBox(
      height: 50,
      child: DropdownSearch<CashMovementReasons>(
        compareFn: (item1, item2) {
          return false;
        },
        popupProps: const PopupProps.menu(
          showSelectedItems: true,
        ),
        asyncItems: (String filter) => viewModel.getCashOut(),
        onChanged: (value) {
          setState(() {
            selected = value;
          });
        },
        itemAsString: (item) {
          return item.reason ?? noData;
        },
        selectedItem: selected,
      ),
    );
  }

  Widget getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MyInkWellWidget(
            child: const Icon(Icons.close),
            onTap: () {
              Navigator.pop(context);
            })
      ],
    );
  }

  Widget buttonWidget() {
    if (callApi) {
      return apiWidget();
    }
    return MyOutlineButton(
        text: 'save',
        onClick: () {
          EasyDebounce.debounce(
              'cashout-debouncer', const Duration(milliseconds: 500), () {
            MyLogUtils.logDebug("cashout-debouncer value");
            _save();
          });
        });
  }

  void _save() {
    if (selected == null) {
      showToast('Please select reason', context);
      return;
    }
    if (amountController.text.isEmpty) {
      showToast('Please enter amount', context);
      return;
    }

    if (selectedStoreManager == null) {
      showToast('Please select store manager!', context);
      return;
    }

    setState(() {
      callApi = true;
      viewModel.saveCashOut(selected?.reason ?? '', selected!.id!,
          getDoubleValue(amountController.text), selectedStoreManager!);
    });
  }

  Widget apiWidget() {
    return StreamBuilder<String>(
      stream: viewModel.responseSubject,
      // ignore: missing_return, missing_return
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyLoadingWidget();
        }
        if (snapshot.hasError) {
          callApi = false;
          showToast('Error updating.Please try again later!', context);
          return buttonWidget();
        }
        if (snapshot.connectionState == ConnectionState.active) {
          var response = snapshot.data;
          if (response != null && response == "true") {
            showToast("Successfully added!", context);
            goBack();
            return const SizedBox();
          } else {
            showToast(response ?? "Error", context);
            callApi = false;
            return buttonWidget();
          }
        }
        return Container();
      },
    );
  }

  Widget getAllStoreManagers() {
    return FutureBuilder(
        future: storeManagerViewModel.getAllStoreManagers(),
        builder: (BuildContext context,
            AsyncSnapshot<List<StoreManagers>?> snapshot) {
          if (snapshot.hasError) {
            MyLogUtils.logDebug("getStoreManager snapshot :$snapshot");
            selectedStoreManager = null;
            return const Text("Failed to fetch data. Please try again later!");
          }
          if (snapshot.hasData) {
            allStoreManagers = snapshot.data;
            return getRootWidget();
          }
          return const Text("Loading ...");
        });
  }

  Future<void> goBack() async {
    viewModel.closeObservable();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
    });
  }

  Widget getMessageWidget() {
    if (selectedStoreManager == null) {
      return const Text("Invalid staff id or passcode.");
    }
    return Text("Authorized by ${selectedStoreManager?.firstName}");
  }
}
