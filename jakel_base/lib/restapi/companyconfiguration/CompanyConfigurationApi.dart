import 'package:jakel_base/restapi/companyconfiguration/model/CompanyConfigurationResponse.dart';

abstract class CompanyConfigurationApi {
  Future<CompanyConfigurationResponse> getCompanyConfiguration();
}
