import 'dart:convert';

import 'package:member_app/data/all_bloc/transactions_list_bloc/repo/transactions_list_response.dart';
import 'package:member_app/data/local/shared_prefs/shared_prefs.dart';
import 'package:member_app/data/remote/web_common_response.dart';
import 'package:member_app/data/remote/web_constants.dart';
import 'package:member_app/data/remote/web_response_failed.dart';
import 'package:member_app/data/remote/web_service.dart';

class TransactionsListRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  dynamic returnResponse;

  TransactionsListRepository(
      {required this.webservice, required this.sharedPrefs});

  Future<dynamic> fetchTransactionsList(
      dynamic mTransactionsListRequest) async {
    final response = await webservice.getWithAuthAndClassRequest(
        WebConstants.actionTransactionsList, mTransactionsListRequest);
    try {
      WebCommonResponse mWebCommonResponse =
          WebCommonResponse.fromJson(response);
      if (mWebCommonResponse.statusCode == "200") {
        TransactionsListResponse dashboardResponse =
            TransactionsListResponse.fromJson(json.decode(mWebCommonResponse.data));
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
