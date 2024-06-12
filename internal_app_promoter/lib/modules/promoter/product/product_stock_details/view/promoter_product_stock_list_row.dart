import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internal_app_promoter/modules/promoter/product/product_list/model/promoter_product_list_model.dart';
import 'package:internal_app_promoter/modules/promoter/product/product_stock_details/model/promoter_product_stock_details_model.dart';
import 'package:internal_app_promoter/routes/route_constants.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/color_constants.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/text_styles_constants.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_products_list/repo/get_promoter_products_list_response.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_products_stock_list/repo/get_promoter_products_stock_list_response.dart';

class PromoterProductStockListRowWidget extends StatelessWidget {
  final int index;
  final PromoterProductStockDetailsScreenModel mPromoterProductStockDetailsScreenModel;
  final StoreStock mStoreStock;

  const PromoterProductStockListRowWidget(
      this.index, this.mPromoterProductStockDetailsScreenModel, this.mStoreStock,
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
              Expanded(child:  Text(mStoreStock.storeName??"--",
                  style: getTextRegular(
                      size: SizeConstants.s1 * 16, colors: Colors.black))),
              SizedBox(width: SizeConstants.s1*20,),
              Text(mStoreStock.stock??"--",
                  style: getTextSemiBold(
                      size: SizeConstants.s1 * 16, colors: Colors.black)),
            ],
          )
      ),
    );
  }
}
