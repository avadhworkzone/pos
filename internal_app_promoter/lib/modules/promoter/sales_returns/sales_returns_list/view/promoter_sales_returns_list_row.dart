import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internal_app_promoter/modules/promoter/sales_returns/sales_returns_list/model/promoter_sales_returns_list_model.dart';
import 'package:internal_app_promoter/routes/route_constants.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/color_constants.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/text_styles_constants.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_sales_returns_list/repo/GetPromoterSalesReturnsListResponse.dart';

class PromoterSalesReturnsListRowWidget extends StatelessWidget {
  final int index;
  final PromoterSalesReturnsListScreenModel
      mPromoterSalesReturnsListScreenModel;
  final Sales mSalesReturns;

  const PromoterSalesReturnsListRowWidget(
      this.index, this.mPromoterSalesReturnsListScreenModel, this.mSalesReturns,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        mPromoterSalesReturnsListScreenModel.mCallbackModel.sValue =
            mSalesReturns.id.toString();
        mPromoterSalesReturnsListScreenModel.mCallbackModel.sMenuValue =
            mSalesReturns.status;
        Navigator.pushNamed(
            context, RouteConstants.rPromoterSalesReturnsDetailsScreenWidget,
            arguments: mPromoterSalesReturnsListScreenModel.mCallbackModel);
      },
      child: Container(
        margin: EdgeInsets.only(
            top: SizeConstants.s1 * 10,
            left: SizeConstants.s1 * 15,
            right: SizeConstants.s1 * 15,
            bottom: SizeConstants.s1 * 10),
        padding: EdgeInsets.all(SizeConstants.s1 * 15),
        width: SizeConstants.width,
        decoration: BoxDecoration(
            color: Colors.transparent,
          // color: (mSalesReturns.commissionAmount ?? "0") == "0"
          //     ? Colors.grey.shade100
          //     : Colors.transparent,
          border: Border.all(
              color: Colors.grey.shade200, width: SizeConstants.s1 * 1.25),
          borderRadius: BorderRadius.all(Radius.circular(SizeConstants.s1 * 8)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(AppConstants.cWordConstants.wReceiptIdText,
                    style: getTextLight(
                        size: SizeConstants.s1 * 15, colors: Colors.black)),
                Expanded(
                    child: Text(mSalesReturns.receiptId ?? "",
                        style: getTextSemiBold(
                            size: SizeConstants.s1 * 14,
                            colors: Colors.black))),
                ((mSalesReturns.status ?? "") == "SALE")
                    ? Container(
                        padding: EdgeInsets.only(
                            left: SizeConstants.s1 * 10,
                            right: SizeConstants.s1 * 10,
                            top: SizeConstants.s1 * 5,
                            bottom: SizeConstants.s1 * 5),
                        decoration: BoxDecoration(
                          color: ColorConstants.cOutOfStockBackGroundColor,
                          borderRadius: BorderRadius.all(
                              Radius.circular(SizeConstants.s1 * 8)),
                        ),
                        child: Text(
                          AppConstants.cWordConstants.wSaleText,
                          style: getTextRegular(
                              size: SizeConstants.s1 * 12,
                              colors: ColorConstants.cOutOfStockTextColor),
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.only(
                            left: SizeConstants.s1 * 10,
                            right: SizeConstants.s1 * 10,
                            top: SizeConstants.s1 * 5,
                            bottom: SizeConstants.s1 * 5),
                        decoration: BoxDecoration(
                          color: ColorConstants.cOutOfStockBackGroundColor,
                          borderRadius: BorderRadius.all(
                              Radius.circular(SizeConstants.s1 * 8)),
                        ),
                        child: Text(
                          AppConstants.cWordConstants.wReturnText,
                          style: getTextRegular(
                              size: SizeConstants.s1 * 12,
                              colors: ColorConstants.cOutOfStockTextColor),
                        ),
                      )
              ],
            ),
            SizedBox(
              height: SizeConstants.s1 * 5,
            ),
            Row(
              children: [
                Text(
                    ((mSalesReturns.status ?? "") == "SALE")
                        ? AppConstants.cWordConstants.wItemsSoldText
                        : AppConstants.cWordConstants.wItemsReturnedText,
                    style: getTextLight(
                        size: SizeConstants.s1 * 15, colors: Colors.black)),
                Text(mSalesReturns.unitSold ?? "",
                    style: getTextSemiBold(
                        size: SizeConstants.s1 * 15, colors: Colors.black)),
              ],
            ),
            SizedBox(
              height: SizeConstants.s1 * 5,
            ),
            Row(
              children: [
                Text("${AppConstants.cWordConstants.wAmountText}: ",
                    style: getTextLight(
                        size: SizeConstants.s1 * 15, colors: Colors.black)),
                Text(mSalesReturns.amount ?? "",
                    style: getTextSemiBold(
                        size: SizeConstants.s1 * 15, colors: Colors.black)),
              ],
            ),
            SizedBox(
              height: SizeConstants.s1 * 5,
            ),
            Row(
              children: [
                Text("${AppConstants.cWordConstants.wCommissionText}: ",
                    style: getTextLight(
                        size: SizeConstants.s1 * 15, colors: Colors.black)),
                const Icon(size: 18,Icons.timer_outlined, color: Colors.grey,)
                // Text(mSalesReturns.commissionAmount ?? "",
                //     style: getTextSemiBold(
                //         size: SizeConstants.s1 * 15, colors: Colors.black)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
