import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartItemFocData.dart';
import 'package:jakel_base/restapi/complimentaryreason/model/ComplimentaryReasonResponse.dart';
import 'package:jakel_base/restapi/managers/model/StoreManagersResponse.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/custom/MyDataContainerWidget.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_base/widgets/textfield/MyTextFieldWidget.dart';
import 'package:jakel_pos/modules/complimentaryreasons/ComplimentaryReasonsViewModel.dart';

import '../../../storemanagers/StoreManagersViewModel.dart';

class ComplimentaryItemDialog extends StatefulWidget {
  final CartItem cartItem;
  final Function addAsComplimentaryItem;

  const ComplimentaryItemDialog(
      {Key? key, required this.addAsComplimentaryItem, required this.cartItem})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ComplimentaryItemDialogState();
  }
}

class _ComplimentaryItemDialogState extends State<ComplimentaryItemDialog>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  final complimentaryViewModel = ComplimentaryReasonsViewModel();
  ComplimentaryItemReasons? complimentaryItemReasons;

  final storeManagerViewModel = StoreManagersViewModel();

  final passCodeController = TextEditingController();
  final employeeIdController = TextEditingController();
  final qtyController = TextEditingController();

  final qtyNode = FocusNode();
  final passCodeNode = FocusNode();
  final employeeIdNode = FocusNode();
  String? staffId;
  String? passCode;
  StoreManagers? selectedStoreManager;
  List<StoreManagers>? allStoreManagers;
  int? quantity = 1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    quantity = getInValue(widget.cartItem.qty);
    qtyController.text = '$quantity';
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    selectedStoreManager = storeManagerViewModel.filterStoreManager(
        allStoreManagers ?? [], staffId, passCode);

    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(10.0),
          width: 600,
          height: 600,
          child: MyDataContainerWidget(
            child: Column(
              children: [
                getHeader(),
                const SizedBox(
                  height: 10,
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                Expanded(child: getAllStoreManagers())
              ],
            ),
          ),
        ));
  }

  Widget getRootWidget() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(MyTextFieldWidget(
      controller: employeeIdController,
      node: employeeIdNode,
      hint: 'Employee Id',
      onSubmitted: (value) {
        setState(() {
          staffId = value;
        });
      },
    ));

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

      widgets.add(getComplimentaryReason());

      widgets.add(const SizedBox(
        height: 5,
      ));

      widgets.add(MyTextFieldWidget(
        controller: qtyController,
        node: qtyNode,
        hint: "Enter quantity",
        enabled: true,
        onChanged: (value) {
          _onQtyUpdated(value);
        },
      ));

      widgets.add(const SizedBox(
        height: 5,
      ));
    }

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(Row(
      children: [
        MyOutlineButton(
            text: "Remove",
            onClick: () {
              //This will remove the complimentary item set up
              widget.addAsComplimentaryItem(CartItemFocData(
                  complimentaryItemReasonId: -1,
                  makeItComplimentary: false,
                  storeManagerId: null,
                  storeManagerPasscode: null,
                  qty: getDoubleValue(quantity)));
              Navigator.of(context).pop();
            }),
        const SizedBox(
          width: 30,
        ),
        MyOutlineButton(
            text: "Done",
            onClick: () {
              if (complimentaryItemReasons == null) {
                showToast(
                    "Please select reason to mark this item as complimentary!",
                    context);
                return;
              }

              if (selectedStoreManager == null) {
                showToast("Need store manager authorization.", context);
                return;
              }

              if ((quantity ?? 0) <= 0) {
                showToast("Please select correct quantity.", context);
                return;
              }

              if ((quantity ?? 0) > (widget.cartItem.qty ?? 0)) {
                showToast("Please select correct quantity.", context);
                return;
              }

              widget.addAsComplimentaryItem(CartItemFocData(
                  complimentaryItemReasonId: complimentaryItemReasons!.id,
                  storeManagerPasscode: selectedStoreManager!.passcode!,
                  storeManagerId: selectedStoreManager!.id!,
                  qty: getDoubleValue(quantity)));
              Navigator.of(context).pop();
            })
      ],
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));

    return Column(
      children: widgets,
    );
  }

  void _onQtyUpdated(String value) {
    setState(() {
      try {
        quantity = getInValue(value);
        if ((quantity ?? 0) > (widget.cartItem.qty ?? 0)) {
          _onQtyError("Quantity should be less than available qty in cart.");
        }
      } catch (e) {
        _onQtyError("Only numeric value is allowed in quantity");
      }
    });
  }

  Widget getComplimentaryReason() {
    return SizedBox(
      height: 50,
      child: DropdownSearch<ComplimentaryItemReasons>(
        compareFn: (item1, item2) {
          return false;
        },
        popupProps: const PopupProps.menu(
          showSelectedItems: true,
        ),
        asyncItems: (String filter) => complimentaryViewModel.getAllReasons(),
        onChanged: (value) {
          setState(() {
            complimentaryItemReasons = value;
          });
        },
        itemAsString: (item) {
          return item.reason ?? "";
        },
        selectedItem: complimentaryItemReasons,
      ),
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

  Widget getMessageWidget() {
    if (selectedStoreManager == null) {
      return const Text("Invalid staff id or passcode.");
    }
    return Text("Authorized by ${selectedStoreManager?.firstName}");
  }

  Widget getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Complimentary Item",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        MyInkWellWidget(
            child: const Icon(Icons.close),
            onTap: () {
              Navigator.pop(context);
            })
      ],
    );
  }

  void _onQtyError(String message) {
    quantity = null;
    qtyController.text = "";
    showToast(message, context);
  }
}
