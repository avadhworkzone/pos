
import 'package:jakel_base/restapi/loyaltypointvoucherconfiguration/model/LoyaltyPointVoucherConfigurationResponse.dart';

abstract class LoyaltyPointVoucherConfigurationApi {
  Future<LoyaltyPointVoucherConfigurationResponse> getLoyaltyPointVoucherConfiguration();
}
