import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internal_app_promoter/modules/promoter/product/product_list/model/promoter_product_list_model.dart';
import 'package:internal_app_promoter/routes/route_constants.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/color_constants.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/text_styles_constants.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_products_list/repo/get_promoter_products_list_response.dart';

class PromoterProductListRowWidget extends StatelessWidget {
  final int index;
  final PromoterProductListScreenModel mPromoterProductListScreenModel;
  final Products mProducts;

  const PromoterProductListRowWidget(
      this.index, this.mPromoterProductListScreenModel, this.mProducts,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        mPromoterProductListScreenModel.mCallbackModel.sValue =
            mProducts.id.toString();
        Navigator.pushNamed(
            context, RouteConstants.rPromoterProductDetailsScreenWidget,
            arguments: mPromoterProductListScreenModel.mCallbackModel);
      },
      child: Container(
        margin: EdgeInsets.only(
            top: SizeConstants.s1 * 10,
            left: SizeConstants.s1 * 15,
            right: SizeConstants.s1 * 15,
            bottom: SizeConstants.s1 * 10),
        padding: EdgeInsets.only(left:SizeConstants.s1 * 15,
            top:SizeConstants.s1 * 15,
            bottom:SizeConstants.s1 * 15,
            right:SizeConstants.s1 * 10),
        width: SizeConstants.width,
        decoration: BoxDecoration(
          color:
          (mProducts.stock??"0") == "0" ? Colors.grey.shade100 : Colors.transparent,
          border: Border.all(
              color: Colors.grey.shade200, width: SizeConstants.s1 * 1.25),
          borderRadius: BorderRadius.all(Radius.circular(SizeConstants.s1 * 8)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppConstants.cWordConstants.wNameText,
                    style: getTextLight(
                        size: SizeConstants.s1 * 14, colors: Colors.black)),
                Expanded(
                    child: Text(mProducts.name ?? "-",
                        style: getTextSemiBold(
                            size: SizeConstants.s1 * 15,
                            colors: Colors.black))),
                (mProducts.stock??"0") == "0"
                    ? Container(
                  margin: EdgeInsets.only(left: SizeConstants.s1 * 10),
                        padding: EdgeInsets.only(
                            left: SizeConstants.s1 * 10,
                            right: SizeConstants.s1 * 10,
                            top: SizeConstants.s1 * 4,
                            bottom: SizeConstants.s1 * 3),
                        decoration: BoxDecoration(
                          color: ColorConstants.cOutOfStockBackGroundColor,
                          borderRadius: BorderRadius.all(
                              Radius.circular(SizeConstants.s1 * 8)),
                        ),
                        child: Text(
                          AppConstants.cWordConstants.wOutOfStockText,
                          style: getTextRegular(
                              size: SizeConstants.s1 * 11,
                              colors: ColorConstants.cOutOfStockTextColor),
                        ),
                      )
                    : const SizedBox()
              ],
            ),
            SizedBox(
              height: SizeConstants.s1 * 5,
            ),
            Row(
              children: [
                Text(AppConstants.cWordConstants.wArticleNumberText,
                    style: getTextLight(
                        size: SizeConstants.s1 * 14, colors: Colors.black)),
                Text(mProducts.articleNumber ?? "-",
                    style: getTextSemiBold(
                        size: SizeConstants.s1 * 15, colors: Colors.black)),
              ],
            ),
            SizedBox(
              height: SizeConstants.s1 * 5,
            ),
            Row(
              children: [
                Text(AppConstants.cWordConstants.wUPCText,
                    style: getTextLight(
                        size: SizeConstants.s1 * 14, colors: Colors.black)),
                Text(mProducts.upc ?? "-",
                    style: getTextSemiBold(
                        size: SizeConstants.s1 * 15, colors: Colors.black)),
              ],
            ),
            SizedBox(
              height: SizeConstants.s1 * 5,
            ),
            Row(
              children: [
                Text(AppConstants.cWordConstants.wPriceText,
                    style: getTextLight(
                        size: SizeConstants.s1 * 14, colors: Colors.black)),
                Text("RM${mProducts.price ?? 0.00}",
                    style: getTextSemiBold(
                        size: SizeConstants.s1 * 15, colors: Colors.black)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
