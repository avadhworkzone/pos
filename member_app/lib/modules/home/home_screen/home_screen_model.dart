import 'dart:io';

import 'package:flutter/material.dart';
import 'package:member_app/common/alert/app_alert.dart';
import 'package:member_app/common/app_constants.dart';
import 'package:member_app/common/call_back.dart';
import 'package:member_app/common/message_constants.dart';
import 'package:member_app/common/utils/app_utils.dart';
import 'package:member_app/common/utils/launcher_utils.dart';
import 'package:member_app/common/utils/network_utils.dart';
import 'package:member_app/data/all_bloc/get_members_details_bloc/bloc/get_members_details_bloc.dart';
import 'package:member_app/data/all_bloc/get_members_details_bloc/bloc/get_members_details_event.dart';
import 'package:member_app/data/all_bloc/get_members_details_bloc/bloc/get_members_details_state.dart';
import 'package:member_app/data/all_bloc/get_members_details_bloc/repo/member_details.dart';
import 'package:member_app/data/all_bloc/get_members_details_bloc/repo/get_members_details_response.dart';
import 'package:member_app/data/local/shared_prefs/shared_prefs.dart';
import 'package:member_app/modules/home/my_card/view/my_card_screen.dart';
import 'package:member_app/modules/home/my_profile/view/my_profile_model.dart';
import 'package:member_app/modules/home/my_profile/view/my_profile_screen.dart';
import 'package:member_app/modules/home/reward/view/reward_screen.dart';
import 'package:member_app/routes/route_constants.dart';
import 'package:rxdart/rxdart.dart';

class HomeScreenModel {
  final ValueChanged<dynamic> returnValueChanged;
  dynamic sValue = "";

  final BuildContext mBuildContext;
  List<dynamic> levyArrearsVOList = [];

  HomeScreenModel(this.returnValueChanged, this.mBuildContext);

  /// get Login Member Details
  getLoginMemberDetails() async {
    await SharedPrefs().getMember().then((member) {
      setResponseState(member);
    });
  }

  var responseSubject = PublishSubject<MemberDetails?>();

  Stream<MemberDetails?> get responseStream => responseSubject.stream;

  void closeObservable() {
    responseSubject.close();
  }

  void setResponseState(MemberDetails state) async {
    try {
      responseSubject.sink.add(state);
    } catch (e) {
      responseSubject.sink.addError(e);
    }
  }

  ///

  int selectedIndex = 0;
  late List<Widget> widgetOptions;

  setWidget() {
    widgetOptions = <Widget>[
      MyCardScreenWidget(mHomeScreenModel: this),
      RewardScreenWidget(mHomeScreenModel: this),
      MyProfileScreenWidget(mHomeScreenModel: this)
    ];
  }

  ///open url
  openUrl(String eLearningUrl) {
    if (AppUtils.isValidUrl(eLearningUrl)) {
      if (Platform.isIOS) {
        LauncherUtils()
            .launchWebUrl(eLearningUrl.toString().trim(), mBuildContext);
      } else {
        LauncherUtils().launchWebUrlExternalApp(
            eLearningUrl.toString().trim(), mBuildContext);
      }
    } else {
      AppAlert.showSnackBar(
          mBuildContext, AppConstants.mWordConstants.wGoNowError);
    }
  }

  CallbackModel getCallbackModel(MemberDetails mLoginMemberDetails) {
    CallbackModel mCallbackModel = CallbackModel(
      (value) {},
    );
    MyProfileModel mMyProfileModel = MyProfileModel();
    mMyProfileModel.sFirstName = mLoginMemberDetails.firstName ?? "";
    mMyProfileModel.sLastName = mLoginMemberDetails.lastName ?? "";
    mMyProfileModel.sEmail = mLoginMemberDetails.email ?? "";
    mMyProfileModel.sDob = mLoginMemberDetails.dateOfBirth ?? "";
    mMyProfileModel.sPhone = mLoginMemberDetails.mobileNumber ?? "";
    mMyProfileModel.sPhoto = mLoginMemberDetails.photoUrl ?? "";
    mMyProfileModel.sRacesId = mLoginMemberDetails.raceDetails.toString() == "null"
        ? ""
        : mLoginMemberDetails.raceDetails!.id.toString();
    mMyProfileModel.sRacesName = mLoginMemberDetails.raceDetails.toString() == "null"
        ? ""
        : mLoginMemberDetails.raceDetails!.name.toString();
    mMyProfileModel.sGenderId = mLoginMemberDetails.genderDetails.toString() == "null"
        ? ""
        : mLoginMemberDetails.genderDetails!.id.toString();
    mMyProfileModel.sGenderName = mLoginMemberDetails.genderDetails.toString() == "null"
        ? ""
        : mLoginMemberDetails.genderDetails!.name.toString();
    mMyProfileModel.sTitlesId = mLoginMemberDetails.titleDetails.toString() == "null"
        ? ""
        : mLoginMemberDetails.titleDetails!.id.toString();
    mMyProfileModel.sTitlesName = mLoginMemberDetails.titleDetails.toString() == "null"
        ? ""
        : mLoginMemberDetails.titleDetails!.name.toString();

    mMyProfileModel.sCity = mLoginMemberDetails.city ?? "";
    mMyProfileModel.sAreaCode = mLoginMemberDetails.areaCode ?? "";
    mMyProfileModel.sAddress1 = mLoginMemberDetails.addressLine1 ?? "";
    mMyProfileModel.sAddress2 = mLoginMemberDetails.addressLine2 ?? "";
    mCallbackModel.sValue = mMyProfileModel;

    return mCallbackModel;
  }

  late GetMemberDetailsBloc _mGetMemberDetailsBloc;

  GetMemberDetailsBloc get mGetMemberDetailsBloc => _mGetMemberDetailsBloc;

  setGetMemberDetailsBloc() {
    _mGetMemberDetailsBloc = GetMemberDetailsBloc();
  }

  Future<void> initGetMemberDetails() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _mGetMemberDetailsBloc.add(const GetMemberDetailsClickEvent());
      } else {
        AppAlert.showSnackBar(mBuildContext, MessageConstants.noInternetConnection);
      }
    });
  }

  fGetMemberDetailsBlocListener(
      BuildContext context, GetMemberDetailsState state) async {
    switch (state.status) {
      case GetMemberDetailsStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case GetMemberDetailsStatus.failed:
        AppAlert.closeDialog(context);
        if (state.webResponseFailed != null) {
          AppAlert.showSnackBar(
              context, state.webResponseFailed!.statusMessage ?? "");
          // await SharedPrefs().setUserToken("");
          // await SharedPrefs().clearSharedPreferences();
          // Navigator.pushNamedAndRemoveUntil(context,
          //     RouteConstants.rWelcomeScreenWidget, (route) => false);
        } else {
          AppAlert.showSnackBar(
            context,
            MessageConstants.wSomethingWentWrong,
          );
        }
        break;
      case GetMemberDetailsStatus.success:
        AppAlert.closeDialog(context);
        break;
    }
  }
}
