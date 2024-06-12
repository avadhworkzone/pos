import 'package:dio/dio.dart';
import 'package:jakel_base/restapi/BaseApi.dart';
import 'package:jakel_base/restapi/directors/model/DirectorsResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';

import 'DirectorsApi.dart';

class DirectorsApiImpl extends BaseApi with DirectorsApi {
  @override
  Future<DirectorsResponse> getDirectors() async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + directorsUrl;

    Response response = await dio.get(url);

    MyLogUtils.logDebug("getDirectors : ${response.data}");

    if (response.statusCode == 200) {
      return DirectorsResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }
}
