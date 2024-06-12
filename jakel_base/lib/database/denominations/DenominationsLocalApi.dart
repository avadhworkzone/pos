import 'package:jakel_base/restapi/denominations/model/DenominationsResponse.dart';

abstract class DenominationsLocalApi {
  /// Save
  Future<void> save(List<DenominationKey> elements);

  /// Get All
  Future<List<DenominationKey>> getAll();

  // Delete
  Future<bool> delete(int id);

  /// Search
  Future<List<DenominationKey>> search(String search);

  /// Get By Id
  Future<DenominationKey> getById(int id);

  /// Delete all
  Future<bool> deleteAll();

  Future<void> clearBox();
}
