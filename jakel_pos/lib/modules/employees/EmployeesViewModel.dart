import 'dart:convert';

import 'package:jakel_base/constants.dart';
import 'package:jakel_base/jakel_base.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/restapi/employees/EmployeesApi.dart';
import 'package:jakel_base/restapi/employees/model/EmployeesResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:rxdart/rxdart.dart';

class EmployeesViewModel extends BaseViewModel {
  var responseSubject = PublishSubject<EmployeesResponse>();

  Stream<EmployeesResponse> get responseStream => responseSubject.stream;

  void closeObservable() {
    responseSubject.close();
  }

  void getEmployees(int pageNo, int perPage, String? searchText) async {
    var api = locator.get<EmployeesApi>();

    try {
      var response = await api.getEmployees(pageNo, perPage, searchText);
      responseSubject.sink.add(response);
    } catch (e) {
      MyLogUtils.logDebug("getEmployees exception $e");
      responseSubject.sink.addError(e);
    }
  }

  String name(Employees employees) {
    if (employees.lastName != null && employees.firstName != null) {
      return employees.lastName! + employees.firstName!;
    }
    if (employees.firstName != null) {
      return employees.firstName!;
    }

    if (employees.firstName != null) {
      return employees.firstName!;
    }
    return noData;
  }

  String address(Employees customer) {
    String value = "";
    if (customer.addressLine1 != null) {
      value = "$value${customer.addressLine1!},";
    }

    if (customer.addressLine2 != null) {
      value = "$value${customer.addressLine2!},";
    }

    if (customer.city != null) {
      value = value + customer.city!;
    }
    return value.isEmpty ? noData : value;
  }

  String spentTillNow(Employees customers) {
    return getReadableAmount(getCurrency(), customers.spentTillNow);
  }

  pageCount(EmployeesResponse? employeesResponse,int index){
    return ((employeesResponse!.currentPage!-1)*20)+(index);
  }

}
