import 'package:jakel_base/restapi/sales/model/HoldSaleTypesResponse.dart';

abstract class HoldSaleTypesLocalApi {
  /// Save
  Future<void> save(List<Types> elements);

  /// Get All
  Future<List<Types>> getAll();

  // Delete
  Future<bool> delete(int id);

  /// Delete all
  Future<bool> deleteAll();

  Future<void> clearBox();
}
