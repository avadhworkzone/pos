import 'package:jakel_base/restapi/cashbacks/model/CashbacksResponse.dart';
import 'package:jakel_base/restapi/vouchers/model/VoucherConfigurationResponse.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';

abstract class OnHoldSalesLocalApi {
  /// Save
  Future<void> saveAll(List<CartSummary> elements);

  Future<void> save(CartSummary element);

  /// Get All
  Future<List<CartSummary>> getAll();

  // Delete
  Future<bool> delete(String id);

  /// Search
  Future<List<CartSummary>> search(String search);

  /// Get By Id
  Future<CartSummary> getById(String id);

  /// Delete
  Future<bool> deleteAll();

  Future<void> clearBox();
}
