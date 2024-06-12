import 'package:jakel_base/restapi/giftcards/model/GiftCardsResponse.dart';

abstract class GiftCardsLocalApi {
  /// Save
  Future<void> save(List<GiftCards> elements);

  /// Get All
  Future<List<GiftCards>> getAll();

  // Delete
  Future<bool> delete(String id);

  /// Search
  Future<List<GiftCards>> search(String search);

  /// Get By Id
  Future<GiftCards?> getById(String id);

  /// Delete
  Future<bool> deleteAll();

  Future<void> clearBox();
}
