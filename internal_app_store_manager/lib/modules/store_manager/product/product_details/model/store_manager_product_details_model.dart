import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:internal_base/common/alert/app_alert.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/message_constants.dart';
import 'package:internal_base/common/utils/network_utils.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_products_details/bloc/store_manager_products_details_bloc.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_products_details/bloc/store_manager_products_details_event.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_products_details/bloc/store_manager_products_details_state.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_products_details/repo/store_manager_products_details_response.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_stores_list/repo/store_manager_stores_list_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:rxdart/rxdart.dart';

class StoreManagerProductDetailsScreenModel {
  final BuildContext cBuildContext;
  final CallbackModel mCallbackModel;

  StoreManagerProductDetailsScreenModel(
      this.cBuildContext, this.mCallbackModel) ;

  Stores? mSelectStore;

  ///SharedPrefs
  getSharedPrefsSelectStore() async {
    await SharedPrefs().getSelectStore().then((sSelectStore) async {
      if (sSelectStore.toString() != "null" &&
          sSelectStore.toString().isNotEmpty) {
        mSelectStore = Stores.fromJson(jsonDecode(sSelectStore));
      }
      fetchGetStoreManagerProductsDetailsUrl();
    });
  }

  ///GetStoreManagerProductsDetails

  late GetStoreManagerProductsDetailsBloc _mGetStoreManagerProductsDetailsBloc;

  setGetStoreManagerProductsDetailsBloc() {
    _mGetStoreManagerProductsDetailsBloc = GetStoreManagerProductsDetailsBloc();
  }

  getStoreManagerProductsDetailsBloc() {
    return _mGetStoreManagerProductsDetailsBloc;
  }

  ///refresh
  Future<void> refresh() async {
    fetchGetStoreManagerProductsDetailsUrl();
  }

  Future<void> fetchGetStoreManagerProductsDetailsUrl() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        // GetStoreManagerProductsDetailsRequest mGetStoreManagerProductsDetailsRequest =
        // GetStoreManagerProductsDetailsRequest(storeId: (mStores.id ?? 0).toString());
        String sStoreId = "${mCallbackModel.sValue}/${mSelectStore!.id??""}";
        _mGetStoreManagerProductsDetailsBloc.add( GetStoreManagerProductsDetailsClickEvent(
            mGetStoreManagerProductsDetailsRequest: sStoreId));
      } else {
        AppAlert.showSnackBar(
            cBuildContext, MessageConstants.noInternetConnection);
      }
    });
  }

  blocGetStoreManagerProductsDetailsListener(
      BuildContext context, GetStoreManagerProductsDetailsState state) {
    switch (state.status) {
      case GetStoreManagerProductsDetailsStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case GetStoreManagerProductsDetailsStatus.failed:
        AppAlert.closeDialog(context);
        AppAlert.showSnackBar(
            context, state.webResponseFailed?.statusMessage ?? "");
        break;
      case GetStoreManagerProductsDetailsStatus.success:
        AppAlert.closeDialog(context);
        setHomeDetails(state.mGetStoreManagerProductsDetailsResponse!);
        break;
    }
  }

  /// SetHomeDetails

  var responseSubject = PublishSubject<GetStoreManagerProductsDetailsResponse?>();

  Stream<GetStoreManagerProductsDetailsResponse?> get responseStream => responseSubject.stream;

  void closeObservable() {
    responseSubject.close();
  }

  void setHomeDetails(GetStoreManagerProductsDetailsResponse state) async {
    try {
      responseSubject.sink.add(state);
    } catch (e) {
      responseSubject.sink.addError(e);
    }
  }
}
