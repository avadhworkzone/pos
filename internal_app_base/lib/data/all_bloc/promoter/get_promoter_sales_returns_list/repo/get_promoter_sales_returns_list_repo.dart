import 'dart:convert';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_sales_returns_list/repo/GetPromoterSalesReturnsListResponse.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_common_response.dart';
import 'package:internal_base/data/remote/web_constants.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';

class GetPromoterSalesReturnsListRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  dynamic returnResponse;

  GetPromoterSalesReturnsListRepository(
      {required this.webservice, required this.sharedPrefs});

  Future<dynamic> fetchGetPromoterSalesReturnsList(
      dynamic mGetPromoterSalesReturnsListRequest) async {
    final response = await webservice.getWithAuthAndClassQueryRequest(
        WebConstants.actionGetPromoterSalesReturnsList,
        mGetPromoterSalesReturnsListRequest);

    try {
      WebCommonResponse mWebCommonResponse =
          WebCommonResponse.fromJson(response);
      if (mWebCommonResponse.statusCode.toString() == "200") {
        GetPromoterSalesReturnsListResponse dashboardResponse =
            GetPromoterSalesReturnsListResponse.fromJson(
                json.decode(mWebCommonResponse.data));
        returnResponse = dashboardResponse;
      } else {
        WebResponseFailed mWebResponseFailed = WebResponseFailed();
        mWebResponseFailed
            .setMessage("Sorry, Sales & Returns list does not exist.");
        returnResponse = mWebResponseFailed;
      }
    } catch (e) {
      WebResponseFailed mWebResponseFailed = WebResponseFailed();
      mWebResponseFailed
          .setMessage("Sorry, Sales & Returns list does not exist.");
      returnResponse = mWebResponseFailed;
    }

    return returnResponse;
  }
}
