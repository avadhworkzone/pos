import 'dart:convert';

import 'package:internal_base/data/all_bloc/store_manager/store_manager_login/repo/store_manager_login_screen_response.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_login/repo/store_manager_login_screen_response_unsuccess.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_common_response.dart';
import 'package:internal_base/data/remote/web_constants.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';

class StoreManagerLoginScreenRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  dynamic returnResponse;

  StoreManagerLoginScreenRepository(
      {required this.webservice, required this.sharedPrefs});

  Future<dynamic> fetchStoreManagerLoginScreen(
      dynamic mStoreManagerLoginScreenListRequest) async {
    final response = await webservice.postWithRequestWithoutAuth(
        WebConstants.actionStoreManagerLoginScreen,
        mStoreManagerLoginScreenListRequest);
    try {
      WebCommonResponse mWebCommonResponse =
          WebCommonResponse.fromJson(response);
      if (mWebCommonResponse.statusCode.toString() == "200") {
        StoreManagerLoginScreenResponse dashboardResponse =
            StoreManagerLoginScreenResponse.fromJson(json.decode(mWebCommonResponse.data));

        await sharedPrefs.setUserToken(
            dashboardResponse.accessToken.toString().toLowerCase() == "null"
                ? ""
                : dashboardResponse.accessToken.toString());

        await sharedPrefs.setUserTokenType(
            dashboardResponse.accessToken.toString().toLowerCase() == "null"
                ? ""
                : "StoreManagerLogin");

        returnResponse = dashboardResponse;
      }else{
        StoreManagerLoginScreenResponseUnSuccess dashboardResponse =
        StoreManagerLoginScreenResponseUnSuccess.fromJson(json.decode(mWebCommonResponse.data));
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
