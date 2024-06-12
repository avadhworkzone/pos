import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jakel_base/database/sale/model/BookingSaleReturnsItem.dart';
import 'package:jakel_base/database/sale/model/sale_booking_returns_data.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsResponse.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/restapi/products/model/ProductsResponse.dart';
import 'package:jakel_base/restapi/sales/model/history/SalesResponse.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/widgets/custom/MyDataContainerWidget.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/dialog/initiate_sale_return_dialog.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/dialog/sale_booking_return_item_row.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/dialog/sale_return_item_row.dart';

import '../../../../products/ProductsViewModel.dart';

class InitiateBookingReturnDialog extends StatefulWidget {
  final BookingPayments sale;
  final ReturnType returnType;
  final Function resetProductsInBookingPayments;

  const InitiateBookingReturnDialog(
      {Key? key,
      required this.sale,
      required this.resetProductsInBookingPayments,
      required this.returnType})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _InitiateBookingReturnDialogState();
  }
}

class _InitiateBookingReturnDialogState
    extends State<InitiateBookingReturnDialog> {
  final saleBookingReturnData =
      BookingItemsResetData(returnItems: List.empty(growable: true));
  final productsViewModel = ProductsViewModel();
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();

    if (widget.sale.customer != null) {
      var customer = Customers(
        id: widget.sale.customer?.id ?? 0,
        mobileNumber: widget.sale.customer?.mobileNumber,
        firstName: widget.sale.customer?.firstName,
        lastName: widget.sale.customer?.lastName,
        email: widget.sale.customer?.email,
      );
      saleBookingReturnData.customers = customer;
    }

    saleBookingReturnData.returnPromoters = List.empty(growable: true);
    saleBookingReturnData.returnPromoters!.addAll(widget.sale.promoters??[]);
    saleBookingReturnData.returnItems = List.empty(growable: true);

    saleBookingReturnData.returnId = widget.sale.id;
    getProductDetails();
  }

  void getProductDetails() async {
    for (var value in widget.sale.products??[]) {
      Products mProducts =
          (await productsViewModel.getProduct(value.productId))!;
      BookingResetProducts mBookingSaleReturns = BookingResetProducts(
          quantity: value.quantity,
          promoters: value.promoters,
          returnItems: mProducts);
      saleBookingReturnData.returnItems!.add(mBookingSaleReturns);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(10.0),
          // constraints: const BoxConstraints.expand(),
          width: 650,
          height: 500,
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

    saleBookingReturnData.returnItems?.forEach((element) {
      widgets.add(SaleBookingReturnItemRow(
        mSaleReturnsItemData: element,
        onReasonSelected: (reason) {
        },
        returnType: widget.returnType,
        index: index,
        onUpdated: (double qty) {
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

    if (widget.returnType == ReturnType.bookingReturn) {
      title = "Initiate Booking Sale Returns";
      description = "";
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
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "Available Qty.",
              style: Theme.of(context).textTheme.caption,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _proceedToSalePage() async {
    if ((saleBookingReturnData.returnItems ?? []).isNotEmpty) {
      widget.resetProductsInBookingPayments(saleBookingReturnData);
      Navigator.pop(context);
    } else {
      showToast("Please select at least one item to proceed", context);
    }
    MyLogUtils.logDebug(
        "_proceedToSalePage saleReturnData : ${jsonEncode(saleBookingReturnData)}");
  }
}
