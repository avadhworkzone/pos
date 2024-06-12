import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internal_base/common/alert/app_alert.dart';
import 'package:internal_base/common/alert/filter_value.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_promoter_list/bloc/store_manager_promoter_list_bloc.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_promoter_list/bloc/store_manager_promoter_list_event.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_promoter_list/bloc/store_manager_promoter_list_state.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_promoter_list/repo/store_manager_promoter_list_response.dart';
import 'package:internal_base/common/message_constants.dart';
import 'package:internal_base/common/utils/network_utils.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_stores_list/repo/store_manager_stores_list_response.dart'
    as store;
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_promoter_list/repo/store_manager_promoter_list_request.dart';

class StoreManagerPromoterListScreenModel {
  final BuildContext mBuildContext;
  final CallbackModel mCallbackModel;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  StoreManagerPromoterListScreenModel(this.mBuildContext, this.mCallbackModel) {
    mCallbackModel.sMenuValue = AppConstants.cWordConstants.wPromotersText;
  }

  store.Stores? mSelectStore;

  ///SharedPrefs
  getSharedPrefsSelectStore() async {
    await SharedPrefs().getSelectStore().then((sSelectStore) async {
      if (sSelectStore.toString() != "null" &&
          sSelectStore.toString().isNotEmpty) {
        mSelectStore = store.Stores.fromJson(jsonDecode(sSelectStore));
        onInitial();
      }
    });
  }

  List<Promoters> promoterList = [];

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

  /// GetStoreManagerPromoterList Api
  late GetStoreManagerPromoterListBloc _mGetStoreManagerPromoterListBloc;

  setStoreManagerPromoterListBloc() {
    _mGetStoreManagerPromoterListBloc = GetStoreManagerPromoterListBloc();
  }

  getStoreManagerProductsListBloc() {
    return _mGetStoreManagerPromoterListBloc;
  }

  onInitial() async {
    onRefreshView = 0;
    sPage = 1;
    promoterList.clear();
    initGetStoreManagerPromotersList(
        GetStoreManagerPromoterListEventStatus.initial);
  }

  onRefresh() async {
    onRefreshView = 1;
    sPage = 1;
    promoterList.clear();
    initGetStoreManagerPromotersList(
        GetStoreManagerPromoterListEventStatus.refresh);
  }

  onLoading() async {
    onRefreshView = 2;
    sPage = sPage + 1;
    initGetStoreManagerPromotersList(
        GetStoreManagerPromoterListEventStatus.other);
  }

  Future<void> initGetStoreManagerPromotersList(
      GetStoreManagerPromoterListEventStatus eventStatus) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        GetStoreManagerPromoterListRequest mGetStoreManagerPromoterListRequest =
            GetStoreManagerPromoterListRequest(
          storeId: mSelectStore!.id.toString(),
        );
        _mGetStoreManagerPromoterListBloc.add(
            GetStoreManagerPromoterListClickEvent(
                eventStatus: eventStatus,
                mGetStoreManagerPromoterListRequest:
                    mGetStoreManagerPromoterListRequest.toJson()));
      } else {
        AppAlert.showSnackBar(
            mBuildContext, MessageConstants.noInternetConnection);
      }
    });
  }

  storeManagerPromotersListListener(
      BuildContext context, GetStoreManagerPromoterListState state) {
    switch (state.status) {
      case GetStoreManagerPromoterListStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case GetStoreManagerPromoterListStatus.failed:
        loadEnd();
        if (state.webResponseFailed != null) {
          AppAlert.showSnackBar(
              context, state.webResponseFailed!.statusMessage ?? "");
        } else {
          AppAlert.showSnackBar(
              mBuildContext, AppConstants.cWordConstants.wSomethingWentWrong);
        }
        break;
      case GetStoreManagerPromoterListStatus.success:
        print(
            'promoter list ${state.mGetStoreManagerPromoterListResponse!.promoters}');
        promoterList.addAll(
            state.mGetStoreManagerPromoterListResponse!.promoters ?? []);
        setList(state.mGetStoreManagerPromoterListResponse!);
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

  /// GetStoreManagerProductsListState

  var responseSubject = PublishSubject<GetStoreManagerPromoterListResponse?>();

  Stream<GetStoreManagerPromoterListResponse?> get responseStream =>
      responseSubject.stream;

  void closeObservable() {
    responseSubject.close();
  }

  void setList(GetStoreManagerPromoterListResponse state) async {
    try {
      responseSubject.sink.add(state);
    } catch (e) {
      responseSubject.sink.addError(e);
    }
  }
}
