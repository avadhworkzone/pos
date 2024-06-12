import 'package:jakel_base/database/sale/model/sale_returns_item_data.dart';
import 'package:jakel_base/restapi/customers/model/CustomersResponse.dart';
import 'package:jakel_base/restapi/employees/model/EmployeesResponse.dart';

class SaleReturnsData {
  List<SaleReturnsItemData>? returnItems;
  Customers? customers;
  Employees? employees;
  bool? isExchange;

  SaleReturnsData(
      {this.customers, this.employees, this.returnItems, this.isExchange});

  factory SaleReturnsData.fromJson(dynamic json) {
    return SaleReturnsData(
      returnItems: json['returnItems'] != null
          ? (json['returnItems'] as List)
              .map((i) => SaleReturnsItemData.fromJson(i))
              .toList()
          : [],
      customers: json['customers'] != null
          ? Customers.fromJson(json['customers'])
          : null,
      employees: json['employees'] != null
          ? Employees.fromJson(json['employees'])
          : null,
      isExchange: json['isExchange'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (returnItems != null) {
      data['returnItems'] = returnItems?.map((v) => v.toJson()).toList();
    }

    if (customers != null) {
      data['customers'] = customers?.toJson();
    }

    if (employees != null) {
      data['employees'] = employees?.toJson();
    }

    data['isExchange'] = isExchange;

    return data;
  }
}
