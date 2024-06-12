import 'package:dio/dio.dart';
import 'package:jakel_base/restapi/BaseApi.dart';
import 'package:jakel_base/restapi/pettycash/model/PettyCashUsageResponse.dart';
import 'package:jakel_base/restapi/pettycash/model/PettyCashUsagesResponse.dart';

import '../../utils/MyLogUtils.dart';
import 'PettyCashApi.dart';

class PettyCashApiImpl extends BaseApi with PettyCashApi {
  @override
  Future<PettyCashUsageResponse> getPettyCashUsageReasons() async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + pettyCashUsageReasons;

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      return PettyCashUsageResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<bool> savePettyCash(int reasonId, double amount) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = '$masterUrl$savePettyCashUsage';

    FormData formData = FormData.fromMap({
      "petty_cash_usage_reason_id": reasonId,
      "amount": amount,
    });
    Response response = await dio.post(url, data: formData);

    if (response.statusCode == 200) {
      return true;
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "Status:${response.statusCode} & Response:${response.statusMessage} for $url endpoint");
  }

  @override
  Future<PettyCashUsagesResponse> getPettyCashUsages(
      int pageNo, int perPage, bool onlyThisCounter) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    var url = "$masterUrl$pettyCashUsages?";

    if (pageNo > 0) {
      url = "${url}page=$pageNo";
    }

    if (perPage > 0) {
      url = "$url&per_page=$perPage";
    }

    if (onlyThisCounter) {
      url = "$url&only_current_counter=1";
    } else {
      url = "$url&only_current_counter=0";
    }

    MyLogUtils.logDebug("getPettyCashUsages Url : $url");
    Response response = await dio.get(url);

    MyLogUtils.logDebug(
        "getPettyCashUsages statusCode : ${response.statusCode}");

    if (response.statusCode == 200) {
      return PettyCashUsagesResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }
}
