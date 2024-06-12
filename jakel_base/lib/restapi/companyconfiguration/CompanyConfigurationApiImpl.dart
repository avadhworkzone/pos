import 'package:dio/dio.dart';
import 'package:jakel_base/restapi/BaseApi.dart';
import 'package:jakel_base/restapi/companyconfiguration/model/CompanyConfigurationResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';

import 'CompanyConfigurationApi.dart';

class CompanyConfigurationApiImpl extends BaseApi with CompanyConfigurationApi {
  @override
  Future<CompanyConfigurationResponse> getCompanyConfiguration() async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + getCompanyConfigurationUrl;

    MyLogUtils.logDebug("getCompanyConfigurationUrl url : ${url} ");
    Response response = await dio.get(url);
    MyLogUtils.logDebug(
        "getCompanyConfigurationUrl response : ${response.data} ");

    if (response.statusCode == 200) {
      return CompanyConfigurationResponse.fromJson(response.data);
    }

    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }
}
