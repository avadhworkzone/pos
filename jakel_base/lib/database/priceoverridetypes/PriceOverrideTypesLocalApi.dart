import 'package:jakel_base/restapi/priceoverridetypes/model/PriceOverrideTypesResponse.dart';

abstract class PriceOverrideTypesLocalApi {
  /// Save
  Future<void> save(List<PriceOverrideTypes> elements);

  /// Get All
  Future<List<PriceOverrideTypes>> getAll();

  // Delete
  Future<bool> delete(int id);

  /// Search
  Future<List<PriceOverrideTypes>> search(String search);

  /// Get By Id
  Future<PriceOverrideTypes> getById(int id);

  /// Delete all
  Future<bool> deleteAll();

  Future<void> clearBox();
}
