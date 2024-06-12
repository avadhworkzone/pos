import 'package:jakel_base/restapi/cashbacks/model/CashbacksResponse.dart';
import 'package:jakel_base/restapi/customers/model/CustomerTypesResponse.dart';
import 'package:jakel_base/restapi/customers/model/MemberGroupResponse.dart';
import 'package:jakel_base/restapi/vouchers/model/VoucherConfigurationResponse.dart';

abstract class MemberGroupLocalApi {
  /// Save
  Future<void> save(List<MemberGroup> elements);

  /// Get All
  Future<List<MemberGroup>> getAll();

  // Delete
  Future<bool> delete(int id);

  /// Search
  Future<List<MemberGroup>> search(String search);

  /// Get By Id
  Future<MemberGroup> getById(int id);

  /// Delete
  Future<bool> deleteAll();

  Future<void> clearBox();
}
