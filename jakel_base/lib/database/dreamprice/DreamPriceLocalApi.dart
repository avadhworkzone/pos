import 'package:jakel_base/restapi/dreamprice/model/DreamPriceResponse.dart';

abstract class DreamPriceLocalApi {
  /// Save
  Future<void> save(List<DreamPrices> dreamPrices);

  /// Get All
  Future<List<DreamPrices>> getAll();

  // Delete
  Future<bool> delete(int id);

  /// Search
  Future<List<DreamPrices>> search(String search);

  /// Get By Id
  Future<DreamPrices> getById(int id);

  Future<void> clearBox();
}
