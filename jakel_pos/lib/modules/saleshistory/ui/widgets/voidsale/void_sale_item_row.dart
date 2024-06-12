import 'package:flutter/material.dart';
import 'package:jakel_base/constants.dart';
import 'package:jakel_base/jakel_base.dart';
import 'package:jakel_base/restapi/sales/model/history/SalesResponse.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_pos/modules/products/ProductsViewModel.dart';

class VoidSaleItemRow extends StatefulWidget {
  final SaleItems saleItem;
  final int index;

  const VoidSaleItemRow({
    Key? key,
    required this.saleItem,
    required this.index,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VoidSaleItemRowState();
  }
}

class _VoidSaleItemRowState extends State<VoidSaleItemRow> {
  final productViewModel = ProductsViewModel();

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 10,
          ),
          Text("${widget.index}."),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.saleItem.product?.name ?? ""),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  widget.saleItem.product?.color?.name ?? noData,
                  style: Theme.of(context).textTheme.caption,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  widget.saleItem.product?.size?.name ?? noData,
                  style: Theme.of(context).textTheme.caption,
                )
              ],
            ),
          ),
          Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  getReadableAmount(
                      getCurrency(), widget.saleItem.totalPricePaid),
                ),
              )),
          Expanded(
              flex: 2,
              child: Center(
                child: Text(getStringWithNoDecimal(getAvailableQty())),
              )),
        ],
      ),
    );
  }

  double getAvailableQty() {
    return getDoubleValue(widget.saleItem.quantity) -
        getDoubleValue(widget.saleItem.returnedQuantity ?? 0);
  }
}
