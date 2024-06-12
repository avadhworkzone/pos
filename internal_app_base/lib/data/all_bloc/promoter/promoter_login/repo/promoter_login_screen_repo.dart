import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:internal_base/data/all_bloc/promoter/promoter_login/repo/promoter_login_screen_response.dart';
import 'package:internal_base/data/all_bloc/promoter/promoter_login/repo/promoter_login_screen_response_unsuccess.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_common_response.dart';
import 'package:internal_base/data/remote/web_constants.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';

class PromoterLoginScreenRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  dynamic returnResponse;

  PromoterLoginScreenRepository(
      {required this.webservice, required this.sharedPrefs});

  Future<dynamic> fetchPromoterLoginScreen(
      dynamic mPromoterLoginScreenListRequest) async {
    final response = await webservice.postWithRequestWithoutAuth(
        WebConstants.actionPromoterLoginScreen,
        mPromoterLoginScreenListRequest);
    try {
      WebCommonResponse mWebCommonResponse =
          WebCommonResponse.fromJson(response);
      if (mWebCommonResponse.statusCode.toString() == "200") {
        PromoterLoginScreenResponse dashboardResponse =
            PromoterLoginScreenResponse.fromJson(json.decode(mWebCommonResponse.data));

        await sharedPrefs.setUserToken(
            dashboardResponse.accessToken.toString().toLowerCase() == "null"
                ? ""
                : dashboardResponse.accessToken.toString());

        await sharedPrefs.setUserTokenType(
            dashboardResponse.accessToken.toString().toLowerCase() == "null"
                ? ""
                : "PromoterLogin");

        returnResponse = dashboardResponse;
      }else{
        PromoterLoginScreenResponseUnSuccess dashboardResponse =
        PromoterLoginScreenResponseUnSuccess.fromJson(json.decode(mWebCommonResponse.data));
        WebResponseFailed mWebResponseFailed = WebResponseFailed();
        mWebResponseFailed.setMessage(dashboardResponse.message??"");
        returnResponse = mWebResponseFailed;
      }
    } catch (e) {
      WebResponseFailed mWebResponseFailed = WebResponseFailed();
      mWebResponseFailed.setMessage("Sorry, member does not exist.");
      returnResponse = mWebResponseFailed;
    }

    return returnResponse;
  }
}
