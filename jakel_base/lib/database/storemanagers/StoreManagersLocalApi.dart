import 'package:jakel_base/restapi/managers/model/StoreManagersResponse.dart';

abstract class StoreManagersLocalApi {
  /// Save
  Future<void> save(List<StoreManagers> elements);

  /// Get All
  Future<List<StoreManagers>> getAll();

  // Delete
  Future<bool> delete(String id);

  /// Search
  Future<List<StoreManagers>> search(String search);

  /// Get By Id
  Future<StoreManagers> getById(String id);

  Future<void> clearBox();
}
