import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:internal_app_warehose_manager/constants/image_assets_constants.dart';
import 'package:internal_app_warehose_manager/modules/common/custom_navigation_drawer/custom_navigation_drawer_screen.dart';
import 'package:internal_app_warehose_manager/modules/warehouse_manager/product/product_list/model/warehouse_manager_product_list_model.dart';
import 'package:internal_app_warehose_manager/modules/warehouse_manager/product/product_list/view/warehouse_manager_product_list_row.dart';
import 'package:internal_base/common/alert/app_alert.dart';
import 'package:internal_base/common/alert/filter_value.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/appbar_action_constants.dart';
import 'package:internal_base/common/appbars_constants.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/color_constants.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/text_styles_constants.dart';
import 'package:internal_base/common/widget/no_data_found_widget.dart';
import 'package:internal_base/common/widget/pull_to_refresh_header_widget.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_products_list/bloc/warehouse_manager_products_list_bloc.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_products_list/bloc/warehouse_manager_products_list_state.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_products_list/repo/warehouse_manager_products_list_response.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WarehouseManagerProductListScreenWidget extends StatefulWidget {
  final CallbackModel mCallbackModel;

  const WarehouseManagerProductListScreenWidget(
      {super.key, required this.mCallbackModel});

  @override
  State<WarehouseManagerProductListScreenWidget> createState() =>
      _WarehouseManagerProductListScreenWidgetState();
}

class _WarehouseManagerProductListScreenWidgetState
    extends State<WarehouseManagerProductListScreenWidget> {
  late WarehouseManagerProductListScreenModel
      mWarehouseManagerProductListScreenModel;


  @override
  void initState() {
    mWarehouseManagerProductListScreenModel =
        WarehouseManagerProductListScreenModel(context, widget.mCallbackModel);
    mWarehouseManagerProductListScreenModel.setWarehouseManagerProductsListBloc();
    mWarehouseManagerProductListScreenModel.getSharedPrefsSelectStore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            key: mWarehouseManagerProductListScreenModel.scaffoldKey,
            appBar: AppBars.appBar((value) async {
              if (value == "Menu") {
                mWarehouseManagerProductListScreenModel.scaffoldKey.currentState!
                    .openDrawer();
              } else {
                var res = await AppAlert.showFilterDialog(
                  context,
                  "sTitle",
                  AppConstants.cWordConstants.wDilogMessage,
                );
                if (res.isNotEmpty) {
                  mWarehouseManagerProductListScreenModel.mFilterValue =
                      FilterValue.fromJson(json.decode(res));
                  mWarehouseManagerProductListScreenModel.onInitial();
                }
              }
            }, AppConstants.cWordConstants.wProductListText,
                iconOne: AppBarActionConstants.actionFilter,
                sImageAssetsOne: ImageAssetsConstants.filter,
                sMenu: AppConstants.cWordConstants.wMenuText),
            drawer: CustomNavigationDrawer(
                mCallbackModel: mWarehouseManagerProductListScreenModel.mCallbackModel),
            body: _buildSplashScreenWidgetView()));
  }

  _buildSplashScreenWidgetView() {
    return FocusDetector(
        child: SafeArea(
          child: Container(
              height: SizeConstants.height,
              width: SizeConstants.width,
              padding: EdgeInsets.only(top: SizeConstants.s1 * 15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(SizeConstants.s1 * 20),
                    topLeft: Radius.circular(SizeConstants.s1 * 20),
                  )),
              child: MultiBlocListener(child: getListView(), listeners: [
                BlocListener<GetWarehouseManagerProductsListBloc,
                    GetWarehouseManagerProductsListState>(
                  bloc:
                  mWarehouseManagerProductListScreenModel.getWarehouseManagerProductsListBloc(),
                  listener: (context, state) {
                    mWarehouseManagerProductListScreenModel.warehouseManagerProductsListListener(
                        context, state);
                  },
                ),
              ])),
        ));
  }

  getListView() {
    return StreamBuilder<GetWarehouseManagerProductsListResponse?>(
      stream: mWarehouseManagerProductListScreenModel.responseSubject,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          GetWarehouseManagerProductsListResponse mGetWarehouseManagerProductsListResponse =
          snapshot.data as GetWarehouseManagerProductsListResponse;
          if (mGetWarehouseManagerProductsListResponse.products != null) {
            return setView(mGetWarehouseManagerProductsListResponse.lastPage ?? 0,
                mGetWarehouseManagerProductsListResponse.totalRecords ?? 0);
          }
        }
        return Container(
            height: SizeConstants.height * 0.75,
            alignment: Alignment.center,
            child: const NoDataFoundWidget(
              isLoadedAndEmpty: true,
            ));
      },
    );
  }

  setView(int lastPage, int totalRecords) {
    return Column(
      children: [
        mWarehouseManagerProductListScreenModel.productsList.isNotEmpty
            ? Container(
          margin: EdgeInsets.only(
              left: SizeConstants.s1 * 25,
              top: SizeConstants.s1 * 10,
              bottom: SizeConstants.s1 * 8),
          child: Row(
            children: [
              Text(AppConstants.cWordConstants.wCountsText,
                  style: getTextLight(
                      size: SizeConstants.s1 * 15, colors: Colors.black)),
              Text("$totalRecords",
                  style: getTextSemiBold(
                      size: SizeConstants.s1 * 15, colors: Colors.black)),
            ],
          ),
        )
            : const SizedBox(),
        (mWarehouseManagerProductListScreenModel.mFilterValue.text!.isNotEmpty ||
            mWarehouseManagerProductListScreenModel.mFilterValue.sStock!.isNotEmpty)
            ? Container(
          width: SizeConstants.width,
          alignment: Alignment.centerRight,
          margin: EdgeInsets.only(
              right: SizeConstants.s1 * 25,
              left: SizeConstants.s1 * 65,
              bottom: SizeConstants.s1 * 0),
          child: RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
                text: 'Results for',
                style: getTextRegular(
                    size: SizeConstants.s1 * 12, colors: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: mWarehouseManagerProductListScreenModel
                          .mFilterValue.text!.isNotEmpty
                          ? ' ${mWarehouseManagerProductListScreenModel.mFilterValue.text} :'
                          : "",
                      style: getTextRegular(
                          size: SizeConstants.s1 * 12,
                          colors: ColorConstants.cOutOfStockTextColor),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // navigate to desired screen
                        }),
                  TextSpan(
                      text: mWarehouseManagerProductListScreenModel
                          .mFilterValue.sStock!.isNotEmpty
                          ? (mWarehouseManagerProductListScreenModel
                          .mFilterValue.sStock ==
                          "0"
                          ? ' No Stock products'
                          : " All Stock products")
                          : "",
                      style: getTextRegular(
                          size: SizeConstants.s1 * 12,
                          colors: ColorConstants.cOutOfStockTextColor),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // navigate to desired screen
                        })
                ]),
          ),
        )
            : const SizedBox(),
        Expanded(
            child: SmartRefresher(
              controller: mWarehouseManagerProductListScreenModel.refreshController,
              onLoading: mWarehouseManagerProductListScreenModel.onLoading,
              onRefresh: mWarehouseManagerProductListScreenModel.onRefresh,

              /// load more
              enablePullUp: mWarehouseManagerProductListScreenModel.sPage < lastPage,

              /// pull to refresh
              enablePullDown: true,
              footer: CustomFooter(builder: (context, loadStatus) {
                return customFooter(loadStatus);
              }),
              header: waterDropHeader(),
              child: mWarehouseManagerProductListScreenModel.productsList.isNotEmpty
                  ? ListView.builder(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  itemCount:
                  mWarehouseManagerProductListScreenModel.productsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return WarehouseManagerProductListRowWidget(
                        index,
                        mWarehouseManagerProductListScreenModel,
                        mWarehouseManagerProductListScreenModel.productsList[index]);
                  })
                  : Container(
                  height: SizeConstants.height * 0.75,
                  alignment: Alignment.center,
                  child: NoDataFoundWidget(
                    isLoadedAndEmpty:
                    mWarehouseManagerProductListScreenModel.productsList.isEmpty,
                  )),
            ))
      ],
    );
  }
}
