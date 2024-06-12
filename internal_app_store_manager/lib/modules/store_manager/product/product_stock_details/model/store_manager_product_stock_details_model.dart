import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internal_base/common/alert/app_alert.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/message_constants.dart';
import 'package:internal_base/common/utils/network_utils.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_products_stock_list/bloc/store_manager_products_stock_list_bloc.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_products_stock_list/bloc/store_manager_products_stock_list_event.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_products_stock_list/bloc/store_manager_products_stock_list_state.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_products_stock_list/repo/store_manager_products_stock_list_request.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_products_stock_list/repo/store_manager_products_stock_list_response.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';

class StoreManagerProductStockDetailsScreenModel {
  final BuildContext mBuildContext;
  final CallbackModel mCallbackModel;
 final TextEditingController mSearchTextEditingController = TextEditingController();
  StoreManagerProductStockDetailsScreenModel(
      this.mBuildContext, this.mCallbackModel) ;



  List<StoreStock> storeStockList = [];

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

  /// GetStoreManagerProductsStockList Api
  late GetStoreManagerProductsStockListBloc _mGetStoreManagerProductsStockListBloc;

  setStoreManagerProductsStockListBloc() {
    _mGetStoreManagerProductsStockListBloc = GetStoreManagerProductsStockListBloc();
  }

  getStoreManagerProductsStockListBloc() {
    return _mGetStoreManagerProductsStockListBloc;
  }

  onInitial() async {
    onRefreshView = 0;
    sPage = 1;
    storeStockList.clear();
    initGetStoreManagerProductsStockList(GetStoreManagerProductsStockListEventStatus.initial);
  }

  onRefresh() async {
    onRefreshView = 1;
    sPage = 1;
    storeStockList.clear();
    initGetStoreManagerProductsStockList(GetStoreManagerProductsStockListEventStatus.refresh);
  }

  onLoading() async {
    onRefreshView = 2;
    sPage = sPage + 1;
    initGetStoreManagerProductsStockList(GetStoreManagerProductsStockListEventStatus.other);
  }

  Future<void> initGetStoreManagerProductsStockList(
      GetStoreManagerProductsStockListEventStatus eventStatus) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        GetStoreManagerProductsStockListRequest mGetStoreManagerProductsStockListRequest =
        GetStoreManagerProductsStockListRequest(
          page: sPage.toString(),
          perPage: "10",
          sortBy: "id",
          sortDirection: "desc",
          searchText: mSearchTextEditingController.text,
        );
        _mGetStoreManagerProductsStockListBloc.add(GetStoreManagerProductsStockListClickEvent(
            eventStatus: eventStatus,
            mGetStoreManagerProductsStockListRequest:
            mGetStoreManagerProductsStockListRequest.toJson(), mStringRequest: mCallbackModel.sValue));
      } else {
        AppAlert.showSnackBar(
            mBuildContext, MessageConstants.noInternetConnection);
      }
    });
  }

  storeManagerProductsStockListListener(
      BuildContext context, GetStoreManagerProductsStockListState state) {
    switch (state.status) {
      case GetStoreManagerProductsStockListStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case GetStoreManagerProductsStockListStatus.failed:
        loadEnd();
        if (state.webResponseFailed != null) {
          AppAlert.showSnackBar(
              context, state.webResponseFailed!.statusMessage ?? "");
        } else {
          AppAlert.showSnackBar(
              mBuildContext, AppConstants.cWordConstants.wSomethingWentWrong);
        }
        break;
      case GetStoreManagerProductsStockListStatus.success:
        storeStockList
            .addAll(state.mGetStoreManagerProductsStockListResponse!.storeStock ?? []);
        setList(state.mGetStoreManagerProductsStockListResponse!);
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

  /// GetStoreManagerProductsStockListState

  var responseSubject = PublishSubject<GetStoreManagerProductsStockListResponse?>();

  Stream<GetStoreManagerProductsStockListResponse?> get responseStream =>
      responseSubject.stream;

  void closeObservable() {
    responseSubject.close();
  }

  void setList(GetStoreManagerProductsStockListResponse state) async {
    try {
      responseSubject.sink.add(state);
    } catch (e) {
      responseSubject.sink.addError(e);
    }
  }

}
