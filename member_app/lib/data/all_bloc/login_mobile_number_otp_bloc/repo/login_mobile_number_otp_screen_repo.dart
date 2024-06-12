import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:member_app/data/all_bloc/login_mobile_number_otp_bloc/repo/login_mobile_number_otp_screen_response.dart';
import 'package:member_app/data/local/shared_prefs/shared_prefs.dart';
import 'package:member_app/data/remote/web_common_response.dart';
import 'package:member_app/data/remote/web_constants.dart';
import 'package:member_app/data/remote/web_response_failed.dart';
import 'package:member_app/data/remote/web_service.dart';

class LoginMobileNumberOtpScreenRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  dynamic returnResponse;

  LoginMobileNumberOtpScreenRepository(
      {required this.webservice, required this.sharedPrefs});

  Future<dynamic> fetchLoginMobileNumberOtpScreen(
      dynamic mLoginMobileNumberOtpScreenListRequest) async {
    final response = await webservice.postWithRequestWithoutAuth(
        WebConstants.actionLoginMobileNumberOtpScreen,
        mLoginMobileNumberOtpScreenListRequest);
    try {
      WebCommonResponse mWebCommonResponse =
      WebCommonResponse.fromJson(response);
      if (mWebCommonResponse.statusCode == "200") {
        LoginMobileNumberOtpScreenResponse dashboardResponse =
        LoginMobileNumberOtpScreenResponse.fromJson(json.decode(mWebCommonResponse.data));
        await sharedPrefs.setUserToken(
            dashboardResponse.token.toString().toLowerCase() == "null"
                ? ""
                : dashboardResponse.token.toString());
        returnResponse = dashboardResponse;
      }else{
        WebResponseFailed dashboardResponse = WebResponseFailed ();
        returnResponse = dashboardResponse;
      }
    } catch (e) {
      WebResponseFailed dashboardResponse = WebResponseFailed ();
      returnResponse = dashboardResponse;
    }

    return returnResponse;
  }
}
