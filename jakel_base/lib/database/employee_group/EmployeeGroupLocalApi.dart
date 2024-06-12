import 'package:jakel_base/restapi/employees/model/EmployeeGroupResponse.dart';

abstract class EmployeeGroupLocalApi {
  /// Save
  Future<void> save(List<EmployeeGroup> elements);

  /// Get All
  Future<List<EmployeeGroup>> getAll();

  // Delete
  Future<bool> delete(int id);

  /// Search
  Future<List<EmployeeGroup>> search(String search);

  /// Get By Id
  Future<EmployeeGroup> getById(int id);

  /// Delete
  Future<bool> deleteAll();

  Future<void> clearBox();
}
