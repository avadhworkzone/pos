import 'package:jakel_base/restapi/cashbacks/model/CashbacksResponse.dart';

abstract class CashBacksLocalApi {
  /// Save
  Future<void> save(List<Cashbacks> elements);

  /// Get All
  Future<List<Cashbacks>> getAll();

  // Delete
  Future<bool> delete(int id);

  /// Search
  Future<List<Cashbacks>> search(String search);

  /// Get By Id
  Future<Cashbacks> getById(int id);

  /// Delete
  Future<bool> deleteAll();

  Future<void> clearBox();
}
