import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:member_app/common/alert/alert_action.dart';
import 'package:member_app/common/alert/app_alert.dart';
import 'package:member_app/common/app_constants.dart';
import 'package:member_app/common/button_constants.dart';
import 'package:member_app/common/call_back.dart';
import 'package:member_app/common/color_constants.dart';
import 'package:member_app/common/image_assets.dart';
import 'package:member_app/common/message_constants.dart';
import 'package:member_app/common/size_constants.dart';
import 'package:member_app/common/text_styles_constants.dart';
import 'package:member_app/data/all_bloc/get_members_details_bloc/repo/member_details.dart';
import 'package:member_app/data/local/shared_prefs/shared_prefs.dart';
import 'package:member_app/modules/home/home_screen/home_screen_model.dart';
import 'package:member_app/modules/home/my_profile/view/my_profile_model.dart';
import 'package:member_app/routes/route_constants.dart';

class MyProfileScreenWidget extends StatefulWidget {
  final HomeScreenModel mHomeScreenModel;

  const MyProfileScreenWidget({super.key, required this.mHomeScreenModel});

  @override
  State<MyProfileScreenWidget> createState() => _MyProfileScreenWidgetState();
}

class _MyProfileScreenWidgetState extends State<MyProfileScreenWidget> {
  late MyProfileModel mMyProfileModel = MyProfileModel();

  @override
  void initState() {
    super.initState();
    widget.mHomeScreenModel.getLoginMemberDetails();
    getProfile();
  }

  getProfile() async {
    await SharedPrefs().getMember().then((member) {
      mMyProfileModel.sFirstName = member.firstName.toString() == "null"
          ? ""
          : member.firstName.toString();
      mMyProfileModel.sLastName = member.lastName.toString() == "null"
          ? ""
          : member.lastName.toString();
      mMyProfileModel.sEmail =
          member.email.toString() == "null" ? "" : member.email.toString();
      mMyProfileModel.sPhone = member.mobileNumber.toString() == "null"
          ? ""
          : member.mobileNumber.toString();
      mMyProfileModel.sDob = member.dateOfBirth.toString() == "null"
          ? ""
          : member.dateOfBirth.toString();
      mMyProfileModel.sPhoto = member.photoUrl.toString() == "null"
          ? ""
          : member.photoUrl.toString();
      mMyProfileModel.sCity =
          member.city.toString() == "null" ? "" : member.city.toString();
      mMyProfileModel.sAreaCode = member.areaCode.toString() == "null"
          ? ""
          : member.areaCode.toString();
      mMyProfileModel.sAddress1 = member.addressLine1.toString() == "null"
          ? ""
          : member.addressLine1.toString();
      mMyProfileModel.sAddress2 = member.addressLine2.toString() == "null"
          ? ""
          : member.addressLine2.toString();
      mMyProfileModel.sRacesName = member.raceDetails.toString() == "null"
          ? ""
          : member.raceDetails!.name.toString();
      mMyProfileModel.sRacesId = member.raceDetails.toString() == "null"
          ? ""
          : member.raceDetails!.id.toString();

      mMyProfileModel.sGenderName = member.genderDetails.toString() == "null"
          ? ""
          : member.genderDetails!.name.toString();
      mMyProfileModel.sGenderId = member.genderDetails.toString() == "null"
          ? ""
          : member.genderDetails!.id.toString();
      mMyProfileModel.sTitlesName = member.titleDetails.toString() == "null"
          ? ""
          : member.titleDetails!.name.toString();
      mMyProfileModel.sTitlesId = member.titleDetails.toString() == "null"
          ? ""
          : member.titleDetails!.id.toString();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildMyProfileScreenWidgetView());
  }

  _buildMyProfileScreenWidgetView() {
    return FocusDetector(
        onVisibilityGained: () {},
        child: SafeArea(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: SizeConstants.s_20,
                  left: SizeConstants.s_20,
                  right: SizeConstants.s_20,
                ),
                child: _showTopView(),
              ),
              Expanded(
                  child: Container(
                padding: EdgeInsets.only(bottom: SizeConstants.s_20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(SizeConstants.s1 * 20),
                    topRight: Radius.circular(SizeConstants.s1 * 20),
                  ),
                ),
                child: SingleChildScrollView(
                  child: _showMiddle(),
                ),
              ))
            ],
          ),
        ));
  }

  _showTopView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
            child: Container(
          height: SizeConstants.width * 0.26,
          width: SizeConstants.width * 0.26,
          padding: EdgeInsets.all(SizeConstants.s_10),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: ColorConstants.kPrimaryColor.shade600)),
          child: ClipOval(
              child: Image.asset(
            ImageAssets.imageAppBarLogo,
          )),
        )),
        SizedBox(
          height: SizeConstants.s_10,
        ),
        Text("${mMyProfileModel.sFirstName} ${mMyProfileModel.sLastName}",
            maxLines: 2,
            style: getTextSemiBold(
                colors: ColorConstants.cBlack, size: SizeConstants.s_16)),
        SizedBox(
          height: SizeConstants.s_8,
        ),
        Text(mMyProfileModel.sEmail,
            style: getTextRegular(
                colors: ColorConstants.cBlack, size: SizeConstants.s_14)),
        SizedBox(
          height: SizeConstants.s_8,
        ),
        Text(mMyProfileModel.sPhone,
            style: getTextRegular(
                colors: ColorConstants.cBlack, size: SizeConstants.s_14)),
        SizedBox(
          height: mMyProfileModel.sDob.isEmpty ? 0.0 : SizeConstants.s_8,
        ),
        mMyProfileModel.sDob.isNotEmpty
            ? Text(mMyProfileModel.sDob,
                style: getTextRegular(
                    colors: ColorConstants.cBlack, size: SizeConstants.s_14))
            : const SizedBox(),
        SizedBox(
          height: SizeConstants.s_20,
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: SizeConstants.width * 0.11,
              child: mediumRoundedCornerButton(
                  appbarActionInterface: (value) async {
                    CallbackModel mCallbackModel = CallbackModel(
                      (value) {
                        setState(() {
                          mMyProfileModel = value as MyProfileModel;
                        });
                      },
                    );
                    mCallbackModel.sValue = mMyProfileModel;

                    await Navigator.pushNamed(
                        context, RouteConstants.rEditProfileScreenWidget,
                        arguments: mCallbackModel);

                    getProfile();
                  },
                  sButtonTitle:
                      AppConstants.mWordConstants.sEditProfile.toUpperCase(),
                  cButtonBackGroundColor: ColorConstants.kPrimaryColor.shade600,
                  cButtonTextColor: ColorConstants.cWhite,
                  dButtonTextSize: SizeConstants.s_14,
                  cButtonBorderColor: ColorConstants.kPrimaryColor.shade600,
                  dButtonWidth: SizeConstants.width * 0.4,
                  dButtonRadius: SizeConstants.s_15),
            )),
        SizedBox(
          height: SizeConstants.s_15,
        ),
        streamBuildViewWallet(),
        SizedBox(
          height: SizeConstants.s_15,
        ),
      ],
    );
  }

  _showMiddle() {
    return SizedBox(
      width: SizeConstants.width,
      child: Column(
        children: [
          // textView(AppConstants.mWordConstants.sTransactions),
          // Container(
          //   height: SizeConstants.s1,
          //   width: SizeConstants.width,
          //   color: Colors.grey.shade200,
          // ),
          textView(AppConstants.mWordConstants.sLogout,
              bIcon: false, fIcon: true, sfIcon: ImageAssets.imageLogout),
          // Container(
          //   height: SizeConstants.s1,
          //   width: SizeConstants.width,
          //   color: Colors.grey.shade200,
          // ),
        ],
      ),
    );
  }

  textView(String sTitle,
      {bool bIcon = true, bool fIcon = false, String sfIcon = ""}) {
    return GestureDetector(
      child: Container(
        height: SizeConstants.width * 0.15,
        padding: EdgeInsets.only(
          left: SizeConstants.s_20,
          right: SizeConstants.s_20,
        ),
        child: Row(
          children: [
            fIcon
                ? Image.asset(sfIcon,
                    height: SizeConstants.s_20, width: SizeConstants.s_20)
                : const SizedBox(),
            sfIcon.isEmpty
                ? const SizedBox()
                : SizedBox(
                    width: SizeConstants.s_10,
                  ),
            Expanded(
                child: Text(
              sTitle,
              style: getTextMedium(
                  colors: ColorConstants.cBlack, size: SizeConstants.s_16),
            )),
            bIcon
                ? Icon(
                    Icons.arrow_forward_ios,
                    color: ColorConstants.cBlack,
                    size: SizeConstants.s_20,
                  )
                : const SizedBox(),
          ],
        ),
      ),
      onTap: () {
        if (sTitle == AppConstants.mWordConstants.sTransactions) {
          Navigator.pushNamed(context, RouteConstants.rTransactionScreenWidget);
        } else if (sTitle == AppConstants.mWordConstants.sLogout) {
          AppAlert.showCustomDialogYesNo(
            context,
            MessageConstants.wLogoutTitle,
            MessageConstants.wLogoutMessage,
            buttonOneText: MessageConstants.wCancel,
            buttonTwoText: MessageConstants.wLogOut,
          ).then((value) async {
            if (value == AlertAction.yes) {
              await SharedPrefs().setUserToken("");
              await SharedPrefs().clearSharedPreferences();
              Navigator.pushNamedAndRemoveUntil(context,
                  RouteConstants.rWelcomeScreenWidget, (route) => false);
            }
          });
        }
      },
    );
  }

  streamBuildViewWallet() {
    return StreamBuilder<MemberDetails?>(
      stream: widget.mHomeScreenModel.responseSubject,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          MemberDetails mLoginMemberDetails = snapshot.data as MemberDetails;
          debugPrint("2object${jsonEncode(mLoginMemberDetails)}");

          if (mLoginMemberDetails != null) {
            return Container(
                margin: EdgeInsets.only(
                    left: SizeConstants.s_15, right: SizeConstants.s_15),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () async {
                            if (mLoginMemberDetails.email.toString() !=
                                "null" &&
                                mLoginMemberDetails.email
                                    .toString()
                                    .trim()
                                    .isNotEmpty) {
                              widget.mHomeScreenModel.openUrl(
                                  mLoginMemberDetails.androidDigitalPassLink ??
                                      "");
                            } else {
                              await Navigator.pushNamed(context,
                                  RouteConstants.rEditProfileScreenWidget,
                                  arguments: widget.mHomeScreenModel
                                      .getCallbackModel(mLoginMemberDetails));
                              widget.mHomeScreenModel.getLoginMemberDetails();
                            }
                          },
                          child: Container(
                              height: SizeConstants.s1 * 40,
                              width: SizeConstants.width,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        ImageAssets.imageAndroidPay),
                                    fit: BoxFit.fitHeight,
                                  ))),
                        )),
                    SizedBox(
                      width: SizeConstants.s_20,
                    ),
                    Expanded(
                        flex: 1,
                        child: GestureDetector(
                            onTap: () async {
                              if (mLoginMemberDetails.email.toString() !=
                                  "null" &&
                                  mLoginMemberDetails.email
                                      .toString()
                                      .trim()
                                      .isNotEmpty) {
                                widget.mHomeScreenModel.openUrl(
                                    mLoginMemberDetails.iosDigitalPassLink ??
                                        "");
                              } else {
                                await Navigator.pushNamed(context,
                                    RouteConstants.rEditProfileScreenWidget,
                                    arguments: widget.mHomeScreenModel
                                        .getCallbackModel(mLoginMemberDetails));
                                widget.mHomeScreenModel.getLoginMemberDetails();
                              }
                            },
                            child: Container(
                                height: SizeConstants.s1 * 40,
                                width: SizeConstants.width,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          ImageAssets.imageIosPay),
                                      fit: BoxFit.fitHeight,
                                    ))))),
                  ],
                ));
          } else {
            return const SizedBox();
          }
        }
        return const SizedBox();
      },
    );
  }
}
