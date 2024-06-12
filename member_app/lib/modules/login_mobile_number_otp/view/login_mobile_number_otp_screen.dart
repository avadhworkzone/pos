import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:member_app/common/alert/app_alert.dart';
import 'package:member_app/common/app_constants.dart';
import 'package:member_app/common/appbars_constants.dart';
import 'package:member_app/common/button_constants.dart';
import 'package:member_app/common/color_constants.dart';
import 'package:member_app/common/image_assets.dart';
import 'package:member_app/common/message_constants.dart';
import 'package:member_app/common/otp_under_line_view/otp_field.dart';
import 'package:member_app/common/otp_under_line_view/otp_style.dart';
import 'package:member_app/common/text_styles_constants.dart';
import 'package:member_app/common/utils/network_utils.dart';
import 'package:member_app/common/widget/app_bar_bottom_view.dart';
import 'package:member_app/data/all_bloc/login_mobile_number_bloc/bloc/login_mobile_number_screen_bloc.dart';
import 'package:member_app/data/all_bloc/login_mobile_number_bloc/bloc/login_mobile_number_screen_event.dart';
import 'package:member_app/data/all_bloc/login_mobile_number_bloc/bloc/login_mobile_number_screen_state.dart';
import 'package:member_app/data/all_bloc/login_mobile_number_bloc/repo/login_mobile_number_screen_request.dart';
import 'package:member_app/data/all_bloc/login_mobile_number_otp_bloc/bloc/login_mobile_number_otp_screen_bloc.dart';
import 'package:member_app/data/all_bloc/login_mobile_number_otp_bloc/bloc/login_mobile_number_otp_screen_event.dart';
import 'package:member_app/data/all_bloc/login_mobile_number_otp_bloc/bloc/login_mobile_number_otp_screen_state.dart';
import 'package:member_app/data/all_bloc/login_mobile_number_otp_bloc/repo/login_mobile_number_otp_screen_request.dart';
import 'package:member_app/routes/route_constants.dart';
import '../../../common/size_constants.dart';

class LoginMobileNumberOtpScreenWidget extends StatefulWidget {
  final String sMobileNumber;

  const LoginMobileNumberOtpScreenWidget(
      {super.key, required this.sMobileNumber});

  @override
  State<LoginMobileNumberOtpScreenWidget> createState() =>
      _LoginMobileNumberOtpScreenWidgetState();
}

class _LoginMobileNumberOtpScreenWidgetState
    extends State<LoginMobileNumberOtpScreenWidget> {
  late LoginMobileNumberOtpScreenBloc _mLoginMobileNumberOtpScreenBloc;
  late LoginMobileNumberScreenBloc _mLoginMobileNumberScreenBloc;

  final OtpFieldController _controllerMobileNumberOtp = OtpFieldController();
  String sOtpPin = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mLoginMobileNumberOtpScreenBloc = LoginMobileNumberOtpScreenBloc();
    _mLoginMobileNumberScreenBloc = LoginMobileNumberScreenBloc();
  }

  Future<void> _initLoginMobileNumberOtpScreen(String sOtp) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _mLoginMobileNumberOtpScreenBloc.add(
            LoginMobileNumberOtpScreenClickEvent(
                mLoginMobileNumberOtpScreenListRequest:
                    LoginMobileNumberOtpScreenRequest(
                        mobileNumber: widget.sMobileNumber, otp: sOtp)));
      } else {
        AppAlert.showSnackBar(context, MessageConstants.noInternetConnection);
      }
    });
  }

  Future<void> _initLoginMobileNumberScreen() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _mLoginMobileNumberScreenBloc.add(LoginMobileNumberScreenClickEvent(
            mLoginMobileNumberScreenListRequest: LoginMobileNumberScreenRequest(
                mobileNumber: widget.sMobileNumber)));
      } else {
        AppAlert.showSnackBar(context, MessageConstants.noInternetConnection);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBars.appBar(
                (value) {

            },
            AppConstants.mWordConstants.sOTPVerification
        ),
        body: MultiBlocListener(
          child: _buildLoginMobileNumberOtpView(),
          listeners: [
            BlocListener<LoginMobileNumberScreenBloc,
                    LoginMobileNumberScreenState>(
                bloc: _mLoginMobileNumberScreenBloc,
                listener: (context, state) {
                  _fLoginMobileNumberScreenBlocListener(context, state);
                }),
            BlocListener<LoginMobileNumberOtpScreenBloc,
                    LoginMobileNumberOtpScreenState>(
                bloc: _mLoginMobileNumberOtpScreenBloc,
                listener: (context, state) {
                  _fLoginMobileNumberScreenOtpBlocListener(context, state);
                }),
          ],
        ));
  }

  _buildLoginMobileNumberOtpView() {
    return FocusDetector(
        child: SafeArea(
      child: Column(children: [
        // appBarBottomViewWithTextBack(
        //     AppConstants.mWordConstants.sOTPVerification, context),
        Expanded(
            child: SingleChildScrollView(
                child: SizedBox(
                    width: double.infinity,
                    height: SizeConstants.height * 0.885,
                    child: Column(children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: SizeConstants.s_32, bottom: SizeConstants.s_20),
                        padding: EdgeInsets.all(SizeConstants.s_16),
                        child: Image.asset(ImageAssets.imagePhone,
                            height: SizeConstants.width * 0.32, fit: BoxFit.fitHeight),
                      ),

                      Expanded(
                          child: Container(
                              padding: EdgeInsets.only(top: SizeConstants.s_26),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: const Offset(
                                        0, 1), // changes position of shadow
                                  ),
                                ],
                                borderRadius: BorderRadius.only(
                                  topLeft:
                                      Radius.circular(SizeConstants.s1 * 20),
                                  topRight:
                                      Radius.circular(SizeConstants.s1 * 20),
                                ),
                              ),
                              child: Column(children: [
                                Center(
                                  child: Text(
                                    AppConstants.mWordConstants
                                        .sEnterYourVerificationCode,
                                    style: getTextRegular(
                                        size: SizeConstants.s_14,
                                        colors: Colors.grey.shade400),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: SizeConstants.s_50,
                                      right: SizeConstants.s_50,
                                      top: SizeConstants.s_20,
                                      bottom: SizeConstants.s_30),
                                  child: OTPTextField(
                                    controller: _controllerMobileNumberOtp,
                                    onChanged: ((pin) {
                                      setState(() {
                                        sOtpPin = pin;
                                      });
                                    }),
                                    length: 4,
                                    width: MediaQuery.of(context).size.width,
                                    fieldWidth: SizeConstants.s1*43,
                                    contentPadding: EdgeInsets.only(left:SizeConstants.s4,top: SizeConstants.s_15,bottom: SizeConstants.s_15),
                                    style: TextStyle(
                                        fontSize: SizeConstants.s_18,
                                        color: ColorConstants.cBlack),
                                    textFieldAlignment:
                                        MainAxisAlignment.spaceAround,
                                    fieldStyle: FieldStyle.box,
                                    onCompleted: (pin) {
                                      sOtpPin = pin;
                                      _initLoginMobileNumberOtpScreen(sOtpPin);
                                    },
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(
                                      left: SizeConstants.s_30 * 2,
                                      right: SizeConstants.s_30 * 2,
                                      top: SizeConstants.s_10,
                                      bottom: SizeConstants.s_30),
                                  child: rectangleRoundedCornerButton(
                                      appbarActionInterface: (value) {
                                        // _initLoginMobileNumberScreen();
                                        if (sOtpPin.length == 4) {
                                          _initLoginMobileNumberOtpScreen(
                                              sOtpPin);
                                        } else {
                                          AppAlert.showSnackBar(
                                            context,
                                            AppConstants.mWordConstants
                                                .sPleaseEnterTheValidPhoneNumberOtp,
                                          );
                                        }
                                      },
                                      sButtonTitle: AppConstants
                                          .mWordConstants.sVerifyNow,
                                      cButtonBackGroundColor:
                                          sOtpPin.length == 4
                                              ? ColorConstants
                                                  .kPrimaryColor.shade600
                                              : ColorConstants
                                                  .kPrimaryColor.shade300,
                                      cButtonTextColor: ColorConstants.cWhite,
                                      dButtonTextSize: SizeConstants.s_16,
                                      cButtonBorderColor: sOtpPin.length == 4
                                          ? ColorConstants
                                              .kPrimaryColor.shade600
                                          : ColorConstants
                                              .kPrimaryColor.shade300,
                                      dButtonWidth: SizeConstants.width * 0.35),
                                ),
                                // Text(
                                //   AppConstants
                                //       .mWordConstants.sDidntYouReceiveAnyCode,
                                //   textAlign: TextAlign.center,
                                //   style: getTextLight(
                                //       size: SizeConstants.s_12,
                                //       colors: Colors.grey.shade500),
                                // ),
                                SizedBox(
                                  height: SizeConstants.s4,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _initLoginMobileNumberScreen();
                                  },
                                  child: Text(
                                    AppConstants.mWordConstants.sDidntYouReceiveAnyCode,
                                    textAlign: TextAlign.center,
                                    style: getTextMedium(
                                        size: SizeConstants.s_14,
                                        colors: ColorConstants
                                            .kPrimaryColor.shade600),
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                  alignment: Alignment.bottomCenter,
                                  padding: EdgeInsets.only(
                                      left: SizeConstants.s_30,
                                      right: SizeConstants.s_30,
                                      bottom: SizeConstants.s_30),
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: AppConstants
                                          .mWordConstants.sBelowText,
                                      style: getTextLight(
                                          size: SizeConstants.s_14,
                                          colors: Colors.grey.shade500),
                                      /*defining default style is optional */
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'Terms',
                                            style: getTextRegular(
                                                size: SizeConstants.s_14,
                                                colors: ColorConstants
                                                    .kPrimaryColor.shade600,
                                                mTextDecoration: TextDecoration.underline)),
                                        const TextSpan(
                                          text: ' and ',
                                        ),
                                        TextSpan(
                                            text: 'Privacy policy',
                                            style: getTextRegular(
                                                size: SizeConstants.s_14,
                                                colors: ColorConstants
                                                    .kPrimaryColor.shade600,
                                                mTextDecoration: TextDecoration.underline)),

                                      ],
                                    ),
                                  ),
                                )),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: SizeConstants.s_30,
                                      right: SizeConstants.s_30,
                                      bottom: SizeConstants.s_20),
                                  height: SizeConstants.s1,
                                  color: ColorConstants.cDividerColor,
                                ),
                              ])))
                    ]))))
      ]),
    ));
  }

  _fLoginMobileNumberScreenOtpBlocListener(
      BuildContext context, LoginMobileNumberOtpScreenState state) {
    switch (state.status) {
      case LoginMobileNumberOtpScreenStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case LoginMobileNumberOtpScreenStatus.failed:
        AppAlert.closeDialog(context);
        if (state.webResponseFailed != null) {
          AppAlert.showSnackBar(
              context, state.webResponseFailed!.statusMessage ?? "");
        } else {
          AppAlert.showSnackBar(
            context,
            MessageConstants.wSomethingWentWrong,
          );
        }
        break;
      case LoginMobileNumberOtpScreenStatus.success:
        AppAlert.closeDialog(context);
        if (state.mLoginMobileNumberOtpScreenResponse!.token
                .toString()
                .toLowerCase() !=
            "null") {
          if (state.mLoginMobileNumberOtpScreenResponse!.member
                  .toString()
                  .toLowerCase() !=
              "null") {

            AppAlert.showSuccess(
              context,
              state.mLoginMobileNumberOtpScreenResponse!.message.toString(),
            ).then((value) async {
              Navigator.pushNamedAndRemoveUntil(
                context,
                RouteConstants.rHomeScreenWidget,
                    (route) => false,
              );
            });

          } else {
            // Navigator.pushNamed(
            //     context, RouteConstants.rRegisterProfileScreenWidget);
          }
        } else {
          AppAlert.showError(
            context,
            state.mLoginMobileNumberOtpScreenResponse!.message.toString(),
          );
        }
        break;
    }
  }

  _fLoginMobileNumberScreenBlocListener(
      BuildContext context, LoginMobileNumberScreenState state) {
    switch (state.status) {
      case LoginMobileNumberScreenStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case LoginMobileNumberScreenStatus.failed:
        AppAlert.closeDialog(context);
        if (state.webResponseFailed != null) {
          AppAlert.showSnackBar(
              context, state.webResponseFailed!.statusMessage ?? "");
        } else {
          AppAlert.showSnackBar(
            context,
            MessageConstants.wSomethingWentWrong,
          );
        }
        break;
      case LoginMobileNumberScreenStatus.success:
        AppAlert.closeDialog(context);
        break;
    }
  }
}
