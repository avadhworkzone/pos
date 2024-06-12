import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:internal_app_promoter/constants/image_assets_constants.dart';
import 'package:internal_app_promoter/modules/common/custom_navigation_drawer/custom_navigation_drawer_screen.dart';
import 'package:internal_app_promoter/modules/promoter/sales_returns/sales_returns_list/model/promoter_sales_returns_list_model.dart';
import 'package:internal_app_promoter/modules/promoter/sales_returns/sales_returns_list/view/promoter_sales_returns_list_row.dart';
import 'package:internal_base/common/alert/app_alert.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/appbar_action_constants.dart';
import 'package:internal_base/common/appbars_constants.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/color_constants.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/text_styles_constants.dart';
import 'package:internal_base/common/utils/app_calendar_utils.dart';
import 'package:internal_base/common/widget/no_data_found_widget.dart';
import 'package:internal_base/common/widget/pull_to_refresh_header_widget.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_sales_returns_list/bloc/get_promoter_sales_returns_list_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_sales_returns_list/bloc/get_promoter_sales_returns_list_state.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_sales_returns_list/repo/GetPromoterSalesReturnsListResponse.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PromoterSalesReturnsListScreenWidget extends StatefulWidget {
  final CallbackModel mCallbackModel;

  const PromoterSalesReturnsListScreenWidget(
      {super.key, required this.mCallbackModel});

  @override
  State<PromoterSalesReturnsListScreenWidget> createState() =>
      _PromoterSalesReturnsListScreenWidgetState();
}

class _PromoterSalesReturnsListScreenWidgetState
    extends State<PromoterSalesReturnsListScreenWidget> {
  late PromoterSalesReturnsListScreenModel mPromoterSalesReturnsListScreenModel;

  @override
  void initState() {
    mPromoterSalesReturnsListScreenModel =
        PromoterSalesReturnsListScreenModel(context, widget.mCallbackModel);

    mPromoterSalesReturnsListScreenModel.setPromoterCommissionListBloc();
    mPromoterSalesReturnsListScreenModel.getSharedPrefsSelectStore();
    mPromoterSalesReturnsListScreenModel.onInitial();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            key: mPromoterSalesReturnsListScreenModel.scaffoldKey,
            appBar: AppBars.appBar((value) async {
              if (value == "Menu") {
                mPromoterSalesReturnsListScreenModel.scaffoldKey.currentState!
                    .openDrawer();
              } else {
                var values = await AppAlert.buildCalendarDialog(
                    context,
                    mPromoterSalesReturnsListScreenModel
                        .dialogCalendarPickerValue,
                    getCalendarDatePickerSingle(context));

                mPromoterSalesReturnsListScreenModel.stringCalendarPickerValue
                    .clear();
                mPromoterSalesReturnsListScreenModel.stringCalendarPickerValue =
                    values;
                if (mPromoterSalesReturnsListScreenModel
                    .stringCalendarPickerValue.isNotEmpty) {
                  mPromoterSalesReturnsListScreenModel.setDate();
                }
              }
            }, AppConstants.cWordConstants.wSalesReturnsText,
                iconOne: AppBarActionConstants.actionFilter,
                sImageAssetsOne: ImageAssetsConstants.filter,
                sMenu: AppConstants.cWordConstants.wMenuText),
            drawer: CustomNavigationDrawer(
                mCallbackModel:
                    mPromoterSalesReturnsListScreenModel.mCallbackModel),
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
            BlocListener<GetPromoterSalesReturnsListBloc,
                GetPromoterSalesReturnsListState>(
              bloc: mPromoterSalesReturnsListScreenModel
                  .getPromoterSalesReturnsListBloc(),
              listener: (context, state) {
                mPromoterSalesReturnsListScreenModel
                    .promoterCommissionListListener(context, state);
              },
            ),
          ])),
    ));
  }

  getListView() {
    return StreamBuilder<GetPromoterSalesReturnsListResponse?>(
      stream: mPromoterSalesReturnsListScreenModel.responseSubject,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          GetPromoterSalesReturnsListResponse
              mGetPromoterSalesReturnsListResponse =
              snapshot.data as GetPromoterSalesReturnsListResponse;
          if (mGetPromoterSalesReturnsListResponse.sales != null) {
            return setView(mGetPromoterSalesReturnsListResponse.lastPage ?? 0,
                mGetPromoterSalesReturnsListResponse.totalRecords ?? 0);
          }
        }
        return NoDataFoundWidget(
          isLoadedAndEmpty:
              mPromoterSalesReturnsListScreenModel.salesReturnsList.isEmpty,
        );
      },
    );
  }

  setView(int lastPage, int totalRecords) {
    return Column(
      children: [
        Visibility(
          visible:
              mPromoterSalesReturnsListScreenModel.salesReturnsList.isNotEmpty,
          child: Container(
              padding: EdgeInsets.all(SizeConstants.s1 * 15),
              margin: EdgeInsets.only(
                  left: SizeConstants.s1 * 25,
                  right: SizeConstants.s1 * 25,
                  top: SizeConstants.s1 * 9,
                  bottom: SizeConstants.s1 * 5),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                    color: ColorConstants.cOutOfStockTextColor,
                    width: SizeConstants.s1 * 1.25),
                borderRadius:
                    BorderRadius.all(Radius.circular(SizeConstants.s1 * 8)),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppConstants.cWordConstants.wDateText,
                              style: getTextRegular(
                                  size: SizeConstants.s1 * 16,
                                  colors: Colors.black)),
                          SizedBox(
                            height: SizeConstants.s1 * 3,
                          ),
                          Text(
                              mPromoterSalesReturnsListScreenModel
                                      .salesSummary?.date ??
                                  "",
                              style: getTextSemiBold(
                                  size: SizeConstants.s1 * 15,
                                  colors: Colors.black)),
                        ],
                      )),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppConstants.cWordConstants.wItemsSoldText,
                              style: getTextRegular(
                                  size: SizeConstants.s1 * 16,
                                  colors: Colors.black)),
                          SizedBox(
                            height: SizeConstants.s1 * 3,
                          ),
                          Text(
                              "${mPromoterSalesReturnsListScreenModel.salesSummary?.itemsSold ?? 0}",
                              style: getTextSemiBold(
                                  size: SizeConstants.s1 * 15,
                                  colors: Colors.black)),
                        ],
                      )),
                    ],
                  ),
                  SizedBox(
                    height: SizeConstants.s1 * 8,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppConstants.cWordConstants.wItemsReturnedText,
                              style: getTextRegular(
                                  size: SizeConstants.s1 * 16,
                                  colors: Colors.black)),
                          SizedBox(
                            height: SizeConstants.s1 * 3,
                          ),
                          Text(
                              "${mPromoterSalesReturnsListScreenModel.salesSummary?.itemsReturned ?? 0}",
                              style: getTextSemiBold(
                                  size: SizeConstants.s1 * 15,
                                  colors: Colors.black)),
                        ],
                      )),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "${AppConstants.cWordConstants.wCommissionText}:",
                              style: getTextRegular(
                                  size: SizeConstants.s1 * 16,
                                  colors: Colors.black)),
                          SizedBox(
                            height: SizeConstants.s1 * 3,
                          ),
                          const Icon(size: 18,Icons.timer_outlined, color: Colors.grey,)
                          // Text(
                          //     "${mPromoterSalesReturnsListScreenModel.salesSummary?.itemsReturned ?? 0}",
                          //     style: getTextSemiBold(
                          //         size: SizeConstants.s1 * 15,
                          //         colors: Colors.black)),
                        ],
                      )),
                    ],
                  ),
                ],
              )),
        ),
        Expanded(
            child: SmartRefresher(
          controller: mPromoterSalesReturnsListScreenModel.refreshController,
          onLoading: mPromoterSalesReturnsListScreenModel.onLoading,
          onRefresh: mPromoterSalesReturnsListScreenModel.onRefresh,

          /// load more
          enablePullUp: true,

          /// pull to refresh
          enablePullDown: true,
          footer: CustomFooter(builder: (context, loadStatus) {
            return customFooter(loadStatus);
          }),
          header: waterDropHeader(),
          child:
              mPromoterSalesReturnsListScreenModel.salesReturnsList.isNotEmpty
                  ? ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: mPromoterSalesReturnsListScreenModel
                          .salesReturnsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return PromoterSalesReturnsListRowWidget(
                            index,
                            mPromoterSalesReturnsListScreenModel,
                            mPromoterSalesReturnsListScreenModel
                                .salesReturnsList[index]);
                      })
                  : Container(
                      height: SizeConstants.height * 0.75,
                      alignment: Alignment.center,
                      child: NoDataFoundWidget(
                        isLoadedAndEmpty: mPromoterSalesReturnsListScreenModel
                            .salesReturnsList.isEmpty,
                      )),
        ))
      ],
    );
  }
}
