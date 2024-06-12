import 'package:jakel_base/restapi/me/model/CashierPermissionResponse.dart';
import 'package:jakel_base/restapi/me/model/CurrentUserResponse.dart';

abstract class MeApi {
  Future<CurrentUserResponse> currentUser();

  Future<CashierPermissionResponse> getCashierPermissions();
}
