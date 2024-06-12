import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internal_app_warehose_manager/modules/warehouse_manager/product/product_stock_details/model/warehouse_manager_product_stock_details_model.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/text_styles_constants.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_products_stock_list/repo/warehouse_manager_products_stock_list_response.dart';

class WarehouseManagerProductsStockListRowWidget extends StatelessWidget {
  final int index;
  final WarehouseManagerProductStockDetailsScreenModel mPromoterProductStockDetailsScreenModel;
  final WarehouseStock mWarehouseStock;

  const WarehouseManagerProductsStockListRowWidget(
      this.index, this.mPromoterProductStockDetailsScreenModel, this.mWarehouseStock,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // mPromoterProductListScreenModel.mCallbackModel.sValue = "id";
        // Navigator.pushNamed(
        //     context, RouteConstants.rPromoterProductDetailsScreenWidget,
        //     arguments: mPromoterProductListScreenModel.mCallbackModel);
      },
      child: Container(
          margin: EdgeInsets.only(bottom: SizeConstants.s1*10),
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child:  Text(mWarehouseStock.storeName??"--",
                  style: getTextRegular(
                      size: SizeConstants.s1 * 16, colors: Colors.black))),
              SizedBox(width: SizeConstants.s1*20,),
              Text(mWarehouseStock.stock??"--",
                  style: getTextSemiBold(
                      size: SizeConstants.s1 * 16, colors: Colors.black)),
            ],
          )
      ),
    );
  }
}
