import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:member_app/common/alert/app_alert.dart';
import 'package:member_app/common/app_constants.dart';
import 'package:member_app/common/appbars_constants.dart';
import 'package:member_app/common/button_constants.dart';
import 'package:member_app/common/color_constants.dart';
import 'package:member_app/common/image_assets.dart';
import 'package:member_app/common/message_constants.dart';
import 'package:member_app/common/size_constants.dart';
import 'package:member_app/common/text_styles_constants.dart';
import 'package:member_app/common/utils/network_utils.dart';
import 'package:member_app/common/widget/app_bar_bottom_view.dart';
import 'package:member_app/common/widget/edit_text_field.dart';
import 'package:member_app/data/all_bloc/login_mobile_number_bloc/bloc/login_mobile_number_screen_bloc.dart';
import 'package:member_app/data/all_bloc/login_mobile_number_bloc/bloc/login_mobile_number_screen_event.dart';
import 'package:member_app/data/all_bloc/login_mobile_number_bloc/bloc/login_mobile_number_screen_state.dart';
import 'package:member_app/data/all_bloc/login_mobile_number_bloc/repo/login_mobile_number_screen_request.dart';
import 'package:member_app/routes/route_constants.dart';

class LoginMobileNumberScreenWidget extends StatefulWidget {
  const LoginMobileNumberScreenWidget({super.key});

  @override
  State<LoginMobileNumberScreenWidget> createState() =>
      _LoginMobileNumberScreenWidgetState();
}

class _LoginMobileNumberScreenWidgetState
    extends State<LoginMobileNumberScreenWidget> {
  late LoginMobileNumberScreenBloc _mLoginMobileNumberScreenBloc;
  final TextEditingController _controllerMobileNumber = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mLoginMobileNumberScreenBloc = LoginMobileNumberScreenBloc();
  }

  Future<void> _initLoginMobileNumberScreen(String sMobileNumber) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _mLoginMobileNumberScreenBloc.add(LoginMobileNumberScreenClickEvent(
            mLoginMobileNumberScreenListRequest:
                LoginMobileNumberScreenRequest(mobileNumber: sMobileNumber)));
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
          AppConstants.mWordConstants.sLogin
      ),
      body: BlocConsumer<LoginMobileNumberScreenBloc,
          LoginMobileNumberScreenState>(
        bloc: _mLoginMobileNumberScreenBloc,
        builder: (context, state) {
          return _fLoginMobileNumberScreenViewBuilder(context, state);
        },
        listener: _fLoginMobileNumberScreenBlocListener,
      ),
    );
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
        if(state.mLoginMobileNumberScreenResponse!.status!) {
          AppAlert.showSuccess(
            context,
            state.mLoginMobileNumberScreenResponse!.message.toString(),
          ).then((value) async {
            Navigator.pushNamed(
                context, RouteConstants.rLoginMobileNumberOtpScreenWidget,
                arguments: _controllerMobileNumber.text);
          });
        }else {
          AppAlert.showSuccess(
            context,
            state.mLoginMobileNumberScreenResponse!.message.toString(),
          ).then((value) async {
          });
        }

        break;
    }
  }

  Widget _fLoginMobileNumberScreenViewBuilder(
      BuildContext context, LoginMobileNumberScreenState state) {
    return _buildLoginMobileNumberView();
  }

  _buildLoginMobileNumberView() {
    return FocusDetector(
        child: SafeArea(
            child: Column(
      children: [
        // appBarBottomViewWithTextBack(
        //     AppConstants.mWordConstants.sLogin, context),
        Expanded(
            child: SingleChildScrollView(
                child: SizedBox(
          width: double.infinity,
          height: SizeConstants.height * 0.885,
          child: Column(children: [
            Container(
              margin: EdgeInsets.only(
                  top: SizeConstants.s1*40, bottom: SizeConstants.s_20),
              padding: EdgeInsets.all(SizeConstants.s_16),
              child: Image.asset(ImageAssets.imageLogin,
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
                  topLeft: Radius.circular(SizeConstants.s1 * 20),
                  topRight: Radius.circular(SizeConstants.s1 * 20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            left: SizeConstants.s_20, right: SizeConstants.s_20),
                        child: editTextMobileNumber(
                          _controllerMobileNumber,
                              (value) {
                            setState(() {
                              if (_controllerMobileNumber.text.length > 11) {
                                _initLoginMobileNumberScreen(_controllerMobileNumber.text);
                              }
                            });
                          },
                          labelText: AppConstants.mWordConstants.sWhatIsYourPhoneNumber,
                          hintText:
                          AppConstants
                              .mWordConstants.sEnterPhoneNumber,
                          mIcons: Icons.phone,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: SizeConstants.s_30,
                          right: SizeConstants.s_30,
                          top: SizeConstants.s_10,
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                              _controllerMobileNumber.text.isEmpty
                                  ? ""
                                  : "${_controllerMobileNumber.text.length}/12",
                              style: getTextRegular(
                                  size: SizeConstants.s_15,
                                  colors: ColorConstants.kPrimaryColor)),
                        ),
                      ),
                      SizedBox(height: SizeConstants.s_32,),
                      Center(
                        child: rectangleRoundedCornerButton(
                            appbarActionInterface: (value) {
                              if (_controllerMobileNumber.text.toString().length >=
                                  10) {
                                _initLoginMobileNumberScreen(
                                    _controllerMobileNumber.text.toString());
                              } else {
                                AppAlert.showSnackBar(
                                  context,
                                  AppConstants.mWordConstants
                                      .sPleaseEnterTheValidPhoneNumber,
                                );
                              }
                            },
                            sButtonTitle: AppConstants.mWordConstants.sSendOTP,
                            cButtonBackGroundColor:
                            ColorConstants.kPrimaryColor.shade600,
                            cButtonTextColor: ColorConstants.cWhite,
                            dButtonTextSize: SizeConstants.s_16,
                            cButtonBorderColor:
                            ColorConstants.kPrimaryColor.shade600,
                            dButtonWidth: SizeConstants.width * 0.35),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      Container(
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.only(
                            left: SizeConstants.s1*36,
                            right: SizeConstants.s1*36,
                            bottom: SizeConstants.s_20),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: AppConstants.mWordConstants.sBelowText,
                            style: getTextLight(
                                size: SizeConstants.s_14,
                                colors: Colors.grey.shade500),
                            /*defining default style is optional */
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Terms',
                                  style: getTextRegular(
                                      size: SizeConstants.s_14,
                                      colors:
                                      ColorConstants.kPrimaryColor.shade600,
                                      mTextDecoration: TextDecoration.underline)),
                              const TextSpan(
                                text: ' and ',
                              ),
                              TextSpan(
                                  text: 'Privacy Policy.',
                                  style: getTextRegular(
                                      size: SizeConstants.s_14,
                                      colors:
                                      ColorConstants.kPrimaryColor.shade600,
                                      mTextDecoration: TextDecoration.underline )),

                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: SizeConstants.s1*36,
                            right: SizeConstants.s1*36,
                            bottom: SizeConstants.s_20),
                        height: SizeConstants.s1,
                        color: ColorConstants.cDividerColor,
                      ),
                    ],
                  )

                ],
              ),
            )),
          ]),
        ))),
      ],
    )));
  }
}
