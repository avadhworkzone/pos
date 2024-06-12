import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';

abstract class PromotionsLocalApi {
  /// Save
  Future<void> save(List<Promotions> elements);

  /// Get All
  Future<List<Promotions>> getAll();

  // Delete
  Future<bool> delete(int id);

  /// Search
  Future<List<Promotions>> search(String search);

  /// Get By Id
  Future<Promotions> getById(int id);

  // Delete
  Future<bool> deleteAll();

  Future<void> clearBox();
}
