import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:internal_app_promoter/constants/image_assets_constants.dart';
import 'package:internal_app_promoter/modules/common/custom_navigation_drawer/custom_navigation_drawer_screen.dart';
import 'package:internal_app_promoter/modules/promoter/product/product_list/model/promoter_product_list_model.dart';
import 'package:internal_app_promoter/modules/promoter/product/product_list/view/promoter_product_list_row.dart';
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
import 'package:internal_base/data/all_bloc/promoter/get_promoter_products_list/bloc/get_promoter_products_list_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_products_list/bloc/get_promoter_products_list_state.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_products_list/repo/get_promoter_products_list_response.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PromoterProductListScreenWidget extends StatefulWidget {
  final CallbackModel mCallbackModel;

  const PromoterProductListScreenWidget(
      {super.key, required this.mCallbackModel});

  @override
  State<PromoterProductListScreenWidget> createState() =>
      _PromoterProductListScreenWidgetState();
}

class _PromoterProductListScreenWidgetState
    extends State<PromoterProductListScreenWidget> {
  late PromoterProductListScreenModel mPromoterProductListScreenModel;

  @override
  void initState() {
    mPromoterProductListScreenModel =
        PromoterProductListScreenModel(context, widget.mCallbackModel);
    mPromoterProductListScreenModel.setPromoterProductsListBloc();
    mPromoterProductListScreenModel.getSharedPrefsSelectStore();
    mPromoterProductListScreenModel.onInitial();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            key: mPromoterProductListScreenModel.scaffoldKey,
            appBar: AppBars.appBar((value) async {
              if (value == "Menu") {
                mPromoterProductListScreenModel.scaffoldKey.currentState!
                    .openDrawer();
              } else {
                var res = await AppAlert.showFilterDialog(
                  context,
                  "sTitle",
                  AppConstants.cWordConstants.wDilogMessage,
                );
                if (res.isNotEmpty) {
                  mPromoterProductListScreenModel.mFilterValue =
                      FilterValue.fromJson(json.decode(res));
                  mPromoterProductListScreenModel.onInitial();
                }
              }
            }, AppConstants.cWordConstants.wProductListText,
                iconOne: AppBarActionConstants.actionFilter,
                sImageAssetsOne: ImageAssetsConstants.filter,
                sMenu: AppConstants.cWordConstants.wMenuText),
            drawer: CustomNavigationDrawer(
                mCallbackModel: mPromoterProductListScreenModel.mCallbackModel),
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
            BlocListener<GetPromoterProductsListBloc,
                GetPromoterProductsListState>(
              bloc:
                  mPromoterProductListScreenModel.getPromoterProductsListBloc(),
              listener: (context, state) {
                mPromoterProductListScreenModel.promoterProductsListListener(
                    context, state);
              },
            ),
          ])),
    ));
  }

  getListView() {
    return StreamBuilder<GetPromoterProductsListResponse?>(
      stream: mPromoterProductListScreenModel.responseSubject,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          GetPromoterProductsListResponse mGetPromoterProductsListResponse =
              snapshot.data as GetPromoterProductsListResponse;
          if (mGetPromoterProductsListResponse.products != null) {
            return setView(mGetPromoterProductsListResponse.lastPage ?? 0,
                mGetPromoterProductsListResponse.totalRecords ?? 0);
          }
        }
        return Container();
      },
    );
  }

  setView(int lastPage, int totalRecords) {
    return Column(
      children: [
        mPromoterProductListScreenModel.productsList.isNotEmpty
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
        (mPromoterProductListScreenModel.mFilterValue.text!.isNotEmpty ||
                mPromoterProductListScreenModel.mFilterValue.sStock!.isNotEmpty)
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
                            text: mPromoterProductListScreenModel
                                    .mFilterValue.text!.isNotEmpty
                                ? ' ${mPromoterProductListScreenModel.mFilterValue.text} :'
                                : "",
                            style: getTextRegular(
                                size: SizeConstants.s1 * 12,
                                colors: ColorConstants.cOutOfStockTextColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // navigate to desired screen
                              }),
                        TextSpan(
                            text: mPromoterProductListScreenModel
                                    .mFilterValue.sStock!.isNotEmpty
                                ? (mPromoterProductListScreenModel
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
          controller: mPromoterProductListScreenModel.refreshController,
          onLoading: mPromoterProductListScreenModel.onLoading,
          onRefresh: mPromoterProductListScreenModel.onRefresh,

          /// load more
          enablePullUp: mPromoterProductListScreenModel.sPage < lastPage,

          /// pull to refresh
          enablePullDown: true,
          footer: CustomFooter(builder: (context, loadStatus) {
            return customFooter(loadStatus);
          }),
          header: waterDropHeader(),
          child: mPromoterProductListScreenModel.productsList.isNotEmpty
              ? ListView.builder(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  itemCount:
                      mPromoterProductListScreenModel.productsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return PromoterProductListRowWidget(
                        index,
                        mPromoterProductListScreenModel,
                        mPromoterProductListScreenModel.productsList[index]);
                  })
              : Container(
                  height: SizeConstants.height * 0.75,
                  alignment: Alignment.center,
                  child: NoDataFoundWidget(
                    isLoadedAndEmpty:
                        mPromoterProductListScreenModel.productsList.isEmpty,
                  )),
        ))
      ],
    );
  }
}
