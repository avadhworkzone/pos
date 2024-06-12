import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:internal_base/common/alert/app_alert.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/message_constants.dart';
import 'package:internal_base/common/utils/network_utils.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_products_details/bloc/warehouse_manager_products_details_bloc.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_products_details/bloc/warehouse_manager_products_details_event.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_products_details/bloc/warehouse_manager_products_details_state.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_products_details/repo/warehouse_manager_products_details_response.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouses/repo/get_warehouses_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:rxdart/rxdart.dart';

class WarehouseManagerProductDetailsScreenModel {
  final BuildContext cBuildContext;
  final CallbackModel mCallbackModel;

  WarehouseManagerProductDetailsScreenModel(
      this.cBuildContext, this.mCallbackModel) ;

  Warehouses? mSelectStore;

  ///SharedPrefs
  getSharedPrefsSelectStore() async {
    await SharedPrefs().getSelectStore().then((sSelectStore) async {
      if (sSelectStore.toString() != "null" &&
          sSelectStore.toString().isNotEmpty) {
        mSelectStore = Warehouses.fromJson(jsonDecode(sSelectStore));
      }
      fetchGetWarehouseManagerProductsDetailsUrl();
    });
  }

  ///GetWarehouseManagerProductsDetails

  late GetWarehouseManagerProductsDetailsBloc _mGetWarehouseManagerProductsDetailsBloc;

  setGetWarehouseManagerProductsDetailsBloc() {
    _mGetWarehouseManagerProductsDetailsBloc = GetWarehouseManagerProductsDetailsBloc();
  }

  getWarehouseManagerProductsDetailsBloc() {
    return _mGetWarehouseManagerProductsDetailsBloc;
  }

  ///refresh
  Future<void> refresh() async {
    fetchGetWarehouseManagerProductsDetailsUrl();
  }

  Future<void> fetchGetWarehouseManagerProductsDetailsUrl() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        String sStoreId = "${mCallbackModel.sValue}/${mSelectStore!.id??""}";
        _mGetWarehouseManagerProductsDetailsBloc.add( GetWarehouseManagerProductsDetailsClickEvent(
            mGetWarehouseManagerProductsDetailsRequest: sStoreId));
      } else {
        AppAlert.showSnackBar(
            cBuildContext, MessageConstants.noInternetConnection);
      }
    });
  }

  blocGetWarehouseManagerProductsDetailsListener(
      BuildContext context, GetWarehouseManagerProductsDetailsState state) {
    switch (state.status) {
      case GetWarehouseManagerProductsDetailsStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case GetWarehouseManagerProductsDetailsStatus.failed:
        AppAlert.closeDialog(context);
        AppAlert.showSnackBar(
            context, state.webResponseFailed?.statusMessage ?? "");
        break;
      case GetWarehouseManagerProductsDetailsStatus.success:
        AppAlert.closeDialog(context);
        setHomeDetails(state.mGetWarehouseManagerProductsDetailsResponse!);
        break;
    }
  }

  /// SetHomeDetails

  var responseSubject = PublishSubject<GetWarehouseManagerProductsDetailsResponse?>();

  Stream<GetWarehouseManagerProductsDetailsResponse?> get responseStream => responseSubject.stream;

  void closeObservable() {
    responseSubject.close();
  }

  void setHomeDetails(GetWarehouseManagerProductsDetailsResponse state) async {
    try {
      responseSubject.sink.add(state);
    } catch (e) {
      responseSubject.sink.addError(e);
    }
  }
}
