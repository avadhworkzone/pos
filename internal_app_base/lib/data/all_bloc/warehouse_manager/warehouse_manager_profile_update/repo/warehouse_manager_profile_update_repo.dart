import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_profile_update/repo/warehouse_manager_profile_update_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_common_response.dart';
import 'package:internal_base/data/remote/web_constants.dart';
import 'package:internal_base/data/remote/web_response_error_message.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';

class PostWarehouseManagerProfileUpdateRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  dynamic returnResponse;


  PostWarehouseManagerProfileUpdateRepository(
      {required this.webservice, required this.sharedPrefs});
  Future<dynamic> fetchPostWarehouseManagerProfileUpdate(
      dynamic mPostWarehouseManagerProfileUpdateListRequest) async {
    final response = await webservice.postWithAuthAndRequest(
        WebConstants.actionPostWarehouseManagerProfileUpdate,
        mPostWarehouseManagerProfileUpdateListRequest);
    try {
      WebCommonResponse mWebCommonResponse =
          WebCommonResponse.fromJson(response);
      if (mWebCommonResponse.statusCode.toString() == "200") {
        PostWarehouseManagerProfileUpdateResponse mWebResponseErrorMessage = PostWarehouseManagerProfileUpdateResponse(statusMessage: mWebCommonResponse.data.toString());
        // PostWarehouseManagerProfileUpdateResponse mWebResponseErrorMessage =
        // PostWarehouseManagerProfileUpdateResponse.fromJson(json.decode(mWebCommonResponse.data));
        debugPrint("krishna response2 - ${mWebCommonResponse.data.toString()}");
        returnResponse = mWebResponseErrorMessage;
      } else {
        WebResponseErrorMessage mWebResponseErrorMessage =
            WebResponseErrorMessage.fromJson(
                json.decode(mWebCommonResponse.data));

        WebResponseFailed mWebResponseFailed = WebResponseFailed();
        mWebResponseFailed.setMessage(
            mWebResponseErrorMessage.message ?? "Sorry, something went wrong.");
        returnResponse = mWebResponseFailed;
      }
    } catch (e) {
      WebResponseFailed mWebResponseFailed = WebResponseFailed();
      mWebResponseFailed.setMessage("Sorry, something went wrong.");
      returnResponse = mWebResponseFailed;
    }

    return returnResponse;
  }
}
