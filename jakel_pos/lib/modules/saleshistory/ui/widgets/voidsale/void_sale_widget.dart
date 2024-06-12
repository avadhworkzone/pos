import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:jakel_base/restapi/sales/model/history/SalesResponse.dart';
import 'package:jakel_base/restapi/sales/model/history/SaveSaleResponse.dart';
import 'package:jakel_base/restapi/sales/model/void/VoidSaleReasonResponse.dart';
import 'package:jakel_base/restapi/sales/model/void/VoidSaleRequest.dart';
import 'package:jakel_base/sale/sale_helper.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/dropdownsearch/dropdown_decoration.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_base/widgets/text/HeaderTextWidget.dart';
import 'package:jakel_base/widgets/textfield/MyTextFieldWidget.dart';
import 'package:jakel_pos/modules/saleshistory/SalesHistoryViewModel.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/voidsale/void_sale_item_row.dart';
import 'package:jakel_pos/modules/storemanagers/StoreManagersViewModel.dart';
import 'package:jakel_pos/modules/utils/focus_scope.dart';

class VoidSaleWidget extends StatefulWidget {
  final Sales sale;

  const VoidSaleWidget({Key? key, required this.sale}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VoidSaleWidgetState();
  }
}

class _VoidSaleWidgetState extends State<VoidSaleWidget>
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

  final storeManagerViewModel = StoreManagersViewModel();
  final viewModel = SalesHistoryViewModel();
  VoidSaleReasons? selectedReason;
  final passCodeController = TextEditingController();
  final passCodeNode = FocusNode();
  final empIdController = TextEditingController();
  final empIdNode = FocusNode();

  var callApi = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(10.0),
          constraints: const BoxConstraints.expand(),
          child: getRootWidget(),
        ));
  }

  Widget getRootWidget() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(getHeaderWidget());
    widgets.add(const SizedBox(
      height: 20,
    ));

    //
    widgets.add(IntrinsicHeight(
      child: Column(
        children: [
          reasonsWidget(),
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
          ),
          const SizedBox(
            height: 20,
          ),
          buttonWidget()
        ],
      ),
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(
      HeaderTextWidget(
        text: "Items Preview",
        color: getPrimaryColor(context),
      ),
    );
    widgets.add(const Divider());
    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(getColumnHeader());

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(const Divider());

    widgets.add(const SizedBox(
      height: 10,
    ));

    int index = 1;
    widget.sale.saleItems?.forEach((element) {
      widgets.add(VoidSaleItemRow(
        saleItem: element,
        index: index,
      ));
      widgets.add(const Divider());
      index += 1;
    });

    widgets.add(const SizedBox(
      height: 20,
    ));

    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets),
    );
  }

  Widget getColumnHeader() {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 10,
          ),
          Text(
            "#",
            style: Theme.of(context).textTheme.caption,
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            flex: 5,
            child: Text(
              "Item",
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Paid Amount",
                  style: Theme.of(context).textTheme.caption,
                ),
              )),
          Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  "Qty",
                  style: Theme.of(context).textTheme.caption,
                ),
              )),
        ],
      ),
    );
  }

  Widget getHeaderWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        HeaderTextWidget(
          text: "Void Sale",
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
    );
  }

  late Color primaryColor;

  Widget reasonsWidget() {
    primaryColor = getPrimaryColor(context);
    return SizedBox(
      height: 50,
      child: DropdownSearch<VoidSaleReasons>(
        compareFn: (item1, item2) {
          return false;
        },
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: getDecoration(context),
        ),
        popupProps: const PopupProps.menu(
          showSelectedItems: true,
        ),
        asyncItems: (String filter) => viewModel.getVoidSaleReasons(),
        onChanged: (value) {
          setState(() {
            selectedReason = value;
          });
        },
        itemAsString: (item) {
          return item.reason!;
        },
        selectedItem: selectedReason,
      ),
    );
  }

  Widget buttonWidget() {
    if (callApi) {
      return apiWidget();
    }
    return MyOutlineButton(text: 'Void this sale', onClick: () => {_save()});
  }

  void _save() async {
    if (selectedReason == null) {
      showToast('Please select reason.', context);
      return;
    }

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

      setState(() {
        callApi = true;
        final request = VoidSaleRequest(
            passcode: passCodeController.text,
            voidedByStoreManagerId: storeManager.id!,
            voidSaleReasonId: selectedReason!.id!);

        viewModel.voidASale(widget.sale.id!, request);
      });
    } catch (e) {
      showToast('Invalid store manager id or passcode.', context);
    }
  }

  Widget apiWidget() {
    return StreamBuilder<SaveSaleResponse>(
      stream: viewModel.stringResponseSubject,
      // ignore: missing_return, missing_return
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyLoadingWidget();
        }
        if (snapshot.hasError) {
          callApi = false;
          showToast('This sale is already voided', context);
          return Container();
        }
        if (snapshot.connectionState == ConnectionState.active) {
          var response = snapshot.data;
          if (response != null && response.sale != null) {
            showToast('Void Sale Success!', context);
            goBack(response.sale!);
            return const SizedBox();
          } else {
            showToast(response?.message ?? 'Void sale failed.Please try again',
                context);
            callApi = false;
            return buttonWidget();
          }
        }
        return Container();
      },
    );
  }

  Future<void> goBack(Sale sale) async {
    viewModel.closeObservable();
    viewModel.printVoidedSales(sale);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
    });
  }
}
