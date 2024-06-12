import 'package:jakel_base/restapi/loyaltypointvoucherconfiguration/model/LoyaltyPointVoucherConfigurationResponse.dart';

abstract class LoyaltyPointVoucherConfigurationLocalApi {
  /// Save
  Future<void> save(LoyaltyPointVoucherConfigurationResponse response);

  /// Get
  Future<LoyaltyPointVoucherConfigurationResponse?> getConfig();

  /// Delete
  Future<bool> deleteAll();

  Future<void> clearBox();
}
