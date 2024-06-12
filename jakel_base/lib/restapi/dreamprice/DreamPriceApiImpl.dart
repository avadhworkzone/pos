import 'package:dio/dio.dart';
import 'package:jakel_base/restapi/BaseApi.dart';
import 'package:jakel_base/restapi/dreamprice/model/DreamPriceResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'DreamPriceApi.dart';

class DreamPriceApiImpl extends BaseApi with DreamPriceApi {
  @override
  Future<DreamPriceResponse> getDreamPrice() async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + dreamPriceUrl;

    Response response = await dio.get(url);
    MyLogUtils.logDebug("getDreamPriceApi response : ${response.data}");
    if (response.statusCode == 200) {
      return DreamPriceResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }
}
