import 'package:dio/dio.dart';
import 'package:jakel_base/restapi/BaseApi.dart';
import 'package:jakel_base/restapi/cashiers/CashiersApi.dart';
import 'package:jakel_base/restapi/cashiers/model/CashiersResponse.dart';

class CashiersApiImpl extends BaseApi with CashiersApi {
  @override
  Future<CashiersResponse> getCashiers() async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + cashiersUrl;

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      return CashiersResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }
}
