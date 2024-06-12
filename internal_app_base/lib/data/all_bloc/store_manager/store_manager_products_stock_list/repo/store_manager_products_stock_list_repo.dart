import 'dart:convert';

import 'package:internal_base/data/all_bloc/store_manager/store_manager_products_stock_list/repo/store_manager_products_stock_list_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_common_response.dart';
import 'package:internal_base/data/remote/web_constants.dart';
import 'package:internal_base/data/remote/web_response_error_message.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';

class GetStoreManagerProductsStockListRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  dynamic returnResponse;

  GetStoreManagerProductsStockListRepository(
      {required this.webservice, required this.sharedPrefs});

  Future<dynamic> fetchGetStoreManagerProductsStockList(
      dynamic mGetStoreManagerProductsStockListRequest, dynamic mStringRequest) async {
    final response = await webservice.getWithAuthAndQueryAndStringRequest(
        WebConstants.actionGetStoreManagerProductsStockList,
        mGetStoreManagerProductsStockListRequest,mStringRequest);

    try {
      WebCommonResponse mWebCommonResponse =
      WebCommonResponse.fromJson(response);
      if (mWebCommonResponse.statusCode.toString() == "200") {
        GetStoreManagerProductsStockListResponse dashboardResponse =
        GetStoreManagerProductsStockListResponse.fromJson(json.decode(mWebCommonResponse.data));
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
