import 'package:jakel_base/restapi/cashbacks/model/CashbacksResponse.dart';
import 'package:jakel_base/restapi/customers/model/MembershipResponse.dart';
import 'package:jakel_base/restapi/vouchers/model/VoucherConfigurationResponse.dart';

abstract class MemberShipsLocalApi {
  /// Save
  Future<void> save(List<Memberships> elements);

  /// Get All
  Future<List<Memberships>> getAll();

  // Delete
  Future<bool> delete(int id);

  /// Search
  Future<List<Memberships>> search(String search);

  /// Get By Id
  Future<Memberships?> getById(int id);

  /// Delete
  Future<bool> deleteAll();

  Future<void> clearBox();
}
