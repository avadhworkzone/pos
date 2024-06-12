import 'dart:convert';

import 'package:internal_base/data/all_bloc/promoter/get_promoter_products_list/repo/get_promoter_products_list_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_common_response.dart';
import 'package:internal_base/data/remote/web_constants.dart';
import 'package:internal_base/data/remote/web_response_error_message.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';

class GetPromoterProductsListRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  dynamic returnResponse;

  GetPromoterProductsListRepository(
      {required this.webservice, required this.sharedPrefs});

  Future<dynamic> fetchGetPromoterProductsList(
      dynamic mGetPromoterProductsListRequest) async {
    final response = await webservice.getWithAuthAndClassQueryRequest(
        WebConstants.actionGetPromoterProductsList,
        mGetPromoterProductsListRequest);

    try {
      WebCommonResponse mWebCommonResponse =
      WebCommonResponse.fromJson(response);
      if (mWebCommonResponse.statusCode.toString() == "200") {
        GetPromoterProductsListResponse dashboardResponse =
        GetPromoterProductsListResponse.fromJson(json.decode(mWebCommonResponse.data));
        returnResponse = dashboardResponse;
      }else{

        WebResponseErrorMessage mWebResponseErrorMessage =
        WebResponseErrorMessage.fromJson(json.decode(mWebCommonResponse.data));

        WebResponseFailed mWebResponseFailed = WebResponseFailed();
        mWebResponseFailed.setMessage(mWebResponseErrorMessage.message??"Sorry, Products list does not exist.");
        returnResponse = mWebResponseFailed;
      }
    } catch (e) {
      WebResponseFailed mWebResponseFailed = WebResponseFailed();
      mWebResponseFailed.setMessage("Sorry, Products list does not exist.");
      returnResponse = mWebResponseFailed;
    }

    return returnResponse;
  }
}
