import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internal_app_store_manager/modules/store_manager/sale/sale_list/model/store_manager_sale_list_model.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/text_styles_constants.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_sales_list/repo/store_manager_sales_list_response.dart';

class StoreManagerSaleListRowWidget extends StatelessWidget{
  final int index;
  final StoreManagerSaleListScreenModel mStoreManagerSaleListScreenModel;
  final SalesListData mSalesListData;

  const StoreManagerSaleListRowWidget(this.index,this.mStoreManagerSaleListScreenModel,this.mSalesListData, {super.key});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        // mStoreManagerSaleListScreenModel.mCallbackModel.returnValueChanged("Details","id");
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
          color: Colors.transparent,
          border: Border.all(
              color: Colors.grey.shade200,
              width: SizeConstants.s1 * 1.25),
          borderRadius: BorderRadius.all(
              Radius.circular(SizeConstants.s1 * 8)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(AppConstants.cWordConstants.wReceiptIdText,
                    style: getTextLight(
                        size: SizeConstants.s1 * 14,
                        colors: Colors.black)),
                Expanded(
                    child: Text(mSalesListData.receiptId ?? "-",
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
                Text(
                    AppConstants
                        .cWordConstants.wSalesAmountText,
                    style: getTextLight(
                        size: SizeConstants.s1 * 14,
                        colors: Colors.black)),
                Text("RM${mSalesListData.salesAmount}",
                    style: getTextSemiBold(
                        size: SizeConstants.s1 * 15,
                        colors: Colors.black)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}