import 'package:jakel_base/restapi/configurationkey/model/ConfigurationResponse.dart';

abstract class ConfigurationApi {
  Future<ConfigurationResponse> getConfigurations(String key);
}
