import 'package:jakel_base/restapi/configurationkey/model/ConfigurationResponse.dart';
import 'package:jakel_base/restapi/me/model/CurrentUserResponse.dart';

abstract class UserLocalApi {
  /// Save current logged user password
  Future<void> savePassword(String password);

  /// Get current user password
  Future<String?> getPassword();

  /// Save current logged user token
  Future<void> saveToken(String token);

  /// Get unique device id
  Future<String?> getDeviceId();

  /// Save Unique device id
  Future<void> saveDeviceId(String deviceId);

  /// Get current user token
  Future<String?> getToken();

  /// Save current logged user name
  Future<void> saveUserName(String userName);

  /// Get current user token
  Future<String?> getUserName();

  /// Logout the user
  Future<bool?> logout();

  // Save current logged in cashier details
  Future<bool> saveCurrentUser(CurrentUserResponse currentUser);

  // Get current logged in cashier details
  Future<CurrentUserResponse?> getCurrentUser();

  /// Save Configuration to local db
  Future<bool?> saveConfiguration(ConfigurationResponse configs);

  /// Get saved Configuration
  Future<ConfigurationResponse?> getConfiguration();

  /// Save current logged user token
  Future<void> saveConfigKey(String key);

  /// Get current user token
  Future<String?> getConfigKey();

  /// Delete Configuration
  Future<bool?> deleteConfiguration();

  Future<void> clearBox();
}
