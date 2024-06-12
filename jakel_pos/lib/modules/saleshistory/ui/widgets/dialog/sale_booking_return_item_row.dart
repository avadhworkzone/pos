import 'package:flutter/material.dart';
import 'package:jakel_base/constants.dart';
import 'package:jakel_base/database/sale/model/BookingSaleReturnsItem.dart';
import 'package:jakel_base/database/sale/model/sale_returns_item_data.dart';
import 'package:jakel_base/jakel_base.dart';
import 'package:jakel_base/restapi/bookingpayment/model/BookingPaymentsResponse.dart';
import 'package:jakel_base/restapi/products/model/ProductsResponse.dart';
import 'package:jakel_base/restapi/sales/model/SaleReturnsResponse.dart';
import 'package:jakel_base/restapi/sales/model/history/SalesResponse.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/textfield/MyTextFieldWidget.dart';
import 'package:jakel_pos/modules/products/ProductsViewModel.dart';
import 'package:jakel_pos/modules/saleshistory/SalesHistoryViewModel.dart';
import 'package:jakel_pos/modules/saleshistory/ui/widgets/dialog/initiate_sale_return_dialog.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SaleBookingReturnItemRow extends StatefulWidget {
  final BookingResetProducts mSaleReturnsItemData;
  final int index;
  final Function onUpdated;
  final ReturnType returnType;
  final Function onReasonSelected;

  const SaleBookingReturnItemRow(
      {Key? key,
      required this.mSaleReturnsItemData,
      required this.onUpdated,
      required this.index,
      required this.returnType,
      required this.onReasonSelected})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SaleBookingReturnItemRowState();
  }
}

class _SaleBookingReturnItemRowState extends State<SaleBookingReturnItemRow> {
  final productViewModel = ProductsViewModel();
  // late Products mProducts;
  final qtyController = TextEditingController();
  final qtyNode = FocusNode();

  final saleHistoryViewModel = SalesHistoryViewModel();
  SaleReturnReasons? reason;

  //TO be used when backend fixes issue with type_id coming as in instead of object.
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String hint = "";

    if (widget.returnType == ReturnType.returns) {
      hint = "Quantity to be returned";
    }

    if (widget.returnType == ReturnType.exchange) {
      hint = "Quantity to be exchanged";
    }

    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.mSaleReturnsItemData.returnItems?.name ?? ""),
                const SizedBox(
                  height: 4,
                ),
                // Text(
                //   widget.mSaleReturnsItemData.saleItem?.product?.color?.name ??
                //       noData,
                //   style: Theme.of(context).textTheme.caption,
                // ),
                // const SizedBox(
                //   height: 4,
                // ),
                // Text(
                //   widget.mSaleReturnsItemData.saleItem?.product?.size?.name ??
                //       noData,
                //   style: Theme.of(context).textTheme.caption,
                // ),
                // const SizedBox(
                //   height: 4,
                // ),
                // promoters(widget.mSaleReturnsItemData.saleItem),
                // const SizedBox(
                //   height: 4,
                // ),
              ],
            ),
          ),
          Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                   getReadableAmount(getCurrency(),widget.mSaleReturnsItemData.returnItems?.price),
                ),
              )),
          Expanded(
              flex: 2,
              child: Text(
                getStringWithNoDecimal(getAvailableQty()),
                textAlign: TextAlign.center,
              )),
          // Expanded(
          //     flex: 2,
          //     child:
          //         // productViewModel.isReturnAllowed(widget.mSaleReturnsItemData)
          //         //     ? getQtyWidget(hint)
          //         //     :
          //         Container()
          // ),
          // const SizedBox(
          //   width: 10,
          // ),
          // Expanded(
          //   flex: 3,
          //   child:
          //   // productViewModel.isReturnAllowed(widget.mSaleReturnsItemData)
          //   //     ? getReason()
          //   //     :
          //   Container(),
          // )
        ],
      ),
    );
  }

  // Widget getQtyWidget(String hint) {
  //   if ((widget.mSaleReturnsItemData.saleItem?.totalPricePaid ?? 0.0) <= 0 &&
  //       widget.returnType == ReturnType.returns) {
  //     return Text(
  //       "Returns is not allowed for this product",
  //       style: Theme.of(context).textTheme.caption,
  //     );
  //   }
  //   if (getAvailableQty() > 0) {
  //     return MyTextFieldWidget(
  //         controller: qtyController,
  //         onChanged: (value) {
  //           _onQtyEntered(value, context);
  //         },
  //         node: qtyNode,
  //         hint: hint);
  //   }
  //   return Container();
  // }

  // void _onQtyEntered(String value, BuildContext context) {
  //   if (value.isNotEmpty) {
  //     var doubleValue = getDoubleValue(value);
  //     if (doubleValue > 0 &&
  //         doubleValue <=
  //             getDoubleValue(widget.mSaleReturnsItemData.saleItem?.quantity)) {
  //       widget.onUpdated(getDoubleValue(value));
  //     } else {
  //       qtyController.text = "";
  //       showToast(
  //           "Max allowed quantity is: ${getStringWithNoDecimal(getAvailableQty())}",
  //           context);
  //     }
  //   }
  // }

  double getAvailableQty() {
    return getDoubleValue(widget.mSaleReturnsItemData.quantity);
  }

  Widget promoters(SaleItems? item) {
    if (item == null || item.promoters == null || item.promoters!.isEmpty) {
      return Container();
    }

    List<InlineSpan> spanTexts = List.empty(growable: true);

    item.promoters?.forEach((element) {
      if (spanTexts.length == 1) {
        spanTexts.add(
          TextSpan(text: ',', style: Theme.of(context).textTheme.caption),
        );
        spanTexts.add(
          TextSpan(text: ' ', style: Theme.of(context).textTheme.caption),
        );
      }
      spanTexts.add(TextSpan(
          text: element.firstName ?? "",
          style: Theme.of(context).textTheme.caption));
    });

    return Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(0.2)),
        ),
        child: Text.rich(TextSpan(text: '', children: spanTexts)));
  }

  Widget getReason() {
    return SizedBox(
      height: 50,
      child: DropdownSearch<SaleReturnReasons>(
        compareFn: (item1, item2) {
          return false;
        },
        clearButtonProps: const ClearButtonProps(isVisible: true),
        popupProps: const PopupProps.menu(
          showSelectedItems: true,
        ),
        asyncItems: (String filter) =>
            saleHistoryViewModel.getSaleReturnReasons(),
        onChanged: (value) {
          setState(() {
            reason = value;
            widget.onReasonSelected(reason);
          });
        },
        itemAsString: (item) {
          return item.reason ?? "";
        },
        selectedItem: reason,
      ),
    );
  }
}
