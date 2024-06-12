import 'package:flutter/material.dart';
import 'package:internal_base/common/alert/app_alert.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/message_constants.dart';
import 'package:internal_base/common/utils/network_utils.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_profile_details/bloc/store_manager_profile_details_bloc.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_profile_details/bloc/store_manager_profile_details_event.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_profile_details/bloc/store_manager_profile_details_state.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_profile_details/repo/store_manager_profile_details_response.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_profile_update/bloc/store_manager_profile_update_bloc.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_profile_update/bloc/store_manager_profile_update_event.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_profile_update/bloc/store_manager_profile_update_state.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_profile_update/repo/store_manager_profile_update_request.dart';
import 'package:rxdart/rxdart.dart';

class StoreManagerProfileSettingsScreenModel {
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

  StoreManagerProfileSettingsScreenModel(
      this.cBuildContext, this.mCallbackModel) {
    mCallbackModel.sMenuValue =
        AppConstants.cWordConstants.wProfileSettingsText;
  }

  Future<void> refresh() async {
    fetchGetStoreManagerProfileDetailsUrl();
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
        AppAlert.showProgressDialog(context);
        break;
      case GetStoreManagerProfileDetailsStatus.failed:
        AppAlert.closeDialog(context);
        AppAlert.showSnackBar(
            context, state.webResponseFailed?.statusMessage ?? "");

        break;
      case GetStoreManagerProfileDetailsStatus.success:
        AppAlert.closeDialog(context);
        setProfileDetails(
            state.mGetStoreManagerProfileDetailsResponse!.storeManagerDetails!);
        break;
    }
  }

  /// SetProfileDetails

  var responseSubjectProfileDetails = PublishSubject<StoreManagerDetails?>();

  Stream<StoreManagerDetails?> get responseStreamProfileDetails =>
      responseSubjectProfileDetails.stream;

  void closeObservableProfileDetails() {
    responseSubjectProfileDetails.close();
  }

  void setProfileDetails(StoreManagerDetails state) async {
    try {
      responseSubjectProfileDetails.sink.add(state);
    } catch (e) {
      responseSubjectProfileDetails.sink.addError(e);
    }
  }

  ///PostStoreManagerProfileUpdate

  late PostStoreManagerProfileUpdateBloc _mPostStoreManagerProfileUpdateBloc;

  setPostStoreManagerProfileUpdateBloc() {
    _mPostStoreManagerProfileUpdateBloc = PostStoreManagerProfileUpdateBloc();
  }

  getPostStoreManagerProfileUpdateBloc() {
    return _mPostStoreManagerProfileUpdateBloc;
  }

  Future<void> fetchPostStoreManagerProfileUpdateUrl() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        print(
            'mPhoneNumberTextEditingController.text-------------------${mPhoneNumberTextEditingController.text}');
        _mPostStoreManagerProfileUpdateBloc.add(
            PostStoreManagerProfileUpdateClickEvent(
                mPostStoreManagerProfileUpdateListRequest:
                    PostStoreManagerProfileUpdateRequest(
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

  blocPostStoreManagerProfileUpdateListener(
      BuildContext context, PostStoreManagerProfileUpdateState state) {
    switch (state.status) {
      case PostStoreManagerProfileUpdateStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case PostStoreManagerProfileUpdateStatus.failed:
        AppAlert.closeDialog(context);
        AppAlert.showSnackBar(
            context, state.webResponseFailed?.statusMessage ?? "");
        break;
      case PostStoreManagerProfileUpdateStatus.success:
        fetchGetStoreManagerProfileDetailsUrl();
        AppAlert.closeDialog(context);
        AppAlert.showSnackBar(context, "Profile updated successfully");
        break;
    }
  }
}
