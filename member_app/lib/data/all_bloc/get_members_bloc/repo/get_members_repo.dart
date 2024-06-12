import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:member_app/data/all_bloc/get_members_bloc/repo/get_members_response.dart';
import 'package:member_app/data/local/shared_prefs/shared_prefs.dart';
import 'package:member_app/data/remote/web_common_response.dart';
import 'package:member_app/data/remote/web_constants.dart';
import 'package:member_app/data/remote/web_response_failed.dart';
import 'package:member_app/data/remote/web_service.dart';

class GetMemberRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  dynamic returnResponse;

  GetMemberRepository(
      {required this.webservice, required this.sharedPrefs});

  Future<dynamic> fetchGetMember() async {
    final response = await webservice.getWithAuthWithoutRequest(
        WebConstants.actionGetMembers);


    try {
      WebCommonResponse mWebCommonResponse =
      WebCommonResponse.fromJson(response);
      if (mWebCommonResponse.statusCode.toString() == "200") {
        GetMemberResponse dashboardResponse =
        GetMemberResponse.fromJson(json.decode(mWebCommonResponse.data));
        returnResponse = dashboardResponse;
      }else{
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
