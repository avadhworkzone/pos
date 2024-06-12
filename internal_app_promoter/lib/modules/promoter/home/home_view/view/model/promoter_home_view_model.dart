import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:internal_app_promoter/constants/image_assets_constants.dart';
import 'package:internal_base/common/alert/app_alert.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/message_constants.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/text_styles_constants.dart';
import 'package:internal_base/common/utils/network_utils.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_home/bloc/get_promoter_home_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_home/bloc/get_promoter_home_event.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_home/bloc/get_promoter_home_state.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_home/repo/get_promoter_home_request.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_home/repo/get_promoter_home_response.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_profile_details/bloc/get_promoter_profile_details_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_profile_details/bloc/get_promoter_profile_details_event.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_profile_details/bloc/get_promoter_profile_details_state.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_profile_details/repo/get_promoter_profile_details_response.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_stores/bloc/get_promoter_stores_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_stores/bloc/get_promoter_stores_event.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_stores/bloc/get_promoter_stores_state.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_stores/repo/get_promoter_stores_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:rxdart/rxdart.dart';

class PromoterHomeViewScreenModel {
  final BuildContext cBuildContext;
  final CallbackModel mCallbackModel;
  late CallbackModel mPromoterHomeViewScreenModelCallbackModel;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final SharedPrefs sharedPrefs = SharedPrefs();

  PromoterHomeViewScreenModel(this.cBuildContext, this.mCallbackModel) {
    mPromoterHomeViewScreenModelCallbackModel = CallbackModel();
    mPromoterHomeViewScreenModelCallbackModel.returnValueChanged = (value) {};

    /// NavigationDrawerCallbackModel
    mCallbackModel.sMenuValue = AppConstants.cWordConstants.wHomeText;
  }

  Stores? mSelectStore;

  ///SharedPrefs
  getSharedPrefsSelectStore() async {
    await SharedPrefs().getSelectStore().then((sSelectStore) async {
      if (sSelectStore.toString() != "null" &&
          sSelectStore.toString().isNotEmpty) {
        mSelectStore = Stores.fromJson(jsonDecode(sSelectStore));
      }
      fetchGetPromoterStoresUrl();
    });
  }

  setSharedPrefsSelectStore(Stores state) async {
    await sharedPrefs.setSelectStore(jsonEncode(state));
  }

  ///
  List<Stores> value = [];

  List<DropdownMenuItem<Stores>> createList() {
    return value
        .map((item) => DropdownMenuItem<Stores>(
              value: item,
              child: Row(
                children: [
                  Image(
                      height: SizeConstants.s1 * 25,
                      width: SizeConstants.s1 * 25,
                      image: AssetImage(ImageAssetsConstants.homeStore)),
                  SizedBox(
                    width: SizeConstants.s1 * 15,
                  ),
                  SizedBox(
                    width: SizeConstants.width * 0.55,
                    child: Text(
                      item.name ?? "",
                      style: getTextMedium(
                          size: SizeConstants.s1 * 16, colors: Colors.black),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ))
        .toList();
  }

  ///GetPromoterStores
  late GetPromoterStoresBloc _mGetPromoterStoresBloc;

  setGetPromoterStoresBloc() {
    _mGetPromoterStoresBloc = GetPromoterStoresBloc();
  }

  getGetPromoterStoresBloc() {
    return _mGetPromoterStoresBloc;
  }

  Future<void> fetchGetPromoterStoresUrl() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _mGetPromoterStoresBloc.add(const GetPromoterStoresClickEvent());
      } else {
        AppAlert.showSnackBar(
            cBuildContext, MessageConstants.noInternetConnection);
      }
    });
  }

  blocGetPromoterStoresListener(
      BuildContext context, GetPromoterStoresState state) {
    switch (state.status) {
      case GetPromoterStoresStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case GetPromoterStoresStatus.failed:
        AppAlert.closeDialog(context);
        AppAlert.showSnackBar(
            context, state.webResponseFailed?.statusMessage ?? "");
        break;
      case GetPromoterStoresStatus.success:
        AppAlert.closeDialog(context);
        GetPromoterStoresState mGetPromoterStoresState = state;
        if (mGetPromoterStoresState.mGetPromoterStoresResponse != null &&
            mGetPromoterStoresState
                .mGetPromoterStoresResponse!.stores!.isNotEmpty) {
          value.clear();
          value.addAll(
              mGetPromoterStoresState.mGetPromoterStoresResponse!.stores!);
          if (mSelectStore == null) {
            mSelectStore = value.first;
          } else {
            mSelectStore =
                value.singleWhere((element) => element.id == mSelectStore!.id);
          }
          setSelectStore(mSelectStore!);
          fetchGetPromoterHomeUrl(mSelectStore!);
        }
        break;
    }
  }

  /// SelectStore
  var responseSubjectSelectStore = PublishSubject<Stores?>();

  Stream<Stores?> get responseStreamSelectStore =>
      responseSubjectSelectStore.stream;

  void closeObservableSelectStore() {
    responseSubjectSelectStore.close();
  }

  void setSelectStore(Stores state) async {
    try {
      setSharedPrefsSelectStore(mSelectStore!);
      responseSubjectSelectStore.sink.add(state);
    } catch (e) {
      responseSubjectSelectStore.sink.addError(e);
    }
  }

  ///GetPromoterHome

  late GetPromoterHomeBloc _mGetPromoterHomeBloc;

  setGetPromoterHomeBloc() {
    _mGetPromoterHomeBloc = GetPromoterHomeBloc();
  }

  getGetPromoterHomeBloc() {
    return _mGetPromoterHomeBloc;
  }

  ///refresh
  Future<void> refresh() async {
    fetchGetPromoterHomeUrl(mSelectStore!);
  }

  Future<void> fetchGetPromoterHomeUrl(Stores mStores) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        GetPromoterHomeRequest mGetPromoterHomeRequest =
            GetPromoterHomeRequest(storeId: (mStores.id ?? 0).toString());
        _mGetPromoterHomeBloc.add(GetPromoterHomeClickEvent(
            mGetPromoterHomeRequest: mGetPromoterHomeRequest.toJson()));
      } else {
        AppAlert.showSnackBar(
            cBuildContext, MessageConstants.noInternetConnection);
      }
    });
  }

  blocGetPromoterHomeListener(
      BuildContext context, GetPromoterHomeState state) {
    switch (state.status) {
      case GetPromoterHomeStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case GetPromoterHomeStatus.failed:
        AppAlert.closeDialog(context);
        AppAlert.showSnackBar(
            context, state.webResponseFailed?.statusMessage ?? "");
        break;
      case GetPromoterHomeStatus.success:
        AppAlert.closeDialog(context);

        setHomeDetails(state.mGetPromoterHomeResponse!);
        break;
    }
  }

  /// SetHomeDetails

  var responseSubject = PublishSubject<GetPromoterHomeResponse?>();

  Stream<GetPromoterHomeResponse?> get responseStream => responseSubject.stream;

  void closeObservable() {
    responseSubject.close();
  }

  void setHomeDetails(GetPromoterHomeResponse state) async {
    try {
      responseSubject.sink.add(state);
    } catch (e) {
      responseSubject.sink.addError(e);
    }
  }

  ///GetPromoteProfileDetails

  late GetPromoteProfileDetailsBloc _mGetPromoteProfileDetailsBloc;

  setPromoteProfileDetailsBloc() {
    _mGetPromoteProfileDetailsBloc = GetPromoteProfileDetailsBloc();
  }

  getPromoteProfileDetailsBloc() {
    return _mGetPromoteProfileDetailsBloc;
  }

  Future<void> fetchGetPromoteProfileDetailsUrl() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _mGetPromoteProfileDetailsBloc.add(
            const GetPromoteProfileDetailsClickEvent(
                mGetPromoteProfileDetailsRequest: ""));
      } else {
        AppAlert.showSnackBar(
            cBuildContext, MessageConstants.noInternetConnection);
      }
    });
  }

  blocGetPromoteProfileDetailsListener(
      BuildContext context, GetPromoteProfileDetailsState state) {
    switch (state.status) {
      case GetPromoteProfileDetailsStatus.loading:
        break;
      case GetPromoteProfileDetailsStatus.failed:
        getSharedPrefsSelectStore();
        break;
      case GetPromoteProfileDetailsStatus.success:
        getSharedPrefsSelectStore();
        setProfileDetails(state.mGetPromoteProfileDetailsResponse!);
        break;
    }
  }

  /// SetProfileDetails

  var responseSubjectProfileDetails =
      PublishSubject<GetPromoteProfileDetailsResponse?>();

  Stream<GetPromoteProfileDetailsResponse?> get responseStreamProfileDetails =>
      responseSubjectProfileDetails.stream;

  void closeObservableProfileDetails() {
    responseSubjectProfileDetails.close();
  }

  void setProfileDetails(GetPromoteProfileDetailsResponse state) async {
    try {
      responseSubjectProfileDetails.sink.add(state);
    } catch (e) {
      responseSubjectProfileDetails.sink.addError(e);
    }
  }
}
