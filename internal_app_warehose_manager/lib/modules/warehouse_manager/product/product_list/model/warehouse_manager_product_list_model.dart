import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internal_base/common/alert/app_alert.dart';
import 'package:internal_base/common/alert/filter_value.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/message_constants.dart';
import 'package:internal_base/common/utils/network_utils.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_products_list/bloc/warehouse_manager_products_list_bloc.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_products_list/bloc/warehouse_manager_products_list_event.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_products_list/bloc/warehouse_manager_products_list_state.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_products_list/repo/warehouse_manager_products_list_request.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_products_list/repo/warehouse_manager_products_list_response.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouses/repo/get_warehouses_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';

class WarehouseManagerProductListScreenModel {
  final BuildContext mBuildContext;
  final CallbackModel mCallbackModel;
  final scaffoldKey = GlobalKey<ScaffoldState>();


  WarehouseManagerProductListScreenModel(
      this.mBuildContext, this.mCallbackModel) {

    /// NavigationDrawerCallbackModel
    mCallbackModel.sMenuValue = AppConstants.cWordConstants.wProductListText;

  }
  Warehouses? mSelectStore;
  ///SharedPrefs
  getSharedPrefsSelectStore() async {
    await SharedPrefs().getSelectStore().then((sSelectStore) async {
      if (sSelectStore.toString() != "null" &&
          sSelectStore.toString().isNotEmpty) {
        mSelectStore = Warehouses.fromJson(jsonDecode(sSelectStore));
        onInitial();
      }

    });
  }

  List<Products> productsList = [];

  ///RefreshController
  int sPage = 1;
  int onRefreshView = 0;
  final RefreshController refreshController =
  RefreshController(initialRefresh: false);
  bool isLoadedAndEmpty = false;
  bool isSearchedAndEmpty = false;
  FilterValue mFilterValue = FilterValue("", "");

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

  /// GetWarehouseManagerProductsList Api
  late GetWarehouseManagerProductsListBloc _mGetWarehouseManagerProductsListBloc;

  setWarehouseManagerProductsListBloc() {
    _mGetWarehouseManagerProductsListBloc = GetWarehouseManagerProductsListBloc();
  }

  getWarehouseManagerProductsListBloc() {
    return _mGetWarehouseManagerProductsListBloc;
  }

  onInitial() async {
    onRefreshView = 0;
    sPage = 1;
    productsList.clear();
    initGetWarehouseManagerProductsList(GetWarehouseManagerProductsListEventStatus.initial);
  }

  onRefresh() async {
    onRefreshView = 1;
    sPage = 1;
    productsList.clear();
    initGetWarehouseManagerProductsList(GetWarehouseManagerProductsListEventStatus.refresh);
  }

  onLoading() async {
    onRefreshView = 2;
    sPage = sPage + 1;
    initGetWarehouseManagerProductsList(GetWarehouseManagerProductsListEventStatus.other);
  }

  Future<void> initGetWarehouseManagerProductsList(
      GetWarehouseManagerProductsListEventStatus eventStatus) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        GetWarehouseManagerProductsListRequest mGetWarehouseManagerProductsListRequest =
        GetWarehouseManagerProductsListRequest(
            page: sPage.toString(),
            perPage: "10",
            sortBy: "id",
            sortDirection: "desc",
            searchText: mFilterValue.text ?? "",
            stock: mFilterValue.sStock ?? "",
            warehouseId: mSelectStore!.id.toString()
        );
        _mGetWarehouseManagerProductsListBloc.add(GetWarehouseManagerProductsListClickEvent(
            eventStatus: eventStatus,
            mGetWarehouseManagerProductsListRequest:
            mGetWarehouseManagerProductsListRequest.toJson()));
      } else {
        AppAlert.showSnackBar(
            mBuildContext, MessageConstants.noInternetConnection);
      }
    });
  }

  warehouseManagerProductsListListener(
      BuildContext context, GetWarehouseManagerProductsListState state) {
    switch (state.status) {
      case GetWarehouseManagerProductsListStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case GetWarehouseManagerProductsListStatus.failed:
        loadEnd();
        if (state.webResponseFailed != null) {
          AppAlert.showSnackBar(
              context, state.webResponseFailed!.statusMessage ?? "");
        } else {
          AppAlert.showSnackBar(
              mBuildContext, AppConstants.cWordConstants.wSomethingWentWrong);
        }
        break;
      case GetWarehouseManagerProductsListStatus.success:
        productsList
            .addAll(state.mGetWarehouseManagerProductsListResponse!.products ?? []);
        setList(state.mGetWarehouseManagerProductsListResponse!);
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

  /// GetWarehouseManagerProductsListState

  var responseSubject = PublishSubject<GetWarehouseManagerProductsListResponse?>();

  Stream<GetWarehouseManagerProductsListResponse?> get responseStream =>
      responseSubject.stream;

  void closeObservable() {
    responseSubject.close();
  }

  void setList(GetWarehouseManagerProductsListResponse state) async {
    try {
      responseSubject.sink.add(state);
    } catch (e) {
      responseSubject.sink.addError(e);
    }
  }
}
