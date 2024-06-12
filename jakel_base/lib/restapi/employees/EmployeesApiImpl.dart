import 'package:dio/dio.dart';
import 'package:jakel_base/restapi/BaseApi.dart';
import 'package:jakel_base/restapi/customers/CustomerApi.dart';
import 'package:jakel_base/restapi/customers/model/CreateCustomerRequest.dart';
import 'package:jakel_base/restapi/customers/model/CustomerRaceResponse.dart';
import 'package:jakel_base/restapi/customers/model/CustomerTitlesResponse.dart';
import 'package:jakel_base/restapi/customers/model/CustomerTypesResponse.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/restapi/employees/model/EmployeeGroupResponse.dart';
import 'package:jakel_base/restapi/customers/model/GenderResponse.dart';
import 'package:jakel_base/restapi/customers/model/MemberGroupResponse.dart';
import 'package:jakel_base/restapi/customers/model/MembershipResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';

import 'EmployeesApi.dart';
import 'model/EmployeesResponse.dart';

class EmployeesApiImpl extends BaseApi with EmployeesApi {
  @override
  Future<EmployeesResponse> getEmployees(
      int pageNo, int perPage, String? searchText) async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();
    var url = "$masterUrl$getEmployeesUrl?";
    if (pageNo > 0) {
      url = "${url}page=$pageNo";
    }

    if (perPage > 0) {
      url = "$url&per_page=$perPage";
    }

    if (searchText != null && searchText.isNotEmpty) {
      url = "$url&search_text=$searchText";
    }
    MyLogUtils.logDebug("getEmployees url : ${url}");

    Response response = await dio.get(url);

    MyLogUtils.logDebug("getEmployees response : ${response.data}");

    if (response.statusCode == 200) {
      return EmployeesResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }

  @override
  Future<EmployeeGroupResponse> getEmployeeGroup() async {
    var masterUrl = await getMasterUrl();
    var dio = await getDioInstance();

    final url = '$masterUrl$employeeGroupList';
    MyLogUtils.logDebug("getEmployeeGroup url : $url");
    Response response = await dio.get(url);
    MyLogUtils.logDebug("getEmployeeGroup response : ${response.data}");
    if (response.statusCode == 200) {
      return EmployeeGroupResponse.fromJson(response.data);
    }
    //Log Error
    logError(url, response.statusCode, response.statusMessage);
    throw Exception(
        "${response.statusCode} & ${response.statusMessage} for $url endpoint");
  }
}
