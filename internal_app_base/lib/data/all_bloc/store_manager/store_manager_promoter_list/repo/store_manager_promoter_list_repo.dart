import 'dart:convert';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_promoter_list/repo/store_manager_promoter_list_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_common_response.dart';
import 'package:internal_base/data/remote/web_constants.dart';
import 'package:internal_base/data/remote/web_response_error_message.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';

class GetStoreManagerPromoterListRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  dynamic returnResponse;

  GetStoreManagerPromoterListRepository(
      {required this.webservice, required this.sharedPrefs});

  Future<dynamic> fetchGetStoreManagerPromoterList(
      dynamic mStringRequest) async {
    final response = await webservice.getWithAuthAndClassQueryRequest(
        WebConstants.actionGetStoreManagerPromoterList, mStringRequest);

    try {
      WebCommonResponse mWebCommonResponse =
          WebCommonResponse.fromJson(response);
      if (mWebCommonResponse.statusCode.toString() == "200") {
        GetStoreManagerPromoterListResponse promoterListResponse =
            GetStoreManagerPromoterListResponse.fromJson(
                json.decode(mWebCommonResponse.data));
        returnResponse = promoterListResponse;
      } else {
        WebResponseErrorMessage mWebResponseErrorMessage =
            WebResponseErrorMessage.fromJson(
                json.decode(mWebCommonResponse.data));

        WebResponseFailed mWebResponseFailed = WebResponseFailed();
        mWebResponseFailed.setMessage(mWebResponseErrorMessage.message ??
            "Sorry, promoter list does not exist.");
        returnResponse = mWebResponseFailed;
      }
    } catch (e) {
      WebResponseFailed mWebResponseFailed = WebResponseFailed();
      mWebResponseFailed.setMessage("Sorry, promoter list does not exist.");
      returnResponse = mWebResponseFailed;
    }

    return returnResponse;
  }
}
