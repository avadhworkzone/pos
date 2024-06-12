import 'dart:convert';

import 'package:internal_base/data/all_bloc/promoter/post_promoter_profile_update/repo/post_promoter_profile_update_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_common_response.dart';
import 'package:internal_base/data/remote/web_constants.dart';
import 'package:internal_base/data/remote/web_response_error_message.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';

class PostPromoterProfileUpdateRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  dynamic returnResponse;


  PostPromoterProfileUpdateRepository(
      {required this.webservice, required this.sharedPrefs});
  Future<dynamic> fetchPostPromoterProfileUpdate(
      dynamic mPostPromoterProfileUpdateListRequest) async {
    final response = await webservice.postWithAuthAndRequest(
        WebConstants.actionPostPromoteProfileUpdate,
        mPostPromoterProfileUpdateListRequest);
    try {
      WebCommonResponse mWebCommonResponse =
          WebCommonResponse.fromJson(response);
      if (mWebCommonResponse.statusCode.toString() == "200") {
        PostPromoterProfileUpdateResponse mWebResponseErrorMessage =
        PostPromoterProfileUpdateResponse.fromJson(json.decode(mWebCommonResponse.data));
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
