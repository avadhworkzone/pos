import 'package:jakel_base/restapi/paymenttypes/model/PaymentTypesResponse.dart';

abstract class PaymentTypesLocalApi {
  /// Save
  Future<void> save(List<PaymentTypes> elements);

  /// Get All
  Future<List<PaymentTypes>> getAll();

  // Delete
  Future<bool> delete(int id);

  /// Search
  Future<List<PaymentTypes>> search(String search);

  /// Get By Id
  Future<PaymentTypes> getById(int id);

  Future<void> clearBox();
}
