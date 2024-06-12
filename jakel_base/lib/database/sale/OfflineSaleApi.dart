import 'package:jakel_base/database/sale/model/CartSummary.dart';

abstract class OfflineSaleApi {
  /// Save
  Future<void> save(List<CartSummary> elements);

  /// Get All
  Future<List<CartSummary>> getAll();

  // Delete
  Future<bool> delete(String id);

  /// Search
  Future<List<CartSummary>> search(String search);

  /// Get By Id
  Future<CartSummary?> getById(String id);

  /// Delete
  Future<bool> deleteAll();

  Future<void> clearBox();
}
