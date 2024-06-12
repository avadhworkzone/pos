import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:member_app/data/all_bloc/login_mobile_number_otp_bloc/repo/login_mobile_number_otp_screen_response.dart';
import 'package:member_app/data/all_bloc/member_voucher_paginated_list_bloc/repo/member_voucher_paginated_list_response.dart';
import 'package:member_app/data/local/shared_prefs/shared_prefs.dart';
import 'package:member_app/data/remote/web_common_response.dart';
import 'package:member_app/data/remote/web_constants.dart';
import 'package:member_app/data/remote/web_response_failed.dart';
import 'package:member_app/data/remote/web_service.dart';

class MemberVoucherPaginatedListRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  dynamic returnResponse;

  MemberVoucherPaginatedListRepository(
      {required this.webservice, required this.sharedPrefs});

  Future<dynamic> fetchMemberVoucherPaginatedList(
      dynamic mMemberVoucherPaginatedListRequest) async {
    final response = await webservice.getWithAuthAndClassRequest(
        WebConstants.actionMemberVoucherPaginatedList,
        mMemberVoucherPaginatedListRequest);

    try {
      WebCommonResponse mWebCommonResponse =
      WebCommonResponse.fromJson(response);
      if (mWebCommonResponse.statusCode.toString() == "200") {
        MemberVoucherPaginatedListResponse dashboardResponse =
        MemberVoucherPaginatedListResponse.fromJson(json.decode(mWebCommonResponse.data));
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
