import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internal_base/common/alert/app_alert.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/message_constants.dart';
import 'package:internal_base/common/utils/network_utils.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_sales_list/bloc/store_manager_sales_list_bloc.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_sales_list/bloc/store_manager_sales_list_event.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_sales_list/bloc/store_manager_sales_list_state.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_sales_list/repo/store_manager_sales_list_request.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_sales_list/repo/store_manager_sales_list_response.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_stores_list/repo/store_manager_stores_list_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';

class StoreManagerSaleListScreenModel {
  final BuildContext mBuildContext;
  final CallbackModel mCallbackModel;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  StoreManagerSaleListScreenModel(
      this.mBuildContext, this.mCallbackModel) {
    mCallbackModel.sMenuValue =
        AppConstants.cWordConstants.wSalesText;
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

  getDate(){
    return DateFormat('MMM dd, yyyy').format(dialogCalendarPickerValue[0]!);
  }

  setDate() {
    String startDate = stringCalendarPickerValue[0].toString().trim();
    dialogCalendarPickerValue.clear();
    dialogCalendarPickerValue = [DateTime.parse(startDate),];
    onInitial();
  }


  List<SalesListData> storeStockList = [];

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

  /// GetStoreManagerSalesList Api
  late GetStoreManagerSalesListBloc _mGetStoreManagerSalesListBloc;

  setStoreManagerSalesListBloc() {
    _mGetStoreManagerSalesListBloc = GetStoreManagerSalesListBloc();
  }

  getStoreManagerSalesListBloc() {
    return _mGetStoreManagerSalesListBloc;
  }

  onInitial() async {
    onRefreshView = 0;
    sPage = 1;
    storeStockList.clear();
    initGetStoreManagerSalesList(GetStoreManagerSalesListEventStatus.initial);
  }

  onRefresh() async {
    onRefreshView = 1;
    sPage = 1;
    storeStockList.clear();
    initGetStoreManagerSalesList(GetStoreManagerSalesListEventStatus.refresh);
  }

  onLoading() async {
    onRefreshView = 2;
    sPage = sPage + 1;
    initGetStoreManagerSalesList(GetStoreManagerSalesListEventStatus.other);
  }

  Future<void> initGetStoreManagerSalesList(
      GetStoreManagerSalesListEventStatus eventStatus) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        GetStoreManagerSalesListRequest mGetStoreManagerSalesListRequest =
        GetStoreManagerSalesListRequest(
          page: sPage.toString(),
          perPage: "10",
          sortBy: "id",
          sortDirection: "desc",
          dateSelection: stringCalendarPickerValue[0],
          storeId: mSelectStore!.id.toString()
        );
        _mGetStoreManagerSalesListBloc.add(GetStoreManagerSalesListClickEvent(
            eventStatus: eventStatus,
            mGetStoreManagerSalesListRequest:
            mGetStoreManagerSalesListRequest.toJson(), mStringRequest: mCallbackModel.sValue));
      } else {
        AppAlert.showSnackBar(
            mBuildContext, MessageConstants.noInternetConnection);
      }
    });
  }

  storeManagerSalesListListener(
      BuildContext context, GetStoreManagerSalesListState state) {
    switch (state.status) {
      case GetStoreManagerSalesListStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case GetStoreManagerSalesListStatus.failed:
        loadEnd();
        if (state.webResponseFailed != null) {
          AppAlert.showSnackBar(
              context, state.webResponseFailed!.statusMessage ?? "");
        } else {
          AppAlert.showSnackBar(
              mBuildContext, AppConstants.cWordConstants.wSomethingWentWrong);
        }
        break;
      case GetStoreManagerSalesListStatus.success:
        storeStockList
            .addAll(state.mGetStoreManagerSalesListResponse!.data ?? []);
        setList(state.mGetStoreManagerSalesListResponse!);
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

  /// GetStoreManagerSalesListState

  var responseSubject = PublishSubject<GetStoreManagerSalesListResponse?>();

  Stream<GetStoreManagerSalesListResponse?> get responseStream =>
      responseSubject.stream;

  void closeObservable() {
    responseSubject.close();
  }

  void setList(GetStoreManagerSalesListResponse state) async {
    try {
      responseSubject.sink.add(state);
    } catch (e) {
      responseSubject.sink.addError(e);
    }
  }

}
