import 'dart:convert';

import 'package:internal_base/data/all_bloc/promoter/get_promoter_home/repo/get_promoter_home_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_common_response.dart';
import 'package:internal_base/data/remote/web_constants.dart';
import 'package:internal_base/data/remote/web_response_error_message.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';

class GetPromoterHomeRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  dynamic returnResponse;

  GetPromoterHomeRepository({required this.webservice, required this.sharedPrefs});

  Future<dynamic> fetchGetPromoterHome(dynamic mGetPromoterHomeRequest) async {
    final response = await webservice
        .getWithAuthAndClassQueryRequest(WebConstants.actionGetPromoterHome,mGetPromoterHomeRequest);

    try {
      WebCommonResponse mWebCommonResponse =
          WebCommonResponse.fromJson(response);
      if (mWebCommonResponse.statusCode.toString() == "200") {
        GetPromoterHomeResponse dashboardResponse =
            GetPromoterHomeResponse.fromJson(json.decode(mWebCommonResponse.data));
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
      mWebResponseFailed.setMessage("Sorry, Home details does not exist.");
      returnResponse = mWebResponseFailed;
    }

    return returnResponse;
  }
}
