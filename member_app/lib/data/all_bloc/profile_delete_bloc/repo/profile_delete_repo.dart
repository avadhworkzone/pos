import 'dart:convert';

import 'package:member_app/data/all_bloc/profile_delete_bloc/repo/profile_delete_response.dart';
import 'package:member_app/data/local/shared_prefs/shared_prefs.dart';
import 'package:member_app/data/remote/web_common_response.dart';
import 'package:member_app/data/remote/web_constants.dart';
import 'package:member_app/data/remote/web_service.dart';

class ProfileDeleteRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  dynamic returnResponse;

  ProfileDeleteRepository(
      {required this.webservice, required this.sharedPrefs});

  Future<dynamic> fetchProfileDelete(dynamic mProfileDeleteListRequest) async {
    final response = await webservice.postWithAuthAndRequest(
        WebConstants.actionDeleteMember, mProfileDeleteListRequest);

    ProfileDeleteResponse dashboardResponse;

    try {
      WebCommonResponse mWebCommonResponse =
          WebCommonResponse.fromJson(response);
      if (mWebCommonResponse.statusCode == "200") {
        dashboardResponse = ProfileDeleteResponse(
            message: "Your profile is delete successfully", status: true);
      } else {
        dashboardResponse =
            ProfileDeleteResponse.fromJson(json.decode(mWebCommonResponse.data));
        dashboardResponse.status = false;
      }
    } catch (e) {
      dashboardResponse = ProfileDeleteResponse(
          message: "Your profile is delete unsuccessfully", status: false);
    }

    returnResponse = dashboardResponse;

    return returnResponse;
  }
}
