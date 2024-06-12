import 'package:jakel_base/restapi/vouchers/model/VoucherConfigurationResponse.dart';

abstract class VoucherConfigLocalApi {
  /// Save
  Future<void> save(List<VoucherConfiguration> elements);

  /// Get All
  Future<List<VoucherConfiguration>> getAll();

  // Delete
  Future<bool> delete(int id);

  /// Search
  Future<List<VoucherConfiguration>> search(String search);

  /// Get By Id
  Future<VoucherConfiguration> getById(int id);

  /// Delete
  Future<bool> deleteAll();

  Future<void> clearBox();
}
