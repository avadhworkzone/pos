import '../restapi/companyconfiguration/model/CompanyConfigurationResponse.dart';

bool isPromoterMandatory(CompanyConfigurationResponse? config) {
  if (config != null &&
      config.isPromoterMandatory != null &&
      config.isPromoterMandatory == true) {
    return true;
  }
  return false;
}

bool isBillReferenceMandatory(CompanyConfigurationResponse? config) {
  if (config != null &&
      config.isBillReferenceNumberMandatory != null &&
      config.isBillReferenceNumberMandatory == true) {
    return true;
  }
  return false;
}
