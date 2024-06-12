import 'package:dio/dio.dart';
import 'package:jakel_base/restapi/BaseApi.dart';
import 'package:jakel_base/restapi/priceoverridetypes/PriceOverrideTypesApi.dart';
import 'package:jakel_base/restapi/priceoverridetypes/model/PriceOverrideTypesResponse.dart';

class PriceOverrideTypesApiImpl extends BaseApi with PriceOverrideTypesApi {
  @override
  Future<PriceOverrideTypesResponse> getPriceOverrideTypes() async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + getPriceOverrideTypesUrl;

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      return PriceOverrideTypesResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }
}
