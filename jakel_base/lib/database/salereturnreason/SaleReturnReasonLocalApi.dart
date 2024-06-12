import 'package:jakel_base/restapi/sales/model/SaleReturnsResponse.dart';

abstract class SaleReturnReasonLocalApi {
  /// Save
  Future<void> save(List<SaleReturnReasons> elements);

  /// Get All
  Future<List<SaleReturnReasons>> getAll();

  // Delete
  Future<bool> delete(int id);

  /// Search
  Future<List<SaleReturnReasons>> search(String search);

  /// Get By Id
  Future<SaleReturnReasons> getById(int id);

  /// Delete all
  Future<bool> deleteAll();

  Future<void> clearBox();
}
