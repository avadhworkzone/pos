import 'package:jakel_base/restapi/cashbacks/model/CashbacksResponse.dart';
import 'package:jakel_base/restapi/cashmovement/model/CashMovementReasonResponse.dart';
import 'package:jakel_base/restapi/vouchers/model/VoucherConfigurationResponse.dart';

abstract class CashMovementLocalApi {
  /// Save
  Future<void> save(List<CashMovementReasons> elements);

  /// Get All
  Future<List<CashMovementReasons>> getAll();

  // Delete
  Future<bool> delete(int id);

  /// Search
  Future<List<CashMovementReasons>> search(String search);

  /// Get By Id
  Future<CashMovementReasons> getById(int id);

  /// Delete
  Future<bool> deleteAll();

  Future<void> clearBox();
}
