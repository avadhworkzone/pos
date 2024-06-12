import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:internal_base/common/alert/app_alert.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/message_constants.dart';
import 'package:internal_base/common/utils/network_utils.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_commission_details/bloc/get_promoter_products_details_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_commission_details/bloc/get_promoter_products_details_event.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_commission_details/bloc/get_promoter_products_details_state.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_commission_details/repo/get_promoter_commission_details_response.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_stores/repo/get_promoter_stores_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:rxdart/rxdart.dart';

class PromoterSalesReturnsDetailsScreenModel {
  final BuildContext cBuildContext;
  final CallbackModel mCallbackModel;
  final SharedPrefs sharedPrefs = SharedPrefs();

  PromoterSalesReturnsDetailsScreenModel(
      this.cBuildContext, this.mCallbackModel);

  Stores? mSelectStore;

  ///SharedPrefs
  getSharedPrefsSelectStore() async {
    await SharedPrefs().getSelectStore().then((sSelectStore) async {
      if (sSelectStore.toString() != "null" &&
          sSelectStore.toString().isNotEmpty) {
        mSelectStore = Stores.fromJson(jsonDecode(sSelectStore));
      }
      fetchGetPromoterCommissionDetailsUrl();
    });
  }

  ///GetPromoterCommissionDetails

  late GetPromoterCommissionDetailsBloc _mGetPromoterCommissionDetailsBloc;

  setGetPromoterCommissionDetailsBloc() {
    _mGetPromoterCommissionDetailsBloc = GetPromoterCommissionDetailsBloc();
  }

  getPromoterCommissionDetailsBloc() {
    return _mGetPromoterCommissionDetailsBloc;
  }

  ///refresh
  Future<void> refresh() async {
    fetchGetPromoterCommissionDetailsUrl();
  }

  Future<void> fetchGetPromoterCommissionDetailsUrl() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        String commissionId = "${mCallbackModel.sValue}/${mCallbackModel.sMenuValue}";
        _mGetPromoterCommissionDetailsBloc.add(
            GetPromoterCommissionDetailsClickEvent(
                mGetPromoterCommissionDetailsRequest: commissionId));
      } else {
        AppAlert.showSnackBar(
            cBuildContext, MessageConstants.noInternetConnection);
      }
    });
  }

  blocGetPromoterCommissionDetailsListener(
      BuildContext context, GetPromoterCommissionDetailsState state) {
    switch (state.status) {
      case GetPromoterCommissionDetailsStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case GetPromoterCommissionDetailsStatus.failed:
        AppAlert.closeDialog(context);
        AppAlert.showSnackBar(
            context, state.webResponseFailed?.statusMessage ?? "");
        break;
      case GetPromoterCommissionDetailsStatus.success:
        AppAlert.closeDialog(context);
        setHomeDetails(state.mGetPromoterCommissionDetailsResponse!);
        break;
    }
  }

  /// SetHomeDetails

  var responseSubject = PublishSubject<GetPromoterCommissionDetailsResponse?>();

  Stream<GetPromoterCommissionDetailsResponse?> get responseStream =>
      responseSubject.stream;

  void closeObservable() {
    responseSubject.close();
  }

  void setHomeDetails(GetPromoterCommissionDetailsResponse state) async {
    try {
      responseSubject.sink.add(state);
    } catch (e) {
      responseSubject.sink.addError(e);
    }
  }
}
