import 'package:dio/dio.dart';
import 'package:jakel_base/restapi/BaseApi.dart';
import 'package:jakel_base/restapi/promoters/PromotersApi.dart';
import 'package:jakel_base/restapi/promoters/model/PromotersResponse.dart';

class PromotersApiImpl extends BaseApi with PromotersApi {
  @override
  Future<PromotersResponse> getPromoters() async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + promotersUrl;

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      return PromotersResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }
}
