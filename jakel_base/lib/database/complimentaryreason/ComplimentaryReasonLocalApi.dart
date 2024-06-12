import 'package:jakel_base/restapi/complimentaryreason/model/ComplimentaryReasonResponse.dart';

abstract class ComplimentaryReasonLocalApi {
  /// Save
  Future<void> save(List<ComplimentaryItemReasons> elements);

  /// Get All
  Future<List<ComplimentaryItemReasons>> getAll();

  // Delete
  Future<bool> delete(int id);

  /// Search
  Future<List<ComplimentaryItemReasons>> search(String search);

  /// Get By Id
  Future<ComplimentaryItemReasons> getById(int id);

  /// Delete all
  Future<bool> deleteAll();

  Future<void> clearBox();
}
