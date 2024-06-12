import 'package:jakel_base/restapi/directors/model/DirectorsResponse.dart';

abstract class DirectorsLocalApi {
  /// Save
  Future<void> save(List<Directors> elements);

  /// Get All
  Future<List<Directors>> getAll();

  // Delete
  Future<bool> delete(String id);

  /// Search
  Future<List<Directors>> search(String search);

  /// Get By Id
  Future<Directors> getById(String id);

  Future<void> clearBox();
}
