
import 'package:flutter/material.dart';
import 'package:member_app/data/all_bloc/profile_pic_upload/repo/profile_pic_update_response.dart';
import 'package:member_app/data/local/shared_prefs/shared_prefs.dart';
import 'package:member_app/data/remote/web_common_response.dart';
import 'package:member_app/data/remote/web_constants.dart';
import 'package:member_app/data/remote/web_response_failed.dart';
import 'package:member_app/data/remote/web_service.dart';

class ProfilePicUpdateRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  dynamic returnResponse;

  ProfilePicUpdateRepository(
      {required this.webservice, required this.sharedPrefs});

  Future<dynamic> fetchProfilePicUpdate(dynamic mProfilePicUpdateListRequest) async {
    final response = await webservice.postWithAuthAndRequestAndAttachment(
        WebConstants.actionUploadProfilePic, mProfilePicUpdateListRequest);


    try {
      WebCommonResponse mWebCommonResponse =
      WebCommonResponse.fromJson(response);
      if (mWebCommonResponse.statusCode.toString() == "200") {
        ProfilePicUpdateResponse dashboardResponse =
        ProfilePicUpdateResponse(message: "Profile update success full");
        returnResponse = dashboardResponse;
      }else{
        WebResponseFailed dashboardResponse = WebResponseFailed ();
        returnResponse = dashboardResponse;
      }
    } catch (e) {
      WebResponseFailed dashboardResponse = WebResponseFailed ();
      returnResponse = dashboardResponse;
    }

    return returnResponse;
  }
}
