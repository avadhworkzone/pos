import 'package:dio/dio.dart';
import 'package:jakel_base/restapi/BaseApi.dart';
import 'package:jakel_base/restapi/cashbacks/model/CashbacksResponse.dart';

import 'CashBacksApi.dart';

class CashBacksApiImpl extends BaseApi with CashBacksApi {
  @override
  Future<CashbacksResponse> getAllCashBacks() async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + cashBackUrl;

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      return CashbacksResponse.fromJson(response.data);
    }

    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }
}
