import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internal_base/common/alert/app_alert.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/message_constants.dart';
import 'package:internal_base/common/utils/network_utils.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_commission_list/bloc/get_promoter_commission_list_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_commission_list/bloc/get_promoter_commission_list_event.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_commission_list/bloc/get_promoter_commission_list_state.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_commission_list/repo/get_promoter_commission_list_request.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_commission_list/repo/get_promoter_commission_list_response.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_stores/repo/get_promoter_stores_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';

class PromoterCommissionListScreenModel {
  final BuildContext mBuildContext;
  final CallbackModel mCallbackModel;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final SharedPrefs sharedPrefs = SharedPrefs();
  List<String?> stringCalendarPickerValue = [];
  List<String?> stringCheckCalendarPickerValue = [];
  List<DateTime?> dialogCalendarPickerValue = [];

  PromoterCommissionListScreenModel(this.mBuildContext, this.mCallbackModel) {
    mCallbackModel.sMenuValue = AppConstants.cWordConstants.wCommissionText;
  }

  Stores? mSelectStore;

  ///SharedPrefs
  getSharedPrefsSelectStore() async {
    await SharedPrefs().getSelectStore().then((sSelectStore) async {
      if (sSelectStore.toString() != "null" &&
          sSelectStore.toString().isNotEmpty) {
        mSelectStore = Stores.fromJson(jsonDecode(sSelectStore));
      }
    });
  }

  setStartAndEndDate() {
    DateTime now = DateTime.now();
    var startDay = DateTime(now.year, now.month - 1, 1);
    var lastDay = DateTime(now.year, now.month, 0);
    stringCalendarPickerValue.add(DateFormat('yyyy-MM-dd').format(startDay));
    stringCalendarPickerValue.add(DateFormat('yyyy-MM-dd').format(lastDay));
    setDate();
  }

  setDate() {
    String startDate = stringCalendarPickerValue[0].toString().trim();
    String endDate = stringCalendarPickerValue[1].toString().trim();
    dialogCalendarPickerValue.clear();
    dialogCalendarPickerValue = [
      DateTime.parse(startDate),
      DateTime.parse(endDate),
    ];
    onInitial();
  }

  List<CommissionHistory> commissionHistoryList = [];

  ///RefreshController
  int sPage = 1;
  int onRefreshView = 0;
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  bool isLoadedAndEmpty = false;
  bool isSearchedAndEmpty = false;

  Widget customFooter(LoadStatus? status) {
    Widget body;
    if (status == LoadStatus.idle) {
      body = Text(AppConstants.cWordConstants.wPullUpLoad);
    } else if (status == LoadStatus.loading) {
      body = const CupertinoActivityIndicator();
    } else if (status == LoadStatus.failed) {
      body = Text(AppConstants.cWordConstants.wLoadFailedClickRetry);
    } else if (status == LoadStatus.canLoading) {
      body = const CupertinoActivityIndicator();
    } else {
      body = Text(AppConstants.cWordConstants.wNoMoreData);
    }

    return SizedBox(
      height: 56.0,
      child: Center(
        child: body,
      ),
    );
  }

  final searchBarController = TextEditingController();

  /// GetPromoterCommissionList Api
  late GetPromoterCommissionListBloc _mGetPromoterCommissionListBloc;

  setPromoterCommissionListBloc() {
    _mGetPromoterCommissionListBloc = GetPromoterCommissionListBloc();
  }

  getPromoterCommissionListBloc() {
    return _mGetPromoterCommissionListBloc;
  }

  onInitial() async {
    onRefreshView = 0;
    sPage = 1;
    commissionHistoryList.clear();
    initGetPromoterCommissionList(GetPromoterCommissionListEventStatus.initial);
  }

  onRefresh() async {
    onRefreshView = 1;
    sPage = 1;
    commissionHistoryList.clear();
    initGetPromoterCommissionList(GetPromoterCommissionListEventStatus.refresh);
  }

  onLoading() async {
    onRefreshView = 2;
    sPage = sPage + 1;
    initGetPromoterCommissionList(GetPromoterCommissionListEventStatus.other);
  }

  Future<void> initGetPromoterCommissionList(
      GetPromoterCommissionListEventStatus eventStatus) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        GetPromoterCommissionListRequest mGetPromoterCommissionListRequest =
            GetPromoterCommissionListRequest(
                page: sPage.toString(),
                perPage: "10",
                sortBy: "id",
                sortDirection: "desc",
                storeId: "${mSelectStore?.id}",
                startDate: stringCalendarPickerValue[0].toString().trim(),
                endDate: stringCalendarPickerValue[1].toString().trim());
        _mGetPromoterCommissionListBloc.add(GetPromoterCommissionListClickEvent(
            eventStatus: eventStatus,
            mGetPromoterCommissionListRequest:
                mGetPromoterCommissionListRequest.toJson()));
      } else {
        AppAlert.showSnackBar(
            mBuildContext, MessageConstants.noInternetConnection);
      }
    });
  }

  promoterCommissionListListener(
      BuildContext context, GetPromoterCommissionListState state) {
    switch (state.status) {
      case GetPromoterCommissionListStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case GetPromoterCommissionListStatus.failed:
        loadEnd();
        if (state.webResponseFailed != null) {
          AppAlert.showSnackBar(
              context, state.webResponseFailed!.statusMessage ?? "");
        } else {
          AppAlert.showSnackBar(
              mBuildContext, AppConstants.cWordConstants.wSomethingWentWrong);
        }
        break;
      case GetPromoterCommissionListStatus.success:
        commissionHistoryList.addAll(
            state.mGetPromoterCommissionListResponse!.commissionHistory ?? []);
        setList(state.mGetPromoterCommissionListResponse!);
        loadEnd();
        break;
    }
  }

  void loadEnd() {
    if (onRefreshView == 0) {
      AppAlert.closeDialog(mBuildContext);
    } else if (onRefreshView == 1) {
      refreshController.refreshCompleted();
    } else if (onRefreshView == 2) {
      refreshController.loadComplete();
    }
  }

  /// GetPromoterCommissionListState

  var responseSubject = PublishSubject<GetPromoterCommissionListResponse?>();

  Stream<GetPromoterCommissionListResponse?> get responseStream =>
      responseSubject.stream;

  void closeObservable() {
    responseSubject.close();
  }

  void setList(GetPromoterCommissionListResponse state) async {
    try {
      responseSubject.sink.add(state);
    } catch (e) {
      responseSubject.sink.addError(e);
    }
  }
}
