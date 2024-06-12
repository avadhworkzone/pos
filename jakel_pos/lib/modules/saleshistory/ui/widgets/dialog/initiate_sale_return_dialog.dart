import 'package:flutter/material.dart';
import 'package:jakel_base/database/sale/model/sale_returns_data.dart';
import 'package:jakel_base/database/sale/model/sale_returns_item_data.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/restapi/employees/model/EmployeesResponse.dart';
import 'package:jakel_base/restapi/sales/model/history/SalesResponse.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/widgets/custom/MyDataContainerWidget.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/dialog/sale_return_item_row.dart';

import '../../../../products/ProductsViewModel.dart';

enum ReturnType { returns, exchange,bookingReturn }

class InitiateSaleReturnDialog extends StatefulWidget {
  final Sales sale;
  final ReturnType returnType;
  final Function proceedToSaleReturns;

  const InitiateSaleReturnDialog(
      {Key? key,
      required this.sale,
      required this.proceedToSaleReturns,
      required this.returnType})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _InitiateSaleReturnDialogState();
  }
}

class _InitiateSaleReturnDialogState extends State<InitiateSaleReturnDialog> {
  final saleReturnData =
      SaleReturnsData(returnItems: List.empty(growable: true));
  final productsViewModel = ProductsViewModel();
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();

    if (widget.sale.userDetails != null) {
      if (widget.sale.userType == "Employee") {
        var employee = Employees(
          id: widget.sale.userId ?? 0,
          mobileNumber: widget.sale.userDetails?.mobileNumber,
          firstName: widget.sale.userDetails?.firstName,
          lastName: widget.sale.userDetails?.lastName,
          email: widget.sale.userDetails?.email,
        );
        saleReturnData.employees = employee;
      } else {
        var customer = Customers(
          id: widget.sale.userId ?? 0,
          mobileNumber: widget.sale.userDetails?.mobileNumber,
          firstName: widget.sale.userDetails?.firstName,
          lastName: widget.sale.userDetails?.lastName,
          email: widget.sale.userDetails?.email,
        );
        saleReturnData.customers = customer;
      }
    }

    saleReturnData.returnItems = List.empty(growable: true);

    if (widget.returnType == ReturnType.exchange) {
      saleReturnData.isExchange = true;
    } else {
      saleReturnData.isExchange = false;
    }

    int index = 0;
    for (var value in widget.sale.saleItems!) {
      var saleReturnItemData = SaleReturnsItemData();
      saleReturnItemData.uniqueId = index;
      saleReturnItemData.saleItem = value;
      saleReturnData.returnItems!.add(saleReturnItemData);
      index += 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(10.0),
          constraints: const BoxConstraints.expand(),
          child: MyDataContainerWidget(
            child: getRootWidget(),
          ),
        ));
  }

  Widget getRootWidget() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(getHeader());

    widgets.add(const Divider());

    widgets.add(getColumnHeader());

    widgets.add(const Divider());

    int index = 0;
    saleReturnData.returnItems?.forEach((element) {
      widgets.add(SaleReturnItemRow(
        mSaleReturnsItemData: element,
        onReasonSelected: (reason) {
          setState(() {
            element.reason = reason;
          });
        },
        returnType: widget.returnType,
        index: index,
        onUpdated: (double qty) {
          setState(() {
            element.qty = qty;
          });
        },
      ));
      widgets.add(const Divider());
      index += 1;
    });

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(Center(
      child: OutlinedButton(
          onPressed: () {
            _proceedToSalePage();
          },
          child: const Text("Proceed")),
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));

    return SingleChildScrollView(
      controller: controller,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  Widget getHeader() {
    String title = "";
    String description = "";

    if (widget.returnType == ReturnType.returns) {
      title = "Initiate Sale Returns";
      description =
          "Select items with quantity to be returned.\nReason is mandatory";
    }

    if (widget.returnType == ReturnType.exchange) {
      title = "Initiate Exchange";
      description =
          "Select items with quantity to be exchanged.\nReason is mandatory";
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IntrinsicHeight(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
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

  Widget getColumnHeader() {
    String title = "";

    if (widget.returnType == ReturnType.returns) {
      title = "Return Quantity";
    }

    if (widget.returnType == ReturnType.exchange) {
      title = "Exchange Quantity";
    }

    return SizedBox(
      height: 30,
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              "Product Name",
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "Total Paid",
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "Available Qty.",
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              "Reason",
              style: Theme.of(context).textTheme.caption,
            ),
          )
        ],
      ),
    );
  }

  void _proceedToSalePage() async {
    List<SaleReturnsItemData> items = List.empty(growable: true);

    for (var element in saleReturnData.returnItems!) {
      if (element.qty != null && element.qty! > 0 && element.reason != null) {
        var product =
            await productsViewModel.getProduct(element.saleItem?.product?.id);
        element.product = product;
        element.batchNumber = productsViewModel.getProductBatch(product);
        items.add(element);
      }
    }
    if (items.isNotEmpty) {
      saleReturnData.returnItems = items;
      widget.proceedToSaleReturns(saleReturnData);
      Navigator.pop(context);
    } else {
      showToast("Please select at least one item to proceed", context);
    }
    MyLogUtils.logDebug(
        "_proceedToSalePage saleReturnData : ${saleReturnData.toJson()}");
  }
}
