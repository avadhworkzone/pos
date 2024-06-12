import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:member_app/data/all_bloc/login_mobile_number_bloc/repo/login_mobile_number_screen_response_unsuccess.dart';
import 'package:member_app/data/local/shared_prefs/shared_prefs.dart';
import 'package:member_app/data/all_bloc/login_mobile_number_bloc/repo/login_mobile_number_screen_response.dart';
import 'package:member_app/data/remote/web_common_response.dart';
import 'package:member_app/data/remote/web_constants.dart';
import 'package:member_app/data/remote/web_service.dart';

class LoginMobileNumberScreenRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  dynamic returnResponse;

  LoginMobileNumberScreenRepository(
      {required this.webservice, required this.sharedPrefs});

  Future<dynamic> fetchLoginMobileNumberScreen(
      dynamic mLoginMobileNumberScreenListRequest) async {
    final response = await webservice.postWithRequestWithoutAuth(
        WebConstants.actionLoginMobileNumberScreen,
        mLoginMobileNumberScreenListRequest);
    try {
      WebCommonResponse mWebCommonResponse =
          WebCommonResponse.fromJson(response);
      if (mWebCommonResponse.statusCode.toString() == "200") {
        LoginMobileNumberScreenResponse dashboardResponse =
            LoginMobileNumberScreenResponse.fromJson(json.decode(mWebCommonResponse.data));
        returnResponse = dashboardResponse;
      }else{
        LoginMobileNumberScreenResponse dashboardResponse = LoginMobileNumberScreenResponse();
        dashboardResponse.message = "Sorry, member does not exist.";
        dashboardResponse.status = false;
        returnResponse = dashboardResponse;
      }
    } catch (e) {
      LoginMobileNumberScreenResponse dashboardResponse = LoginMobileNumberScreenResponse();
      dashboardResponse.message = "Sorry, member does not exist.";
      dashboardResponse.status = false;
      returnResponse = dashboardResponse;
    }

    return returnResponse;
  }
}
