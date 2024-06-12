import 'package:flutter/material.dart';
import 'package:internal_base/common/alert/app_alert.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/call_back.dart';
import 'package:internal_base/common/message_constants.dart';
import 'package:internal_base/common/utils/network_utils.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_profile_details/bloc/get_promoter_profile_details_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_profile_details/bloc/get_promoter_profile_details_event.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_profile_details/bloc/get_promoter_profile_details_state.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_profile_details/repo/get_promoter_profile_details_response.dart';
import 'package:internal_base/data/all_bloc/promoter/post_promoter_profile_update/bloc/post_promoter_profile_update_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/post_promoter_profile_update/bloc/post_promoter_profile_update_event.dart';
import 'package:internal_base/data/all_bloc/promoter/post_promoter_profile_update/bloc/post_promoter_profile_update_state.dart';
import 'package:internal_base/data/all_bloc/promoter/post_promoter_profile_update/repo/post_promoter_profile_update_request.dart';
import 'package:rxdart/rxdart.dart';

class PromoterProfileSettingsScreenModel {
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
  // final TextEditingController mDateofJoiningTextEditingController =
  //     TextEditingController();
  final TextEditingController mPrimaryContactNameTextEditingController =
      TextEditingController();
  final TextEditingController mPrimaryContactNumberTextEditingController =
      TextEditingController();
  // final TextEditingController mICNumberTextEditingController =
  //     TextEditingController();

  PromoterProfileSettingsScreenModel(this.cBuildContext, this.mCallbackModel) {
    /// NavigationDrawerCallbackModel
    mCallbackModel.sMenuValue =
        AppConstants.cWordConstants.wProfileSettingsText;
  }

  Future<void> refresh() async {
    fetchGetPromoteProfileDetailsUrl();
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
        AppAlert.showProgressDialog(context);
        break;
      case GetPromoteProfileDetailsStatus.failed:
        // AppAlert.showProgress = false;
        AppAlert.closeDialog(context);
        AppAlert.showSnackBar(
            context, state.webResponseFailed?.statusMessage ?? "");

        break;
      case GetPromoteProfileDetailsStatus.success:
        AppAlert.closeDialog(context);
        setProfileDetails(
            state.mGetPromoteProfileDetailsResponse!.promoterDetails!);
        break;
    }
  }

  /// SetProfileDetails

  var responseSubjectProfileDetails = PublishSubject<PromoterDetails?>();

  Stream<PromoterDetails?> get responseStreamProfileDetails =>
      responseSubjectProfileDetails.stream;

  void closeObservableProfileDetails() {
    responseSubjectProfileDetails.close();
  }

  void setProfileDetails(PromoterDetails state) async {
    try {
      responseSubjectProfileDetails.sink.add(state);
    } catch (e) {
      responseSubjectProfileDetails.sink.addError(e);
    }
  }

  ///PostPromoterProfileUpdate

  late PostPromoterProfileUpdateBloc _mPostPromoterProfileUpdateBloc;

  setPostPromoterProfileUpdateBloc() {
    _mPostPromoterProfileUpdateBloc = PostPromoterProfileUpdateBloc();
  }

  getPostPromoterProfileUpdateBloc() {
    return _mPostPromoterProfileUpdateBloc;
  }

  Future<void> fetchPostPromoterProfileUpdateUrl() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _mPostPromoterProfileUpdateBloc.add(PostPromoterProfileUpdateClickEvent(
            mPostPromoterProfileUpdateListRequest:
                PostPromoterProfileUpdateRequest(
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

  blocPostPromoterProfileUpdateListener(
      BuildContext context, PostPromoterProfileUpdateState state) {
    switch (state.status) {
      case PostPromoterProfileUpdateStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case PostPromoterProfileUpdateStatus.failed:
        AppAlert.closeDialog(context);
        AppAlert.showSnackBar(
            context, state.webResponseFailed?.statusMessage ?? "");
        break;
      case PostPromoterProfileUpdateStatus.success:
        fetchGetPromoteProfileDetailsUrl();
        AppAlert.closeDialog(context);
        AppAlert.showSnackBar(context, "Profile updated successfully");
        break;
    }
  }
}
