import 'package:jakel_base/restapi/vouchers/model/VoucherConfigurationResponse.dart';
import 'package:jakel_base/restapi/vouchers/model/VouchersListResponse.dart';

abstract class VouchersLocalApi {
  /// Save
  Future<void> save(List<Vouchers> elements);

  /// Get All
  Future<List<Vouchers>> getAll();

  // Delete
  Future<bool> delete(String id);

  /// Search
  Future<List<Vouchers>> search(String search);

  /// Get By Id
  Future<Vouchers?> getById(String id);

  /// Delete
  Future<bool> deleteAll();

  Future<void> clearBox();
}
