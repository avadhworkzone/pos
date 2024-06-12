import 'dart:convert';

import 'package:internal_base/data/all_bloc/store_manager/store_manager_products_details/repo/store_manager_products_details_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_common_response.dart';
import 'package:internal_base/data/remote/web_constants.dart';
import 'package:internal_base/data/remote/web_response_error_message.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';

class GetStoreManagerProductsDetailsRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  dynamic returnResponse;

  GetStoreManagerProductsDetailsRepository({required this.webservice, required this.sharedPrefs});

  Future<dynamic> fetchGetStoreManagerProductsDetails(dynamic mGetStoreManagerProductsDetailsRequest) async {
    final response = await webservice
        .getWithAuthAndStringRequest(WebConstants.actionGetStoreManagerProductsDetails,mGetStoreManagerProductsDetailsRequest);

    try {
      WebCommonResponse mWebCommonResponse =
          WebCommonResponse.fromJson(response);
      if (mWebCommonResponse.statusCode.toString() == "200") {
        GetStoreManagerProductsDetailsResponse dashboardResponse =
            GetStoreManagerProductsDetailsResponse.fromJson(json.decode(mWebCommonResponse.data));
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
