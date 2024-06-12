import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internal_app_promoter/modules/promoter/commission/commission_list/model/promoter_commission_list_model.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/text_styles_constants.dart';
import 'package:internal_base/common/utils/date_utils.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_commission_list/repo/get_promoter_commission_list_response.dart';

class PromoterCommissionListRowWidget extends StatelessWidget {
  final int index;
  final PromoterCommissionListScreenModel mPromoterCommissionListScreenModel;
  final CommissionHistory mCommissionHistory;

  const PromoterCommissionListRowWidget(this.index,
      this.mPromoterCommissionListScreenModel, this.mCommissionHistory,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        mPromoterCommissionListScreenModel.mCallbackModel.sValue = "id";
        // Navigator.pushReplacementNamed(
        //     context, RouteConstants.rPromoterSalesReturnsListScreenWidget,
        //     arguments: mPromoterCommissionListScreenModel.mCallbackModel);
      },
      child: Container(
        margin: EdgeInsets.only(
            top: SizeConstants.s1 * 10,
            left: SizeConstants.s1 * 20,
            right: SizeConstants.s1 * 20,
            bottom: SizeConstants.s1 * 10),
        padding: EdgeInsets.all(SizeConstants.s1 * 15),
        width: SizeConstants.width,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border.all(
              color: Colors.grey.shade200, width: SizeConstants.s1 * 1.25),
          borderRadius: BorderRadius.all(Radius.circular(SizeConstants.s1 * 8)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(AppConstants.cWordConstants.wDateText,
                    style: getTextLight(
                        size: SizeConstants.s1 * 15, colors: Colors.black)),
                Expanded(
                    child: Text(
                        getDateFromFormatter(mCommissionHistory.date ?? "",
                            "yyyy-MM-dd", "MMM dd, yyyy"),
                        style: getTextSemiBold(
                            size: SizeConstants.s1 * 15,
                            colors: Colors.black))),
              ],
            ),
            SizedBox(
              height: SizeConstants.s1 * 5,
            ),
            Row(
              children: [
                Text(AppConstants.cWordConstants.wItemsSoldText,
                    style: getTextLight(
                        size: SizeConstants.s1 * 15, colors: Colors.black)),
                Text("${mCommissionHistory.itemSold ?? 0}",
                    style: getTextSemiBold(
                        size: SizeConstants.s1 * 15, colors: Colors.black)),
              ],
            ),
            SizedBox(
              height: SizeConstants.s1 * 5,
            ),
            Row(
              children: [
                Text(AppConstants.cWordConstants.wItemsReturnedText,
                    style: getTextLight(
                        size: SizeConstants.s1 * 15, colors: Colors.black)),
                Text("${mCommissionHistory.itemReturned ?? 0}",
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
                Text("RM${mCommissionHistory.commission ?? ""}",
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
