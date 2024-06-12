import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:internal_app_store_manager/constants/image_assets_constants.dart';
import 'package:internal_base/common/alert/app_alert.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/message_constants.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/text_styles_constants.dart';
import 'package:internal_base/common/utils/network_utils.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_home/bloc/store_manager_home_bloc.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_home/bloc/store_manager_home_event.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_home/bloc/store_manager_home_state.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_home/repo/store_manager_home_request.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_home/repo/store_manager_home_response.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_profile_details/bloc/store_manager_profile_details_bloc.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_profile_details/bloc/store_manager_profile_details_event.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_profile_details/bloc/store_manager_profile_details_state.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_profile_details/repo/store_manager_profile_details_response.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_stores_list/bloc/store_manager_stores_list_bloc.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_stores_list/bloc/store_manager_stores_list_event.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_stores_list/bloc/store_manager_stores_list_state.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_stores_list/repo/store_manager_stores_list_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:rxdart/rxdart.dart';

class StoreManagerHomeViewScreenModel {
  final BuildContext cBuildContext;
  final CallbackModel mCallbackModel;
  late CallbackModel mStoreManagerHomeViewScreenModelCallbackModel;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final SharedPrefs sharedPrefs = SharedPrefs();

  StoreManagerHomeViewScreenModel(
      this.cBuildContext, this.mCallbackModel) {
    mStoreManagerHomeViewScreenModelCallbackModel = CallbackModel();
    mStoreManagerHomeViewScreenModelCallbackModel.returnValueChanged = (value){};

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
      fetchGetStoreManagerStoresUrl();
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

  ///GetStoreManagerStores
  late GetStoreManagerStoresListBloc _mGetStoreManagerStoresListBloc;

  setGetStoreManagerStoresListBloc() {
    _mGetStoreManagerStoresListBloc = GetStoreManagerStoresListBloc();
  }

  getGetStoreManagerStoresListBloc() {
    return _mGetStoreManagerStoresListBloc;
  }

  Future<void> fetchGetStoreManagerStoresUrl() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _mGetStoreManagerStoresListBloc.add(const GetStoreManagerStoresListClickEvent());
      } else {
        AppAlert.showSnackBar(
            cBuildContext, MessageConstants.noInternetConnection);
      }
    });
  }

  blocGetStoreManagerStoresListener(
      BuildContext context, GetStoreManagerStoresListState state) {
    switch (state.status) {
      case GetStoreManagerStoresListStatus.loading:
          AppAlert.showProgressDialog(context);
        break;
      case GetStoreManagerStoresListStatus.failed:
        AppAlert.closeDialog(context);
        AppAlert.showSnackBar(
            context, state.webResponseFailed?.statusMessage ?? "");
        break;
      case GetStoreManagerStoresListStatus.success:
        AppAlert.closeDialog(context);
        GetStoreManagerStoresListState mGetStoreManagerStoresListState = state;
        if (mGetStoreManagerStoresListState.mGetStoreManagerStoresListResponse != null &&
            mGetStoreManagerStoresListState
                .mGetStoreManagerStoresListResponse!.stores!.isNotEmpty) {
          value.clear();
          value.addAll(
              mGetStoreManagerStoresListState.mGetStoreManagerStoresListResponse!.stores!);
          if (mSelectStore == null) {
            mSelectStore = value.first;
          } else {
            mSelectStore =
                value.singleWhere((element) => element.id == mSelectStore!.id);
          }
          setSelectStore(mSelectStore!);
          fetchGetStoreManagerHomeUrl(mSelectStore!);
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

  ///GetStoreManagerHome

  late GetStoreManagerHomeBloc _mGetStoreManagerHomeBloc;

  setGetStoreManagerHomeBloc() {
    _mGetStoreManagerHomeBloc = GetStoreManagerHomeBloc();
  }

  getGetStoreManagerHomeBloc() {
    return _mGetStoreManagerHomeBloc;
  }

  ///refresh
  Future<void> refresh() async {
    fetchGetStoreManagerHomeUrl(mSelectStore!);
  }

  Future<void> fetchGetStoreManagerHomeUrl(Stores mStores) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        GetStoreManagerHomeRequest mGetStoreManagerHomeRequest =
        GetStoreManagerHomeRequest(storeId: (mStores.id ?? 0).toString());
        _mGetStoreManagerHomeBloc.add(GetStoreManagerHomeClickEvent(
            mGetStoreManagerHomeRequest: mGetStoreManagerHomeRequest.toJson()));
      } else {
        AppAlert.showSnackBar(
            cBuildContext, MessageConstants.noInternetConnection);
      }
    });
  }

  blocGetStoreManagerHomeListener(
      BuildContext context, GetStoreManagerHomeState state) {
    switch (state.status) {
      case GetStoreManagerHomeStatus.loading:
          AppAlert.showProgressDialog(context);
        break;
      case GetStoreManagerHomeStatus.failed:
        AppAlert.closeDialog(context);
        AppAlert.showSnackBar(
            context, state.webResponseFailed?.statusMessage ?? "");
        break;
      case GetStoreManagerHomeStatus.success:
        AppAlert.closeDialog(context);
        setHomeDetails(state.mGetStoreManagerHomeResponse!);
        break;
    }
  }

  /// SetHomeDetails

  var responseSubject = PublishSubject<GetStoreManagerHomeResponse?>();

  Stream<GetStoreManagerHomeResponse?> get responseStream => responseSubject.stream;

  void closeObservable() {
    responseSubject.close();
  }

  void setHomeDetails(GetStoreManagerHomeResponse state) async {
    try {
      responseSubject.sink.add(state);
    } catch (e) {
      responseSubject.sink.addError(e);
    }
  }

  ///GetStoreManagerProfileDetails

  late GetStoreManagerProfileDetailsBloc _mGetStoreManagerProfileDetailsBloc;

  setStoreManagerProfileDetailsBloc() {
    _mGetStoreManagerProfileDetailsBloc = GetStoreManagerProfileDetailsBloc();
  }

  getStoreManagerProfileDetailsBloc() {
    return _mGetStoreManagerProfileDetailsBloc;
  }

  Future<void> fetchGetStoreManagerProfileDetailsUrl() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _mGetStoreManagerProfileDetailsBloc.add(
            const GetStoreManagerProfileDetailsClickEvent(
                mGetStoreManagerProfileDetailsRequest: ""));
      } else {
        AppAlert.showSnackBar(
            cBuildContext, MessageConstants.noInternetConnection);
      }
    });
  }

  blocGetStoreManagerProfileDetailsListener(
      BuildContext context, GetStoreManagerProfileDetailsState state) {
    switch (state.status) {
      case GetStoreManagerProfileDetailsStatus.loading:
        break;
      case GetStoreManagerProfileDetailsStatus.failed:
        getSharedPrefsSelectStore();
        break;
      case GetStoreManagerProfileDetailsStatus.success:
        getSharedPrefsSelectStore();
        setProfileDetails(state.mGetStoreManagerProfileDetailsResponse!);
        break;
    }
  }

  /// SetProfileDetails

  var responseSubjectProfileDetails =
  PublishSubject<GetStoreManagerProfileDetailsResponse?>();

  Stream<GetStoreManagerProfileDetailsResponse?> get responseStreamProfileDetails =>
      responseSubjectProfileDetails.stream;

  void closeObservableProfileDetails() {
    responseSubjectProfileDetails.close();
  }

  void setProfileDetails(GetStoreManagerProfileDetailsResponse state) async {
    try {
      responseSubjectProfileDetails.sink.add(state);
    } catch (e) {
      responseSubjectProfileDetails.sink.addError(e);
    }
  }
}
