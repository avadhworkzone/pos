import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:member_app/data/all_bloc/get_races_bloc/repo/get_races_response.dart';
import 'package:member_app/data/local/shared_prefs/shared_prefs.dart';
import 'package:member_app/data/remote/web_common_response.dart';
import 'package:member_app/data/remote/web_constants.dart';
import 'package:member_app/data/remote/web_response_failed.dart';
import 'package:member_app/data/remote/web_service.dart';

class GetRacesRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  dynamic returnResponse;

  GetRacesRepository(
      {required this.webservice, required this.sharedPrefs});

  Future<dynamic> fetchGetRaces() async {
    final response = await webservice.getWithAuthWithoutRequest(
        WebConstants.actionGetRaces);

    try {
      WebCommonResponse mWebCommonResponse =
      WebCommonResponse.fromJson(response);
      if (mWebCommonResponse.statusCode.toString() == "200") {
        GetRacesResponse dashboardResponse =
        GetRacesResponse.fromJson(json.decode(mWebCommonResponse.data));
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
