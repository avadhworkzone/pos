import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internal_base/common/alert/app_alert.dart';
import 'package:internal_base/common/alert/filter_value.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/message_constants.dart';
import 'package:internal_base/common/utils/network_utils.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_products_list/bloc/get_promoter_products_list_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_products_list/bloc/get_promoter_products_list_event.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_products_list/bloc/get_promoter_products_list_state.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_products_list/repo/get_promoter_products_list_request.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_products_list/repo/get_promoter_products_list_response.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_stores/repo/get_promoter_stores_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';

class PromoterProductListScreenModel {
  final BuildContext mBuildContext;
  final CallbackModel mCallbackModel;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final SharedPrefs sharedPrefs = SharedPrefs();

  PromoterProductListScreenModel(this.mBuildContext, this.mCallbackModel) {
    mCallbackModel.sMenuValue = AppConstants.cWordConstants.wProductListText;
  }

  List<Products> productsList = [];
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

  /// GetPromoterProductsList Api
  late GetPromoterProductsListBloc _mGetPromoterProductsListBloc;

  setPromoterProductsListBloc() {
    _mGetPromoterProductsListBloc = GetPromoterProductsListBloc();
  }

  getPromoterProductsListBloc() {
    return _mGetPromoterProductsListBloc;
  }

  onInitial() async {
    onRefreshView = 0;
    sPage = 1;
    productsList.clear();
    initGetPromoterProductsList(GetPromoterProductsListEventStatus.initial);
  }

  onRefresh() async {
    onRefreshView = 1;
    sPage = 1;
    productsList.clear();
    initGetPromoterProductsList(GetPromoterProductsListEventStatus.refresh);
  }

  onLoading() async {
    onRefreshView = 2;
    sPage = sPage + 1;
    initGetPromoterProductsList(GetPromoterProductsListEventStatus.other);
  }

  Future<void> initGetPromoterProductsList(
      GetPromoterProductsListEventStatus eventStatus) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        GetPromoterProductsListRequest mGetPromoterProductsListRequest =
            GetPromoterProductsListRequest(
          page: sPage.toString(),
          perPage: "10",
          sortBy: "id",
          sortDirection: "desc",
          searchText: mFilterValue.text ?? "",
          stock: mFilterValue.sStock ?? "",
          storeId: "${mSelectStore?.id ?? ""}",
        );
        _mGetPromoterProductsListBloc.add(GetPromoterProductsListClickEvent(
            eventStatus: eventStatus,
            mGetPromoterProductsListRequest:
                mGetPromoterProductsListRequest.toJson()));
      } else {
        AppAlert.showSnackBar(
            mBuildContext, MessageConstants.noInternetConnection);
      }
    });
  }

  promoterProductsListListener(
      BuildContext context, GetPromoterProductsListState state) {
    switch (state.status) {
      case GetPromoterProductsListStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case GetPromoterProductsListStatus.failed:
        loadEnd();
        if (state.webResponseFailed != null) {
          AppAlert.showSnackBar(
              context, state.webResponseFailed!.statusMessage ?? "");
        } else {
          AppAlert.showSnackBar(
              mBuildContext, AppConstants.cWordConstants.wSomethingWentWrong);
        }
        break;
      case GetPromoterProductsListStatus.success:
        productsList
            .addAll(state.mGetPromoterProductsListResponse!.products ?? []);
        setList(state.mGetPromoterProductsListResponse!);
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

  /// GetPromoterProductsListState

  var responseSubject = PublishSubject<GetPromoterProductsListResponse?>();

  Stream<GetPromoterProductsListResponse?> get responseStream =>
      responseSubject.stream;

  void closeObservable() {
    responseSubject.close();
  }

  void setList(GetPromoterProductsListResponse state) async {
    try {
      responseSubject.sink.add(state);
    } catch (e) {
      responseSubject.sink.addError(e);
    }
  }
}
