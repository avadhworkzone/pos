import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:member_app/data/all_bloc/get_members_details_bloc/repo/get_members_details_response.dart';
import 'package:member_app/data/local/shared_prefs/shared_prefs.dart';
import 'package:member_app/data/remote/web_common_response.dart';
import 'package:member_app/data/remote/web_constants.dart';
import 'package:member_app/data/remote/web_response_failed.dart';
import 'package:member_app/data/remote/web_service.dart';

class GetMemberDetailsRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  dynamic returnResponse;

  GetMemberDetailsRepository(
      {required this.webservice, required this.sharedPrefs});

  Future<dynamic> fetchGetMemberDetails() async {
    final response = await webservice.getWithAuthWithoutRequest(
        WebConstants.actionGetMembersDetails);

    try {
      WebCommonResponse mWebCommonResponse =
      WebCommonResponse.fromJson(response);
      if (mWebCommonResponse.statusCode.toString() == "200") {
        GetMemberDetailsResponse dashboardResponse =
        GetMemberDetailsResponse.fromJson(json.decode(mWebCommonResponse.data));
        returnResponse = dashboardResponse;

        await sharedPrefs.setMember(
            dashboardResponse.memberDetails.toString().toLowerCase() == "null"
                ? ""
                : jsonEncode(dashboardResponse.memberDetails).toString());

      }else {
        WebResponseFailed dashboardResponse =
        WebResponseFailed.fromJson(json.decode(mWebCommonResponse.data));
        returnResponse = dashboardResponse;
      }
    } catch (e) {
      WebResponseFailed dashboardResponse = WebResponseFailed ();
      returnResponse = dashboardResponse;
    }

    return returnResponse;
  }
}
