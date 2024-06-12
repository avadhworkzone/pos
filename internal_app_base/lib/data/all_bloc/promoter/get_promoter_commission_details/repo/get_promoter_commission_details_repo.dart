import 'dart:convert';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_commission_details/repo/get_promoter_commission_details_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_common_response.dart';
import 'package:internal_base/data/remote/web_constants.dart';
import 'package:internal_base/data/remote/web_response_error_message.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';

class GetPromoterCommissionDetailsRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  dynamic returnResponse;

  GetPromoterCommissionDetailsRepository(
      {required this.webservice, required this.sharedPrefs});

  Future<dynamic> fetchGetPromoterCommissionDetails(
      dynamic mGetPromoterCommissionDetailsRequest) async {
    final response = await webservice.getWithAuthAndStringRequest(
        WebConstants.actionGetPromoterCommissionDetails,
        mGetPromoterCommissionDetailsRequest);

    try {
      WebCommonResponse mWebCommonResponse =
          WebCommonResponse.fromJson(response);
      if (mWebCommonResponse.statusCode.toString() == "200") {
        GetPromoterCommissionDetailsResponse dashboardResponse =
            GetPromoterCommissionDetailsResponse.fromJson(
                json.decode(mWebCommonResponse.data));
        returnResponse = dashboardResponse;
      } else {
        WebResponseErrorMessage mWebResponseErrorMessage =
            WebResponseErrorMessage.fromJson(
                json.decode(mWebCommonResponse.data));

        WebResponseFailed mWebResponseFailed = WebResponseFailed();
        mWebResponseFailed.setMessage(mWebResponseErrorMessage.message ??
            "Sorry, commission details does not exist.");
        returnResponse = mWebResponseFailed;
      }
    } catch (e) {
      WebResponseFailed mWebResponseFailed = WebResponseFailed();
      mWebResponseFailed
          .setMessage("Sorry, commission details does not exist.");
      returnResponse = mWebResponseFailed;
    }

    return returnResponse;
  }
}
