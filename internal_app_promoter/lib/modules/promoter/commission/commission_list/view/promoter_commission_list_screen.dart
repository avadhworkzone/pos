import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:internal_app_promoter/constants/image_assets_constants.dart';
import 'package:internal_app_promoter/modules/common/custom_navigation_drawer/custom_navigation_drawer_screen.dart';
import 'package:internal_app_promoter/modules/promoter/commission/commission_list/model/promoter_commission_list_model.dart';
import 'package:internal_app_promoter/modules/promoter/commission/commission_list/view/promoter_commission_list_row.dart';
import 'package:internal_base/common/alert/app_alert.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/appbar_action_constants.dart';
import 'package:internal_base/common/appbars_constants.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/utils/app_calendar_utils.dart';
import 'package:internal_base/common/widget/no_data_found_widget.dart';
import 'package:internal_base/common/widget/pull_to_refresh_header_widget.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_commission_list/bloc/get_promoter_commission_list_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_commission_list/bloc/get_promoter_commission_list_state.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_commission_list/repo/get_promoter_commission_list_response.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PromoterCommissionListScreenWidget extends StatefulWidget {
  final CallbackModel mCallbackModel;

  const PromoterCommissionListScreenWidget(
      {super.key, required this.mCallbackModel});

  @override
  State<PromoterCommissionListScreenWidget> createState() =>
      _PromoterCommissionListScreenWidgetState();
}

class _PromoterCommissionListScreenWidgetState
    extends State<PromoterCommissionListScreenWidget> {
  late PromoterCommissionListScreenModel mPromoterCommissionListScreenModel;

  @override
  void initState() {
    mPromoterCommissionListScreenModel =
        PromoterCommissionListScreenModel(context, widget.mCallbackModel);
    mPromoterCommissionListScreenModel.setPromoterCommissionListBloc();
    mPromoterCommissionListScreenModel.setStartAndEndDate();
    mPromoterCommissionListScreenModel.getSharedPrefsSelectStore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            key: mPromoterCommissionListScreenModel.scaffoldKey,
            appBar: AppBars.appBar((value) async {
              if (value == "Menu") {
                mPromoterCommissionListScreenModel.scaffoldKey.currentState!
                    .openDrawer();
              } else {
                var values = await AppAlert.buildCalendarDialog(
                    context,
                    mPromoterCommissionListScreenModel
                        .dialogCalendarPickerValue,
                    getCalendarDatePicker2(context));
                mPromoterCommissionListScreenModel
                    .stringCheckCalendarPickerValue
                    .clear();
                mPromoterCommissionListScreenModel
                    .stringCheckCalendarPickerValue = values;
                if (mPromoterCommissionListScreenModel
                        .stringCheckCalendarPickerValue.length >1 && mPromoterCommissionListScreenModel
                    .stringCheckCalendarPickerValue[1]!="null") {
                  mPromoterCommissionListScreenModel.stringCalendarPickerValue
                      .clear();
                  mPromoterCommissionListScreenModel.stringCalendarPickerValue =
                      values;
                  if (mPromoterCommissionListScreenModel
                      .stringCalendarPickerValue.isNotEmpty) {
                    mPromoterCommissionListScreenModel.setDate();
                  }
                }
              }
            }, AppConstants.cWordConstants.wCommissionText,
                iconOne: AppBarActionConstants.actionFilter,
                sImageAssetsOne: ImageAssetsConstants.filter,
                sMenu: AppConstants.cWordConstants.wMenuText),
            drawer: CustomNavigationDrawer(
                mCallbackModel:
                    mPromoterCommissionListScreenModel.mCallbackModel),
            body: _buildSplashScreenWidgetView()));
  }

  _buildSplashScreenWidgetView() {
    return FocusDetector(
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
              BlocListener<GetPromoterCommissionListBloc,
                  GetPromoterCommissionListState>(
                bloc: mPromoterCommissionListScreenModel
                    .getPromoterCommissionListBloc(),
                listener: (context, state) {
                  mPromoterCommissionListScreenModel
                      .promoterCommissionListListener(context, state);
                },
              ),
            ])));
  }

  getListView() {
    return StreamBuilder<GetPromoterCommissionListResponse?>(
      stream: mPromoterCommissionListScreenModel.responseSubject,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          GetPromoterCommissionListResponse mGetPromoterCommissionListResponse =
              snapshot.data as GetPromoterCommissionListResponse;
          if (mGetPromoterCommissionListResponse.commissionHistory != null) {
            return setView(mGetPromoterCommissionListResponse.lastPage ?? 0,
                mGetPromoterCommissionListResponse.totalRecords ?? 0);
          }
        }
        return Container();
      },
    );
  }

  setView(int lastPage, int totalRecords) {
    return Column(
      children: [
        Expanded(
            child: SmartRefresher(
          controller: mPromoterCommissionListScreenModel.refreshController,
          onLoading: mPromoterCommissionListScreenModel.onLoading,
          onRefresh: mPromoterCommissionListScreenModel.onRefresh,

          /// load more
          enablePullUp: mPromoterCommissionListScreenModel.sPage < lastPage,

          /// pull to refresh
          enablePullDown: true,
          footer: CustomFooter(builder: (context, loadStatus) {
            return customFooter(loadStatus);
          }),
          header: waterDropHeader(),
          child: mPromoterCommissionListScreenModel
                  .commissionHistoryList.isNotEmpty
              ? ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: mPromoterCommissionListScreenModel
                      .commissionHistoryList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return PromoterCommissionListRowWidget(
                        index,
                        mPromoterCommissionListScreenModel,
                        mPromoterCommissionListScreenModel
                            .commissionHistoryList[index]);
                  })
              : Container(
                  height: SizeConstants.height * 0.75,
                  alignment: Alignment.center,
                  child: NoDataFoundWidget(
                    isLoadedAndEmpty: mPromoterCommissionListScreenModel
                        .commissionHistoryList.isEmpty,
                  )),
        ))
      ],
    );
  }
}
