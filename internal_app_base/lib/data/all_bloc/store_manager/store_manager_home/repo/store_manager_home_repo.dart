import 'dart:convert';

import 'package:internal_base/data/all_bloc/promoter/get_promoter_home/repo/get_promoter_home_response.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_home/repo/store_manager_home_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_common_response.dart';
import 'package:internal_base/data/remote/web_constants.dart';
import 'package:internal_base/data/remote/web_response_error_message.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';

class GetStoreManagerHomeRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  dynamic returnResponse;

  GetStoreManagerHomeRepository({required this.webservice, required this.sharedPrefs});

  Future<dynamic> fetchGetStoreManagerHome(dynamic mGetStoreManagerHomeRequest) async {
    final response = await webservice
        .getWithAuthAndClassQueryRequest(WebConstants.actionGetStoreManagerHome,mGetStoreManagerHomeRequest);

    try {
      WebCommonResponse mWebCommonResponse =
          WebCommonResponse.fromJson(response);
      if (mWebCommonResponse.statusCode.toString() == "200") {
        GetStoreManagerHomeResponse dashboardResponse =
        GetStoreManagerHomeResponse.fromJson(json.decode(mWebCommonResponse.data));
        returnResponse = dashboardResponse;
      }else{
        WebResponseErrorMessage mWebResponseErrorMessage =
        WebResponseErrorMessage.fromJson(json.decode(mWebCommonResponse.data));

        WebResponseFailed mWebResponseFailed = WebResponseFailed();
        mWebResponseFailed.setMessage(mWebResponseErrorMessage.message??"Sorry, Home details does not exist.");
        returnResponse = mWebResponseFailed;
      }
    } catch (e) {
      WebResponseFailed mWebResponseFailed = WebResponseFailed();
      mWebResponseFailed.setMessage("Sorry, Home details does not exist.${e.toString()}");
      returnResponse = mWebResponseFailed;
    }

    return returnResponse;
  }
}
