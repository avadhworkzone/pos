import 'package:jakel_base/restapi/employees/model/EmployeeGroupResponse.dart';
import 'package:jakel_base/restapi/employees/model/EmployeesResponse.dart';

abstract class EmployeesApi {
  Future<EmployeesResponse> getEmployees(
      int pageNo, int perPage, String? searchText);

  Future<EmployeeGroupResponse> getEmployeeGroup();

}
