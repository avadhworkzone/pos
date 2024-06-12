import 'dart:convert';

import 'package:internal_base/data/all_bloc/promoter/get_promoter_commission_list/repo/get_promoter_commission_list_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_common_response.dart';
import 'package:internal_base/data/remote/web_constants.dart';
import 'package:internal_base/data/remote/web_response_error_message.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';

class GetPromoterCommissionListRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  dynamic returnResponse;

  GetPromoterCommissionListRepository(
      {required this.webservice, required this.sharedPrefs});

  Future<dynamic> fetchGetPromoterCommissionList(
      dynamic mGetPromoterCommissionListRequest) async {
    final response = await webservice.getWithAuthAndClassQueryRequest(
        WebConstants.actionGetPromoterCommissionList,
        mGetPromoterCommissionListRequest);

    try {
      WebCommonResponse mWebCommonResponse =
          WebCommonResponse.fromJson(response);
      if (mWebCommonResponse.statusCode.toString() == "200") {
        GetPromoterCommissionListResponse dashboardResponse =
            GetPromoterCommissionListResponse.fromJson(
                json.decode(mWebCommonResponse.data));
        returnResponse = dashboardResponse;
      } else {
        WebResponseErrorMessage mWebResponseErrorMessage =
        WebResponseErrorMessage.fromJson(json.decode(mWebCommonResponse.data));

        WebResponseFailed mWebResponseFailed = WebResponseFailed();
        mWebResponseFailed.setMessage(mWebResponseErrorMessage.message??"Sorry, Products list does not exist.");
        returnResponse = mWebResponseFailed;
      }
    } catch (e) {
      WebResponseFailed mWebResponseFailed = WebResponseFailed();
      mWebResponseFailed
          .setMessage("Sorry, Commission History list does not exist.");
      returnResponse = mWebResponseFailed;
    }

    return returnResponse;
  }
}
