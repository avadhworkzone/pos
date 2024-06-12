import 'package:dio/dio.dart';
import 'package:jakel_base/restapi/BaseApi.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';

import 'TakeBreakApi.dart';
import 'model/TakeBreakRequest.dart';

class TakeBreakApiImpl extends BaseApi with TakeBreakApi {
  @override
  Future<bool> takeBreak(TakeBreakRequest takeBreakRequest) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = '$masterUrl$updateTakeBreak';

    FormData formData = FormData.fromMap({
      "offline_id": takeBreakRequest.offlineId,
      "type_id": takeBreakRequest.takeBreak == true ? 1 : 2,
      "happened_at": takeBreakRequest.happenedAt ?? ''
    });

    for (var element in formData.fields) {
      MyLogUtils.logDebug(
          "takeBreak request element : ${element.key} = ${element.value}");
    }

    Response response = await dio.post(url, data: formData);

    MyLogUtils.logDebug("takeBreak response.data : ${response.data}");

    MyLogUtils.logDebug(
        "takeBreak response.statusCode : ${response.statusCode}");

    if (response.statusCode == 200) {
      return true;
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "Status:${response.statusCode} & Response:${response.statusMessage} for $url endpoint");
  }
}
