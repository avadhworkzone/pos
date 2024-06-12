import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jakel_base/database/sale/model/CartCustomDiscount.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/managers/model/StoreManagersResponse.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/custom/MyDataContainerWidget.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_base/widgets/textfield/MyTextFieldWidget.dart';
import 'package:jakel_pos/modules/newsale/NewSaleViewModel.dart';
import 'package:jakel_pos/modules/storemanagers/StoreManagersViewModel.dart';
import 'package:jakel_pos/modules/utils/focus_scope.dart';

class DeleteHoldSaleDialog extends StatefulWidget {
  final Function onDone;
  final CartSummary cartSummary;

  const DeleteHoldSaleDialog(
      {Key? key, required this.onDone,  required this.cartSummary})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DeleteHoldSaleState();
  }
}

class _DeleteHoldSaleState extends State<DeleteHoldSaleDialog>
    with SingleTickerProviderStateMixin {

  AnimationController? _controller;
  final passCodeController = TextEditingController();
  final employeeIdController = TextEditingController();
  final reasonController = TextEditingController();

  final passCodeNode = FocusNode();
  final staffIdNode = FocusNode();
  final reasonNode = FocusNode();

  final storeManagerViewModel = StoreManagersViewModel();
  final newSaleViewModel = NewSaleViewModel();

  CartCustomDiscount cartCustomDiscount = CartCustomDiscount();
  StoreManagers? storeManagers;
  String? passCode;
  String? staffId;
  String? reason;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    passCodeNode.dispose();
    staffIdNode.dispose();
    reasonNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(10.0),
          width: 450,
          height: 350,
          child: MyDataContainerWidget(
            child: getRootWidget(),
          ),
        ));
  }

  Widget getRootWidget() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: getChildren(),
      ),
    );
  }

  List<Widget> getChildren() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(getHeader());

    widgets.add(const SizedBox(
      height: 5,
    ));

    widgets.add(const Divider());

    widgets.add(const SizedBox(
      height: 5,
    ));

    widgets.add(
      Text("Please verify manager & enter reason to cancel the hold sale",
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.caption),
    );

    widgets.add(const SizedBox(
      height: 15,
    ));

    widgets.add(MyTextFieldWidget(
      controller: employeeIdController,
      node: staffIdNode,
      hint: 'Enter employee id & press enter for selection',
      onSubmitted: (value) {
        setState(() {
          staffId = value;
          focusSocpeNext(context,passCodeNode);

        });
      },
    ));

    widgets.add(const SizedBox(
      height: 15,
    ));

    if (staffId != null) {
      widgets.add(MyTextFieldWidget(
        controller: passCodeController,
        node: passCodeNode,
        obscureText: true,
        hint: 'Enter passcode & press enter for selection',
        onSubmitted: (value) {
          setState(() {
            passCode = value;
            reason = null;
            focusSocpeNext(context,reasonNode);
          });
        },
      ));
      widgets.add(const SizedBox(
        height: 5,
      ));
    }

    if (passCode != null && staffId != null) {
      widgets.add(const SizedBox(
        height: 5,
      ));
      widgets.add(getStoreManager());
      widgets.add(const SizedBox(
        height: 5,
      ));
    }

    if (reason != null) {
      widgets.add(const SizedBox(
        height: 5,
      ));

      widgets.add(MyOutlineButton(
          text: "Done",
          onClick: () {
            if (reason != null) {
              _deleteHoldSale();
            }
          }));
    }
    return widgets;
  }

  ///On click done delete the hold sale
  void _deleteHoldSale() async {
    widget.cartSummary.remarks = reason ?? "";
    cartCustomDiscount.manager = storeManagers;
    widget.cartSummary.cartCustomDiscount = cartCustomDiscount;
    await newSaleViewModel.deleteOnHoldSale(widget.cartSummary, false);
    Navigator.of(context).pop();
    widget.onDone(widget.cartSummary);
  }

  Widget getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Delete Hold Sale",
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

  ///Verify the store manager details
  Widget getStoreManager() {
    return FutureBuilder(
        future: storeManagerViewModel.getStoreManager(
            passCodeController.text, staffId ?? ""),
        builder:
            (BuildContext context, AsyncSnapshot<StoreManagers?> snapshot) {
          if (snapshot.hasError) {
            storeManagers = null;
            return const Text("Invalid Passcode or Employee Id!");
          }

          if (snapshot.hasData) {
            storeManagers = snapshot.data;
            if (storeManagers != null) {
              return MyTextFieldWidget(
                  controller: reasonController,
                  node: reasonNode,
                  onSubmitted: (value) {
                    setState(() {
                      reason = value;
                    });
                  },
                  onChanged: (value) {
                  },
                  hint: 'Reason & press enter for selection');
            }
            return const Text("Invalid passcode!");
          }
          return const Text("Loading ...");
        });
  }

  void resetData() {
    storeManagers = null;
    passCode = null;
    passCodeController.text = "";
  }
}
