import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:internal_base/common/alert/app_alert.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/message_constants.dart';
import 'package:internal_base/common/utils/network_utils.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_products_details/bloc/get_promoter_products_details_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_products_details/bloc/get_promoter_products_details_event.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_products_details/bloc/get_promoter_products_details_state.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_products_details/repo/get_promoter_products_details_response.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_stores/repo/get_promoter_stores_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:rxdart/rxdart.dart';

class PromoterProductDetailsScreenModel {
  final BuildContext cBuildContext;
  final CallbackModel mCallbackModel;
  final SharedPrefs sharedPrefs = SharedPrefs();

  PromoterProductDetailsScreenModel(this.cBuildContext, this.mCallbackModel);

  Stores? mSelectStore;

  ///SharedPrefs
  getSharedPrefsSelectStore() async {
    await SharedPrefs().getSelectStore().then((sSelectStore) async {
      if (sSelectStore.toString() != "null" &&
          sSelectStore.toString().isNotEmpty) {
        mSelectStore = Stores.fromJson(jsonDecode(sSelectStore));
      }
      fetchGetPromoterProductsDetailsUrl();
    });
  }

  ///GetPromoterProductsDetails

  late GetPromoterProductsDetailsBloc _mGetPromoterProductsDetailsBloc;

  setGetPromoterProductsDetailsBloc() {
    _mGetPromoterProductsDetailsBloc = GetPromoterProductsDetailsBloc();
  }

  getPromoterProductsDetailsBloc() {
    return _mGetPromoterProductsDetailsBloc;
  }

  ///refresh
  Future<void> refresh() async {
    fetchGetPromoterProductsDetailsUrl();
  }

  Future<void> fetchGetPromoterProductsDetailsUrl() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        // GetPromoterProductsDetailsRequest mGetPromoterProductsDetailsRequest =
        // GetPromoterProductsDetailsRequest(storeId: (mStores.id ?? 0).toString());
        String sStoreId = "${mCallbackModel.sValue}/${mSelectStore!.id ?? ""}";
        _mGetPromoterProductsDetailsBloc.add(
            GetPromoterProductsDetailsClickEvent(
                mGetPromoterProductsDetailsRequest: sStoreId));
      } else {
        AppAlert.showSnackBar(
            cBuildContext, MessageConstants.noInternetConnection);
      }
    });
  }

  blocGetPromoterProductsDetailsListener(
      BuildContext context, GetPromoterProductsDetailsState state) {
    switch (state.status) {
      case GetPromoterProductsDetailsStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case GetPromoterProductsDetailsStatus.failed:
        AppAlert.closeDialog(context);
        AppAlert.showSnackBar(
            context, state.webResponseFailed?.statusMessage ?? "");
        break;
      case GetPromoterProductsDetailsStatus.success:
        AppAlert.closeDialog(context);
        setHomeDetails(state.mGetPromoterProductsDetailsResponse!);
        break;
    }
  }

  /// SetHomeDetails

  var responseSubject = PublishSubject<GetPromoterProductsDetailsResponse?>();

  Stream<GetPromoterProductsDetailsResponse?> get responseStream =>
      responseSubject.stream;

  void closeObservable() {
    responseSubject.close();
  }

  void setHomeDetails(GetPromoterProductsDetailsResponse state) async {
    try {
      responseSubject.sink.add(state);
    } catch (e) {
      responseSubject.sink.addError(e);
    }
  }
}
