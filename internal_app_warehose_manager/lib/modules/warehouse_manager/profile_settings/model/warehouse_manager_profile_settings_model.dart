import 'package:flutter/material.dart';
import 'package:internal_base/common/alert/app_alert.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/message_constants.dart';
import 'package:internal_base/common/utils/network_utils.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_profile_details/bloc/warehouse_manager_profile_details_bloc.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_profile_details/bloc/warehouse_manager_profile_details_event.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_profile_details/bloc/warehouse_manager_profile_details_state.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_profile_details/repo/warehouse_manager_profile_details_response.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_profile_update/bloc/warehouse_manager_profile_update_bloc.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_profile_update/bloc/warehouse_manager_profile_update_event.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_profile_update/bloc/warehouse_manager_profile_update_state.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_profile_update/repo/warehouse_manager_profile_update_request.dart';
import 'package:rxdart/rxdart.dart';

class WarehouseManagerProfileSettingsScreenModel {
  final BuildContext cBuildContext;
  final CallbackModel mCallbackModel;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController mUsernameTextEditingController =
      TextEditingController();
  final TextEditingController mFirstNameTextEditingController =
  TextEditingController();
  final TextEditingController mEmailIdTextEditingController =
      TextEditingController();
  final TextEditingController mPhoneNumberTextEditingController =
      TextEditingController();
  final TextEditingController mStaffIdTextEditingController =
      TextEditingController();
  final TextEditingController mAddressLine1TextEditingController =
      TextEditingController();
  final TextEditingController mAddressLine2TextEditingController =
      TextEditingController();
  final TextEditingController mCityTextEditingController =
      TextEditingController();
  final TextEditingController mAreaCodeTextEditingController =
      TextEditingController();
  final TextEditingController mDateofJoiningTextEditingController =
      TextEditingController();
  final TextEditingController mPrimaryContactNameTextEditingController =
      TextEditingController();
  final TextEditingController mPrimaryContactNumberTextEditingController =
      TextEditingController();
  final TextEditingController mICNumberTextEditingController =
      TextEditingController();

  WarehouseManagerProfileSettingsScreenModel(
      this.cBuildContext, this.mCallbackModel) {
    /// NavigationDrawerCallbackModel
    mCallbackModel.sMenuValue =
        AppConstants.cWordConstants.wProfileSettingsText;
  }

  Future<void> refresh() async {
    fetchGetWarehouseManagerProfileDetailsUrl();
  }

  ///GetWarehouseManagerProfileDetails

  late GetWarehouseManagerProfileDetailsBloc
      _mGetWarehouseManagerProfileDetailsBloc;

  setWarehouseManagerProfileDetailsBloc() {
    _mGetWarehouseManagerProfileDetailsBloc =
        GetWarehouseManagerProfileDetailsBloc();
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
        AppAlert.showProgressDialog(context);
        break;
      case GetWarehouseManagerProfileDetailsStatus.failed:
        AppAlert.closeDialog(context);
        AppAlert.showSnackBar(
            context, state.webResponseFailed?.statusMessage ?? "");

        break;
      case GetWarehouseManagerProfileDetailsStatus.success:
        AppAlert.closeDialog(context);
        setProfileDetails(state.mGetWarehouseManagerProfileDetailsResponse!
            .warehouseManagerDetails!);
        break;
    }
  }

  /// SetProfileDetails

  var responseSubjectProfileDetails =
      PublishSubject<WarehouseManagerDetails?>();

  Stream<WarehouseManagerDetails?> get responseStreamProfileDetails =>
      responseSubjectProfileDetails.stream;

  void closeObservableProfileDetails() {
    responseSubjectProfileDetails.close();
  }

  void setProfileDetails(WarehouseManagerDetails state) async {
    try {
      responseSubjectProfileDetails.sink.add(state);
    } catch (e) {
      responseSubjectProfileDetails.sink.addError(e);
    }
  }

  ///PostWarehouseManagerProfileUpdate

  late PostWarehouseManagerProfileUpdateBloc
      _mPostWarehouseManagerProfileUpdateBloc;

  setPostWarehouseManagerProfileUpdateBloc() {
    _mPostWarehouseManagerProfileUpdateBloc =
        PostWarehouseManagerProfileUpdateBloc();
  }

  getPostWarehouseManagerProfileUpdateBloc() {
    return _mPostWarehouseManagerProfileUpdateBloc;
  }

  Future<void> fetchPostWarehouseManagerProfileUpdateUrl() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _mPostWarehouseManagerProfileUpdateBloc.add(
            PostWarehouseManagerProfileUpdateClickEvent(
                mPostWarehouseManagerProfileUpdateListRequest:
                    PostWarehouseManagerProfileUpdateRequest(
          firstName: mFirstNameTextEditingController.text,
          mobileNumber: mPhoneNumberTextEditingController.text,
          addressLine1: mAddressLine1TextEditingController.text,
          addressLine2: mAddressLine2TextEditingController.text,
          areaCode: mAreaCodeTextEditingController.text,
          city: mCityTextEditingController.text,
          primaryContactName: mPrimaryContactNameTextEditingController.text,
          primaryContactPhone: mPrimaryContactNumberTextEditingController.text,
          userName: mUsernameTextEditingController.text,
          email: mEmailIdTextEditingController.text,
        )));
      } else {
        AppAlert.showSnackBar(
            cBuildContext, MessageConstants.noInternetConnection);
      }
    });
  }

  blocPostWarehouseManagerProfileUpdateListener(
      BuildContext context, PostWarehouseManagerProfileUpdateState state) {
    debugPrint("adfadsf");
    switch (state.status) {
      case PostWarehouseManagerProfileUpdateStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case PostWarehouseManagerProfileUpdateStatus.failed:
        AppAlert.closeDialog(context);
        AppAlert.showSnackBar(
            context, state.webResponseFailed?.statusMessage ?? "");
        break;
      case PostWarehouseManagerProfileUpdateStatus.success:
        fetchGetWarehouseManagerProfileDetailsUrl();
        AppAlert.closeDialog(context);
        AppAlert.showSnackBar(context, "Profile updated successfully");
        break;
    }
  }
}
