import 'package:jakel_base/restapi/managers/model/StoreManagersResponse.dart';

abstract class StoreManagersApi {
  Future<StoreManagersResponse> getStoreManagers();
}
