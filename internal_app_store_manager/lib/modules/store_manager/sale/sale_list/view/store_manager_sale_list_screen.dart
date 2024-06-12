import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:internal_app_store_manager/constants/image_assets_constants.dart';
import 'package:internal_app_store_manager/modules/common/custom_navigation_drawer/custom_navigation_drawer_screen.dart';
import 'package:internal_app_store_manager/modules/store_manager/sale/sale_list/model/store_manager_sale_list_model.dart';
import 'package:internal_app_store_manager/modules/store_manager/sale/sale_list/view/store_manager_sale_list_row.dart';
import 'package:internal_base/common/alert/app_alert.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/appbar_action_constants.dart';
import 'package:internal_base/common/appbars_constants.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/text_styles_constants.dart';
import 'package:internal_base/common/utils/app_calendar_utils.dart';
import 'package:internal_base/common/widget/no_data_found_widget.dart';
import 'package:internal_base/common/widget/pull_to_refresh_header_widget.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_sales_list/bloc/store_manager_sales_list_bloc.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_sales_list/bloc/store_manager_sales_list_state.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_sales_list/repo/store_manager_sales_list_response.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoreManagerSaleListScreenWidget extends StatefulWidget {
  final CallbackModel mCallbackModel;

  const StoreManagerSaleListScreenWidget(
      {super.key, required this.mCallbackModel});

  @override
  State<StoreManagerSaleListScreenWidget> createState() =>
      _StoreManagerSaleListScreenWidgetState();
}

class _StoreManagerSaleListScreenWidgetState
    extends State<StoreManagerSaleListScreenWidget> {
  late StoreManagerSaleListScreenModel mStoreManagerSaleListScreenModel;

  @override
  void initState() {
    mStoreManagerSaleListScreenModel =
        StoreManagerSaleListScreenModel(context, widget.mCallbackModel);
    mStoreManagerSaleListScreenModel.setStoreManagerSalesListBloc();
    Future.delayed(const Duration(microseconds: 3), () {

      mStoreManagerSaleListScreenModel. getSharedPrefsSelectStore();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            key: mStoreManagerSaleListScreenModel.scaffoldKey,
            appBar: AppBars.appBar((value) async {
              if (value == "Menu") {
                mStoreManagerSaleListScreenModel.scaffoldKey.currentState!
                    .openDrawer();
              }else {
                var values = await AppAlert.buildCalendarDialog(
                    context,
                    mStoreManagerSaleListScreenModel
                        .dialogCalendarPickerValue,
                    getCalendarDatePickerSingle(context));

                mStoreManagerSaleListScreenModel.stringCalendarPickerValue
                    .clear();
                mStoreManagerSaleListScreenModel.stringCalendarPickerValue =
                    values;
                if (mStoreManagerSaleListScreenModel
                    .stringCalendarPickerValue.isNotEmpty) {
                  mStoreManagerSaleListScreenModel.setDate();
                }
              }
            }, AppConstants.cWordConstants.wSalesText,
                iconOne: AppBarActionConstants.actionFilter,
                sImageAssetsOne: ImageAssetsConstants.filter,
                sMenu: AppConstants.cWordConstants.wMenuText),
            drawer: CustomNavigationDrawer(
                mCallbackModel:
                    mStoreManagerSaleListScreenModel.mCallbackModel),
            body: _buildSplashScreenWidgetView()));
  }

  _buildSplashScreenWidgetView() {
    return FocusDetector(
        onVisibilityGained: () {},
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
                BlocListener<GetStoreManagerSalesListBloc,
                    GetStoreManagerSalesListState>(
                  bloc: mStoreManagerSaleListScreenModel
                      .getStoreManagerSalesListBloc(),
                  listener: (context, state) {
                    mStoreManagerSaleListScreenModel
                        .storeManagerSalesListListener(context, state);
                  },
                ),
              ])),
        ));
  }

  getListView() {
    return StreamBuilder<GetStoreManagerSalesListResponse?>(
      stream: mStoreManagerSaleListScreenModel.responseSubject,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          GetStoreManagerSalesListResponse mGetStoreManagerSalesListResponse =
              snapshot.data as GetStoreManagerSalesListResponse;
          if (mGetStoreManagerSalesListResponse.data != null) {
            return setView(mGetStoreManagerSalesListResponse.lastPage ?? 0,
                mGetStoreManagerSalesListResponse.totalRecords ?? 0);
          }
        }
        return const Center(
          child: NoDataFoundWidget(
            isLoadedAndEmpty: true,
          ),
        );
      },
    );
  }

  setView(int lastPage, int totalRecords) {
    return Column(
      children: [
       Container(
                margin: EdgeInsets.only(
                    left: SizeConstants.s1 * 30,
                    right: SizeConstants.s1 * 30,
                    top: SizeConstants.s1 * 9,
                    bottom: SizeConstants.s1 * 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppConstants.cWordConstants.wDateText,
                            style: getTextRegular(
                                size: SizeConstants.s1 * 15,
                                colors: Colors.black)),
                        SizedBox(
                          height: SizeConstants.s1 * 5,
                        ),
                        Text(mStoreManagerSaleListScreenModel.getDate(),
                            style: getTextSemiBold(
                                size: SizeConstants.s1 * 15,
                                colors: Colors.black)),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${AppConstants.cWordConstants.wSalesText}: ",
                            style: getTextRegular(
                                size: SizeConstants.s1 * 15,
                                colors: Colors.black)),
                        SizedBox(
                          height: SizeConstants.s1 * 5,
                        ),
                        Text("$totalRecords",
                            style: getTextSemiBold(
                                size: SizeConstants.s1 * 15,
                                colors: Colors.black)),
                      ],
                    )),
                  ],
                )),
        Expanded(
            child: SmartRefresher(
          controller: mStoreManagerSaleListScreenModel.refreshController,
          onLoading: mStoreManagerSaleListScreenModel.onLoading,
          onRefresh: mStoreManagerSaleListScreenModel.onRefresh,

          /// load more
          enablePullUp: mStoreManagerSaleListScreenModel.sPage < lastPage,

          /// pull to refresh
          enablePullDown: true,
          footer: CustomFooter(builder: (context, loadStatus) {
            return customFooter(loadStatus);
          }),
          header: waterDropHeader(),
          child: mStoreManagerSaleListScreenModel.storeStockList.isNotEmpty
              ? ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: mStoreManagerSaleListScreenModel.storeStockList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return StoreManagerSaleListRowWidget(
                        index, mStoreManagerSaleListScreenModel,mStoreManagerSaleListScreenModel.storeStockList[index]);
                  })
              : Center(
                  child: NoDataFoundWidget(
                    isLoadedAndEmpty:
                        mStoreManagerSaleListScreenModel.storeStockList.isEmpty,
                  ),
                ),
        ))
      ],
    );
  }
}
