import '../../restapi/cashiers/model/CashiersResponse.dart';

abstract class CashiersLocalApi {
  /// Save
  Future<void> save(List<Cashiers> elements);

  /// Get All
  Future<List<Cashiers>> getAll();

  // Delete
  Future<bool> delete(String id);

  /// Search
  Future<List<Cashiers>> search(String search);

  /// Get By Id
  Future<Cashiers> getById(String id);

  /// Delete all
  Future<bool> deleteAll();

  Future<void> clearBox();
}
