import 'package:dio/dio.dart';
import 'package:jakel_base/restapi/BaseApi.dart';
import 'package:jakel_base/restapi/denominations/DenominationApi.dart';
import 'package:jakel_base/restapi/denominations/model/DenominationsResponse.dart';
import 'package:jakel_base/restapi/promotions/PromotionApi.dart';
import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';

class DenominationApiImpl extends BaseApi with DenominationApi {
  @override
  Future<DenominationsResponse> getDenominations() async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + denominationsUrl;

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      return DenominationsResponse.fromJson(response.data);
    }

    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }
}
