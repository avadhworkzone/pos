import 'package:dio/dio.dart';
import 'package:jakel_base/restapi/BaseApi.dart';
import 'package:jakel_base/restapi/complimentaryreason/ComplimentaryApi.dart';
import 'package:jakel_base/restapi/complimentaryreason/model/ComplimentaryReasonResponse.dart';

class ComplimentaryApiImpl extends BaseApi with ComplimentaryApi {
  @override
  Future<ComplimentaryReasonResponse> getReasons() async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + complimentaryItemReasons;

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      return ComplimentaryReasonResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }
}
