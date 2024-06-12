import 'package:jakel_base/restapi/paymenttypes/model/PaymentTypesResponse.dart';
import 'package:jakel_base/restapi/promoters/model/PromotersResponse.dart';

abstract class PromotersLocalApi {
  /// Save
  Future<void> save(List<Promoters> elements);

  /// Get All
  Future<List<Promoters>> getAll();

  // Delete
  Future<bool> delete(int id);

  /// Search
  Future<List<Promoters>> search(String search);

  /// Get By Id
  Future<Promoters> getById(int id);

  /// Delete all
  Future<bool> deleteAll();

  Future<void> clearBox();
}
