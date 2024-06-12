import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:internal_app_warehose_manager/constants/image_assets_constants.dart';
import 'package:internal_base/common/alert/app_alert.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/message_constants.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/text_styles_constants.dart';
import 'package:internal_base/common/utils/network_utils.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_home/bloc/warehouse_manager_home_bloc.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_home/bloc/warehouse_manager_home_event.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_home/bloc/warehouse_manager_home_state.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_home/repo/warehouse_manager_home_request.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_home/repo/warehouse_manager_home_response.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_profile_details/bloc/warehouse_manager_profile_details_bloc.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_profile_details/bloc/warehouse_manager_profile_details_event.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_profile_details/bloc/warehouse_manager_profile_details_state.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_profile_details/repo/warehouse_manager_profile_details_response.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouses/bloc/get_warehouses_bloc.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouses/bloc/get_warehouses_event.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouses/bloc/get_warehouses_state.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouses/repo/get_warehouses_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:rxdart/rxdart.dart';

class WarehouseManagerHomeViewScreenModel {
  final BuildContext cBuildContext;
  final CallbackModel mCallbackModel;
  late CallbackModel mWarehouseManagerHomeViewScreenModelCallbackModel;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final SharedPrefs sharedPrefs = SharedPrefs();

  WarehouseManagerHomeViewScreenModel(
      this.cBuildContext, this.mCallbackModel) {
    mWarehouseManagerHomeViewScreenModelCallbackModel = CallbackModel();
    mWarehouseManagerHomeViewScreenModelCallbackModel.returnValueChanged = (value){};

    /// NavigationDrawerCallbackModel
    mCallbackModel.sMenuValue = AppConstants.cWordConstants.wHomeText;
  }

  Warehouses? mSelectStore;

  ///SharedPrefs
  getSharedPrefsSelectStore() async {
    await SharedPrefs().getSelectStore().then((sSelectStore) async {
      if (sSelectStore.toString() != "null" &&
          sSelectStore.toString().isNotEmpty) {
        mSelectStore = Warehouses.fromJson(jsonDecode(sSelectStore));
      }
      fetchGetWarehouseManagerStoresUrl();
    });
  }

  setSharedPrefsSelectStore(Warehouses state) async {
    await sharedPrefs.setSelectStore(jsonEncode(state));
  }

  ///
  List<Warehouses> value = [];

  List<DropdownMenuItem<Warehouses>> createList() {
    return value
        .map((item) => DropdownMenuItem<Warehouses>(
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

  ///GetWarehouseManagerStores
  late GetWarehousesBloc _mGetWarehousesBloc;

  setGetWarehousesBloc() {
    _mGetWarehousesBloc = GetWarehousesBloc();
  }

  getGetWarehousesBloc() {
    return _mGetWarehousesBloc;
  }

  Future<void> fetchGetWarehouseManagerStoresUrl() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _mGetWarehousesBloc.add(const GetWarehousesClickEvent());
      } else {
        AppAlert.showSnackBar(
            cBuildContext, MessageConstants.noInternetConnection);
      }
    });
  }

  blocGetWarehouse(
      BuildContext context, GetWarehousesState state) {
    switch (state.status) {
      case GetWarehousesStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case GetWarehousesStatus.failed:
        AppAlert.closeDialog(context);
        AppAlert.showSnackBar(
            context, state.webResponseFailed?.statusMessage ?? "");
        break;
      case GetWarehousesStatus.success:
        AppAlert.closeDialog(context);
        GetWarehousesState mGetWarehousesState = state;
        if (mGetWarehousesState.mGetWarehousesResponse != null &&
            mGetWarehousesState
                .mGetWarehousesResponse!.warehouses!.isNotEmpty) {
          value.clear();
          value.addAll(
              mGetWarehousesState.mGetWarehousesResponse!.warehouses!);
          if (mSelectStore == null) {
            mSelectStore = value.first;
          } else {
            mSelectStore =
                value.singleWhere((element) => element.id == mSelectStore!.id);
          }
          setSelectStore(mSelectStore!);
          fetchGetWarehouseManagerHomeUrl(mSelectStore!);
        }
        break;
    }
  }

  /// SelectStore
  var responseSubjectSelectStore = PublishSubject<Warehouses?>();

  Stream<Warehouses?> get responseStreamSelectStore =>
      responseSubjectSelectStore.stream;

  void closeObservableSelectStore() {
    responseSubjectSelectStore.close();
  }

  void setSelectStore(Warehouses state) async {
    try {
      setSharedPrefsSelectStore(mSelectStore!);
      responseSubjectSelectStore.sink.add(state);
    } catch (e) {
      responseSubjectSelectStore.sink.addError(e);
    }
  }

  ///GetWarehouseManagerHome

  late GetWarehouseManagerHomeBloc _mGetWarehouseManagerHomeBloc;

  setGetWarehouseManagerHomeBloc() {
    _mGetWarehouseManagerHomeBloc = GetWarehouseManagerHomeBloc();
  }

  getGetWarehouseManagerHomeBloc() {
    return _mGetWarehouseManagerHomeBloc;
  }

  ///refresh
  Future<void> refresh() async {
    fetchGetWarehouseManagerHomeUrl(mSelectStore!);
  }

  Future<void> fetchGetWarehouseManagerHomeUrl(Warehouses mStores) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        GetWarehouseManagerHomeRequest mGetWarehouseManagerHomeRequest =
        GetWarehouseManagerHomeRequest(warehouseId: (mStores.id ?? 0).toString());
        _mGetWarehouseManagerHomeBloc.add(GetWarehouseManagerHomeClickEvent(
            mGetWarehouseManagerHomeRequest: mGetWarehouseManagerHomeRequest.toJson()));
      } else {
        AppAlert.showSnackBar(
            cBuildContext, MessageConstants.noInternetConnection);
      }
    });
  }

  blocGetWarehouseManagerHomeListener(
      BuildContext context, GetWarehouseManagerHomeState state) {
    switch (state.status) {
      case GetWarehouseManagerHomeStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case GetWarehouseManagerHomeStatus.failed:
        AppAlert.closeDialog(context);
        AppAlert.showSnackBar(
            context, state.webResponseFailed?.statusMessage ?? "");
        break;
      case GetWarehouseManagerHomeStatus.success:
        AppAlert.closeDialog(context);
        setHomeDetails(state.mGetWarehouseManagerHomeResponse!);
        break;
    }
  }

  /// SetHomeDetails

  var responseSubject = PublishSubject<GetWarehouseManagerHomeResponse?>();

  Stream<GetWarehouseManagerHomeResponse?> get responseStream => responseSubject.stream;

  void closeObservable() {
    responseSubject.close();
  }

  void setHomeDetails(GetWarehouseManagerHomeResponse state) async {
    try {
      responseSubject.sink.add(state);
    } catch (e) {
      responseSubject.sink.addError(e);
    }
  }

  ///GetWarehouseManagerProfileDetails

  late GetWarehouseManagerProfileDetailsBloc _mGetWarehouseManagerProfileDetailsBloc;

  setWarehouseManagerProfileDetailsBloc() {
    _mGetWarehouseManagerProfileDetailsBloc = GetWarehouseManagerProfileDetailsBloc();
  }

  getWarehouseManagerProfileDetailsBloc() {
    return _mGetWarehouseManagerProfileDetailsBloc;
  }

  Future<void> fetchGetWarehouseManagerProfileDetailsUrl() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _mGetWarehouseManagerProfileDetailsBloc.add(
            const GetWarehouseManagerProfileDetailsClickEvent(
                mGetWarehouseManagerProfileDetailsRequest: ""));
      } else {
        AppAlert.showSnackBar(
            cBuildContext, MessageConstants.noInternetConnection);
      }
    });
  }

  blocGetWarehouseManagerProfileDetailsListener(
      BuildContext context, GetWarehouseManagerProfileDetailsState state) {
    switch (state.status) {
      case GetWarehouseManagerProfileDetailsStatus.loading:
        break;
      case GetWarehouseManagerProfileDetailsStatus.failed:
        getSharedPrefsSelectStore();
        break;
      case GetWarehouseManagerProfileDetailsStatus.success:
        getSharedPrefsSelectStore();
        setProfileDetails(state.mGetWarehouseManagerProfileDetailsResponse!);
        break;
    }
  }

  /// SetProfileDetails

  var responseSubjectProfileDetails =
  PublishSubject<GetWarehouseManagerProfileDetailsResponse?>();

  Stream<GetWarehouseManagerProfileDetailsResponse?> get responseStreamProfileDetails =>
      responseSubjectProfileDetails.stream;

  void closeObservableProfileDetails() {
    responseSubjectProfileDetails.close();
  }

  void setProfileDetails(GetWarehouseManagerProfileDetailsResponse state) async {
    try {
      responseSubjectProfileDetails.sink.add(state);
    } catch (e) {
      responseSubjectProfileDetails.sink.addError(e);
    }
  }
}
