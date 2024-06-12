import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internal_base/common/alert/app_alert.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/message_constants.dart';
import 'package:internal_base/common/utils/network_utils.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_sales_returns_list/bloc/get_promoter_sales_returns_list_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_sales_returns_list/bloc/get_promoter_sales_returns_list_event.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_sales_returns_list/bloc/get_promoter_sales_returns_list_state.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_sales_returns_list/repo/GetPromoterSalesReturnsListResponse.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_sales_returns_list/repo/get_promoter_sales_returns_list_request.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_stores/repo/get_promoter_stores_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';

class PromoterSalesReturnsListScreenModel {
  final BuildContext mBuildContext;
  final CallbackModel mCallbackModel;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final SharedPrefs sharedPrefs = SharedPrefs();

  PromoterSalesReturnsListScreenModel(this.mBuildContext, this.mCallbackModel) {
    mCallbackModel.sMenuValue = AppConstants.cWordConstants.wSalesReturnsText;
  }

  Stores? mSelectStore;

  ///SharedPrefs
  getSharedPrefsSelectStore() async {
    await SharedPrefs().getSelectStore().then((sSelectStore) async {
      if (sSelectStore.toString() != "null" &&
          sSelectStore.toString().isNotEmpty) {
        mSelectStore = Stores.fromJson(jsonDecode(sSelectStore));
        setStartAndEndDate();
      }
    });
  }

  ///date
  List<DateTime?> dialogCalendarPickerValue = [];
  List<String?> stringCalendarPickerValue = [];

  setStartAndEndDate() {
    DateTime now = DateTime.now();
    stringCalendarPickerValue.add(DateFormat('yyyy-MM-dd').format(now));
    setDate();
  }

  getDate() {
    return DateFormat('MMM dd, yyyy').format(dialogCalendarPickerValue[0]!);
  }

  setDate() {
    String startDate = stringCalendarPickerValue[0].toString().trim();
    dialogCalendarPickerValue.clear();
    dialogCalendarPickerValue = [
      DateTime.parse(startDate),
    ];
    onInitial();
  }

  List<Sales> salesReturnsList = [];
  Summary? salesSummary;

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

  /// GetPromoterSalesReturnsList Api
  late GetPromoterSalesReturnsListBloc _mGetPromoterSalesReturnsListBloc;

  setPromoterCommissionListBloc() {
    _mGetPromoterSalesReturnsListBloc = GetPromoterSalesReturnsListBloc();
  }

  getPromoterSalesReturnsListBloc() {
    return _mGetPromoterSalesReturnsListBloc;
  }

  onInitial() async {
    onRefreshView = 0;
    salesSummary = null;
    sPage = 1;
    salesReturnsList.clear();
    initGetPromoterSalesReturnsList(
        GetPromoterSalesReturnsListEventStatus.initial);
  }

  onRefresh() async {
    onRefreshView = 1;
    sPage = 1;
    salesReturnsList.clear();
    initGetPromoterSalesReturnsList(
        GetPromoterSalesReturnsListEventStatus.refresh);
  }

  onLoading() async {
    onRefreshView = 2;
    sPage = sPage + 1;
    initGetPromoterSalesReturnsList(
        GetPromoterSalesReturnsListEventStatus.other);
  }

  Future<void> initGetPromoterSalesReturnsList(
      GetPromoterSalesReturnsListEventStatus eventStatus) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        GetPromoterSalesReturnsListRequest mGetPromoterSalesReturnsListRequest =
            GetPromoterSalesReturnsListRequest(
                page: sPage.toString(),
                perPage: "10",
                sortBy: "id",
                sortDirection: "desc",
                storeId: "${mSelectStore?.id ?? ""}",
                selectedDate: (stringCalendarPickerValue.isNotEmpty)
                    ? stringCalendarPickerValue[0]
                    : "");
        _mGetPromoterSalesReturnsListBloc.add(
            GetPromoterSalesReturnsListClickEvent(
                eventStatus: eventStatus,
                mGetPromoterSalesReturnsListRequest:
                    mGetPromoterSalesReturnsListRequest.toJson()));
      } else {
        AppAlert.showSnackBar(
            mBuildContext, MessageConstants.noInternetConnection);
      }
    });
  }

  promoterCommissionListListener(
      BuildContext context, GetPromoterSalesReturnsListState state) {
    switch (state.status) {
      case GetPromoterSalesReturnsListStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case GetPromoterSalesReturnsListStatus.failed:
        loadEnd();
        if (state.webResponseFailed != null) {
          AppAlert.showSnackBar(
              context, state.webResponseFailed!.statusMessage ?? "");
        } else {
          AppAlert.showSnackBar(
              mBuildContext, AppConstants.cWordConstants.wSomethingWentWrong);
        }
        break;
      case GetPromoterSalesReturnsListStatus.success:
        salesReturnsList.addAll(
            state.mGetPromoterSalesReturnsListResponse!.sales ??
                []);
        setList(state.mGetPromoterSalesReturnsListResponse!);
        salesSummary = state.mGetPromoterSalesReturnsListResponse!.summary;
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

  /// GetPromoterSalesReturnsListState

  var responseSubject = PublishSubject<GetPromoterSalesReturnsListResponse?>();

  Stream<GetPromoterSalesReturnsListResponse?> get responseStream =>
      responseSubject.stream;

  void closeObservable() {
    responseSubject.close();
  }

  void setList(GetPromoterSalesReturnsListResponse state) async {
    try {
      responseSubject.sink.add(state);
    } catch (e) {
      responseSubject.sink.addError(e);
    }
  }
}
