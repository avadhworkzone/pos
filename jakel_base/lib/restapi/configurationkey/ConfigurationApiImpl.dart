import 'package:dio/dio.dart';
import 'package:jakel_base/restapi/BaseApi.dart';
import 'package:jakel_base/restapi/configurationkey/model/ConfigurationResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import '../../utils/my_network_helper.dart';
import 'ConfigurationApi.dart';

class ConfigurationApiImpl extends BaseApi with ConfigurationApi {
  @override
  Future<ConfigurationResponse> getConfigurations(String key) async {
    MyLogUtils.logDebug("getConfigurations key : $key");

    if (!await checkIsInternetConnected()) {
      MyLogUtils.logDebug("ConfigurationApiImpl Internet not available");
      return ConfigurationResponse(url: null);
    }

    var url =
        'https://retail.ariani.my/api/pos/get-url-from-configuration-key?configuration_key=$key';

    MyLogUtils.logDebug("getConfigurations url : $url");

    try {
      var dio = await getDioInstance();

      MyLogUtils.logDebug("getConfigurations dio instance created");

      Response response = await dio.get(url);

      MyLogUtils.logDebug("ConfigurationApiImpl data : ${response.data}");

      if (response.statusCode == 200) {
        return ConfigurationResponse.fromJson(response.data);
      }

      //Log Error
      logError(url, response.statusCode, response.statusMessage);

      return ConfigurationResponse(url: null);
    } on DioError catch (ex) {
      MyLogUtils.logDebug("getConfigurations ex : $ex");
      //Log Error
      logError(url, -1, "Dio Error, Type:${ex.type}, Message:${ex.message}");
      return ConfigurationResponse(url: null);
    }
  }
}
