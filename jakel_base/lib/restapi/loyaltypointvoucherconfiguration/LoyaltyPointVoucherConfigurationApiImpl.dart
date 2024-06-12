import 'package:dio/dio.dart';
import 'package:jakel_base/restapi/BaseApi.dart';
import 'package:jakel_base/restapi/loyaltypointvoucherconfiguration/model/LoyaltyPointVoucherConfigurationResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';

import 'LoyaltyPointVoucherConfigurationApi.dart';

class LoyaltyPointVoucherConfigurationApiImpl extends BaseApi with LoyaltyPointVoucherConfigurationApi {
  @override
  Future<LoyaltyPointVoucherConfigurationResponse> getLoyaltyPointVoucherConfiguration() async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    final url = masterUrl + getLoyaltyPointVoucherConfigurationUrl;

    MyLogUtils.logDebug("getLoyaltyPointVoucherConfigurationUrl url : $url ");
    Response response = await dio.get(url);
    MyLogUtils.logDebug(
        "getLoyaltyPointVoucherConfigurationUrl response : ${response.data} ");

    if (response.statusCode == 200) {
      return LoyaltyPointVoucherConfigurationResponse.fromJson(response.data);
    }

    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }
}
