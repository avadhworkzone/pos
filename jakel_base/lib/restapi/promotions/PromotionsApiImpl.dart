import 'package:dio/dio.dart';
import 'package:jakel_base/restapi/BaseApi.dart';
import 'package:jakel_base/restapi/promotions/PromotionApi.dart';
import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';

class PromotionsApiImpl extends BaseApi with PromotionApi {
  @override
  Future<PromotionsResponse> getPromotions() async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + promotionsUrl;
    MyLogUtils.logDebug("PromotionsApiImpl - url $url");
    Response response = await dio.get(url);
    MyLogUtils.logDebug("PromotionsApiImpl - data ${response.data} \n\n");

    if (response.statusCode == 200) {
      return PromotionsResponse.fromJson(response.data);
    }

    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }
}
