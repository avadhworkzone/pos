import 'package:jakel_base/restapi/cashbacks/model/CashbacksResponse.dart';
import 'package:jakel_base/restapi/customers/model/CustomerTypesResponse.dart';
import 'package:jakel_base/restapi/vouchers/model/VoucherConfigurationResponse.dart';

abstract class CustomerTypesLocalApi {
  /// Save
  Future<void> save(List<CustomerTypes> elements);

  /// Get All
  Future<List<CustomerTypes>> getAll();

  // Delete
  Future<bool> delete(int id);

  /// Search
  Future<List<CustomerTypes>> search(String search);

  /// Get By Id
  Future<CustomerTypes> getById(int id);

  /// Delete
  Future<bool> deleteAll();

  Future<void> clearBox();
}
