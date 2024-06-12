import 'dart:convert';

import 'package:internal_base/data/all_bloc/warehouse_manager/warehouses/repo/get_warehouses_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_common_response.dart';
import 'package:internal_base/data/remote/web_constants.dart';
import 'package:internal_base/data/remote/web_response_error_message.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';

class GetWarehousesRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  dynamic returnResponse;

  GetWarehousesRepository(
      {required this.webservice, required this.sharedPrefs});

  Future<dynamic> fetchGetWarehouses() async {
    final response = await webservice
        .getWithAuthWithoutRequest(WebConstants.actionGetWarehousesList);

    try {
      WebCommonResponse mWebCommonResponse =
          WebCommonResponse.fromJson(response);
      if (mWebCommonResponse.statusCode.toString() == "200") {
        GetWarehousesResponse dashboardResponse =
            GetWarehousesResponse.fromJson(
                json.decode(mWebCommonResponse.data));
        returnResponse = dashboardResponse;
      } else {
        WebResponseErrorMessage mWebResponseErrorMessage =
            WebResponseErrorMessage.fromJson(
                json.decode(mWebCommonResponse.data));

        WebResponseFailed mWebResponseFailed = WebResponseFailed();
        mWebResponseFailed.setMessage(mWebResponseErrorMessage.message ??
            "Sorry, Stores list does not exist.");
        returnResponse = mWebResponseFailed;
      }
    } catch (e) {
      WebResponseFailed mWebResponseFailed = WebResponseFailed();
      mWebResponseFailed.setMessage("Sorry, Stores list does not exist.");
      returnResponse = mWebResponseFailed;
    }

    return returnResponse;
  }
}
