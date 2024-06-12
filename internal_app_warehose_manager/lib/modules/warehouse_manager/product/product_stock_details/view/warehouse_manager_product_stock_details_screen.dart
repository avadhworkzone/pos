import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:internal_app_warehose_manager/modules/warehouse_manager/product/product_stock_details/model/warehouse_manager_product_stock_details_model.dart';
import 'package:internal_app_warehose_manager/modules/warehouse_manager/product/product_stock_details/view/warehouse_manager_product_stock_list_row.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/appbar_action_constants.dart';
import 'package:internal_base/common/appbars_constants.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/text_styles_constants.dart';
import 'package:internal_base/common/widget/edit_text_field.dart';
import 'package:internal_base/common/widget/no_data_found_widget.dart';
import 'package:internal_base/common/widget/pull_to_refresh_header_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WarehouseManagerProductStockDetailsScreenWidget extends StatefulWidget {
  final CallbackModel mCallbackModel;

  const WarehouseManagerProductStockDetailsScreenWidget(
      {super.key, required this.mCallbackModel});

  @override
  State<WarehouseManagerProductStockDetailsScreenWidget> createState() =>
      _WarehouseManagerProductStockDetailsScreenWidgetState();
}

class _WarehouseManagerProductStockDetailsScreenWidgetState
    extends State<WarehouseManagerProductStockDetailsScreenWidget> {
  late WarehouseManagerProductStockDetailsScreenModel
      mWarehouseManagerProductStockDetailsScreenModel;

  @override
  void initState() {
    mWarehouseManagerProductStockDetailsScreenModel =
        WarehouseManagerProductStockDetailsScreenModel(
            context, widget.mCallbackModel);
    mWarehouseManagerProductStockDetailsScreenModel.setWarehouseManagerProductsStockListBloc();
    mWarehouseManagerProductStockDetailsScreenModel.onInitial();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBars.appBarBack((value) {
          if (value == AppBarActionConstants.actionBack) {
            Navigator.pop(context);
          }
        }, AppConstants.cWordConstants.wProductDetailsText),
        body: _buildSplashScreenWidgetView());
  }

  _buildSplashScreenWidgetView() {
    return FocusDetector(
        child: SafeArea(
      child: Container(
          height: SizeConstants.height,
          width: SizeConstants.width,
          padding: EdgeInsets.only(top: SizeConstants.s1 * 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(SizeConstants.s1 * 20),
                topLeft: Radius.circular(SizeConstants.s1 * 20),
              )),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(
                    left: SizeConstants.s1 * 25,
                    top: SizeConstants.s1 * 5,
                    bottom: SizeConstants.s1 * 10),
                child: Text(AppConstants.cWordConstants.wStockText,
                    style: getTextSemiBold(
                        size: SizeConstants.s1 * 17, colors: Colors.black)),
              ),

              ///stock View
              stockView(),
            ],
          )),
    ));
  }

  stockView() {
    return Expanded(
        child: Container(
      margin: EdgeInsets.only(
          left: SizeConstants.s1 * 25,
          right: SizeConstants.s1 * 25,
          bottom: SizeConstants.s1 * 10),
      padding: EdgeInsets.all(SizeConstants.s1 * 15),
      width: SizeConstants.width,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
            color: Colors.grey.shade200, width: SizeConstants.s1 * 1.25),
        borderRadius: BorderRadius.all(Radius.circular(SizeConstants.s1 * 8)),
      ),
      child: Column(
        children: [
          ///search
          editSearchText(
              mWarehouseManagerProductStockDetailsScreenModel
                  .mSearchTextEditingController,
              () {
                mWarehouseManagerProductStockDetailsScreenModel.onInitial();
              },
              labelText: AppConstants.cWordConstants.wSearchText,
              hintText: AppConstants.cWordConstants.wPleaseEnterSearchText,
              mIcons: Icons.search),

          ///list
          Expanded(child: listView())
        ],
      ),
    ));
  }

  listView() {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(
                top: SizeConstants.s1 * 20,
                left: SizeConstants.s1 * 5,
                right: SizeConstants.s1 * 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Location",
                    style: getTextSemiBold(
                        size: SizeConstants.s1 * 15, colors: Colors.black)),
                Text(AppConstants.cWordConstants.wStockText,
                    style: getTextSemiBold(
                        size: SizeConstants.s1 * 15, colors: Colors.black)),
              ],
            )),
        Expanded(
            child: Container(
          margin: EdgeInsets.only(
              left: SizeConstants.s1 * 5,
              right: SizeConstants.s1 * 5,
              bottom: SizeConstants.s1 * 3,
              top: SizeConstants.s1 * 8),
          padding: EdgeInsets.all(SizeConstants.s1 * 15),
          width: SizeConstants.width,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
                color: Colors.grey.shade200, width: SizeConstants.s1 * 1.25),
            borderRadius:
                BorderRadius.all(Radius.circular(SizeConstants.s1 * 8)),
          ),
              child: view(),
        ))
      ],
    );
  }

  view(){
    return  SmartRefresher(
      controller: mWarehouseManagerProductStockDetailsScreenModel.refreshController,
      onLoading: mWarehouseManagerProductStockDetailsScreenModel.onLoading,
      onRefresh: mWarehouseManagerProductStockDetailsScreenModel.onRefresh,

      /// load more
      enablePullUp: true,

      /// pull to refresh
      enablePullDown: true,
      footer: CustomFooter(builder: (context, loadStatus) {
        return customFooter(loadStatus);
      }),
      header: waterDropHeader(),
      child: mWarehouseManagerProductStockDetailsScreenModel.warehouseStockList.isNotEmpty
          ? ListView.builder(
          padding: const EdgeInsets.all(0),
          itemCount: 100,
          itemBuilder: (BuildContext context, int index) {
            return WarehouseManagerProductsStockListRowWidget(
                index,
                mWarehouseManagerProductStockDetailsScreenModel,
                mWarehouseManagerProductStockDetailsScreenModel
                    .warehouseStockList[index]);
          })
          : NoDataFoundWidget(
        isLoadedAndEmpty:
        mWarehouseManagerProductStockDetailsScreenModel.warehouseStockList.isEmpty,
      ),
    );
  }
}
