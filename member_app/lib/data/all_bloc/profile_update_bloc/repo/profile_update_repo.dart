import 'dart:convert';

import 'package:flutter/rendering.dart';
import 'package:member_app/data/all_bloc/profile_update_bloc/repo/profile_update_response.dart';
import 'package:member_app/data/local/shared_prefs/shared_prefs.dart';
import 'package:member_app/data/remote/web_common_response.dart';
import 'package:member_app/data/remote/web_constants.dart';
import 'package:member_app/data/remote/web_response_success.dart';
import 'package:member_app/data/remote/web_service.dart';

class ProfileUpdateRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  dynamic returnResponse;

  ProfileUpdateRepository(
      {required this.webservice, required this.sharedPrefs});

  Future<dynamic> fetchProfileUpdate(dynamic mProfileUpdateListRequest) async {
    final response = await webservice.postWithAuthAndRequest(
        WebConstants.actionProfileUpdate, mProfileUpdateListRequest);

    ProfileUpdateResponse dashboardResponse;

    try {
      WebCommonResponse mWebCommonResponse =
          WebCommonResponse.fromJson(response);
      if (mWebCommonResponse.statusCode == "200") {
        dashboardResponse = ProfileUpdateResponse(
            message: "Your profile is updated successfully", status: true);
      } else {
        dashboardResponse =
            ProfileUpdateResponse.fromJson(json.decode(mWebCommonResponse.data));
        dashboardResponse.status = false;
      }
    } catch (e) {
      dashboardResponse = ProfileUpdateResponse(
          message: "Your profile is updated unsuccessfully", status: false);
    }

    returnResponse = dashboardResponse;

    return returnResponse;
  }
}
