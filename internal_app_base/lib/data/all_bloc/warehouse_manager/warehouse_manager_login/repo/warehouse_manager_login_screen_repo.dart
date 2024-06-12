import 'dart:convert';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_login/repo/warehouse_manager_login_screen_response.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_login/repo/warehouse_manager_login_screen_response_unsuccess.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_common_response.dart';
import 'package:internal_base/data/remote/web_constants.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';

class WarehouseManagerLoginScreenRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  dynamic returnResponse;

  WarehouseManagerLoginScreenRepository(
      {required this.webservice, required this.sharedPrefs});

  Future<dynamic> fetchWarehouseManagerLoginScreen(
      dynamic mWarehouseManagerLoginScreenListRequest) async {
    final response = await webservice.postWithRequestWithoutAuth(
        WebConstants.actionWarehouseManagerLoginScreen,
        mWarehouseManagerLoginScreenListRequest);
    try {
      WebCommonResponse mWebCommonResponse =
          WebCommonResponse.fromJson(response);
      if (mWebCommonResponse.statusCode.toString() == "200") {
        WarehouseManagerLoginScreenResponse dashboardResponse =
            WarehouseManagerLoginScreenResponse.fromJson(json.decode(mWebCommonResponse.data));

        await sharedPrefs.setUserToken(
            dashboardResponse.accessToken.toString().toLowerCase() == "null"
                ? ""
                : dashboardResponse.accessToken.toString());

        await sharedPrefs.setUserTokenType(
            dashboardResponse.accessToken.toString().toLowerCase() == "null"
                ? ""
                : "WarehouseManagerLogin");

        returnResponse = dashboardResponse;
      }else{
        WarehouseManagerLoginScreenResponseUnSuccess dashboardResponse =
        WarehouseManagerLoginScreenResponseUnSuccess.fromJson(json.decode(mWebCommonResponse.data));
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
