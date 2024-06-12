import 'package:dio/dio.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/logs/MyLogs.dart';
import 'package:jakel_base/restapi/BaseApi.dart';
import 'package:jakel_base/restapi/login/LoginApi.dart';
import 'package:jakel_base/restapi/login/model/LoginRequest.dart';
import 'package:jakel_base/restapi/login/model/LoginResponse.dart';
import 'package:jakel_base/restapi/managers/StoreManagersApi.dart';
import 'package:jakel_base/restapi/managers/model/StoreManagersResponse.dart';
import 'package:jakel_base/restapi/me/MeApi.dart';
import 'package:jakel_base/restapi/me/model/CurrentUserResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';

class StoreManagersApiImpl extends BaseApi with StoreManagersApi {
  @override
  Future<StoreManagersResponse> getStoreManagers() async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + storeManagersUrl;

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      return StoreManagersResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }
}
