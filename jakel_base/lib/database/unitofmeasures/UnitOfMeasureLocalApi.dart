import '../../restapi/products/model/UnitOfMeasureResponse.dart';

abstract class UnitOfMeasureLocalApi {
  /// Save
  Future<void> save(List<UnitOfMeasures> unitOfMeasure);

  /// Get All
  Future<List<UnitOfMeasures>> getAll();

  // Delete
  Future<bool> delete(int unitOfMeasureId);

  /// Search
  Future<List<UnitOfMeasures>> search(String search);

  /// Get By Id
  Future<UnitOfMeasures> getById(int id);

  Future<void> clearBox();
}
