import 'dart:convert';

import 'package:jakel_base/restapi/employees/model/EmployeeGroupResponse.dart';
import 'package:jakel_base/restapi/customers/model/MemberGroupResponse.dart';
import 'package:jakel_base/utils/num_utils.dart';

/// dream_prices : [{"id":1,"start_date":"2022-08-10","end_date":"2022-08-13","products":[{"id":1,"product_id":10000,"price":100.01}]},{"id":2,"start_date":"2022-09-01","end_date":"2022-10-04","products":[{"id":2,"product_id":10010,"price":30.05},{"id":3,"product_id":10011,"price":65.6}]}]

DreamPriceResponse dreamPriceResponseFromJson(String str) =>
    DreamPriceResponse.fromJson(json.decode(str));

String dreamPriceResponseToJson(DreamPriceResponse data) =>
    json.encode(data.toJson());

class DreamPriceResponse {
  DreamPriceResponse({
    this.dreamPrices,
  });

  DreamPriceResponse.fromJson(dynamic json) {
    if (json['dream_prices'] != null) {
      dreamPrices = [];
      json['dream_prices'].forEach((v) {
        dreamPrices?.add(DreamPrices.fromJson(v));
      });
    }
  }

  List<DreamPrices>? dreamPrices;

  DreamPriceResponse copyWith({
    List<DreamPrices>? dreamPrices,
  }) =>
      DreamPriceResponse(
        dreamPrices: dreamPrices ?? this.dreamPrices,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (dreamPrices != null) {
      map['dream_prices'] = dreamPrices?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 1
/// start_date : "2022-08-10"
/// end_date : "2022-08-13"
/// products : [{"id":1,"product_id":10000,"price":100.01}]

DreamPrices dreamPricesFromJson(String str) =>
    DreamPrices.fromJson(json.decode(str));

String dreamPricesToJson(DreamPrices data) => json.encode(data.toJson());

class DreamPrices {
  DreamPrices({
    this.id,
    this.startDate,
    this.allowEmployee,
    this.allowRegisteredMember,
    this.allowWalkInMember,
    this.isMemberRequired,
    this.onlyForEmployees,
    this.memberGroups,
    this.endDate,
    this.products,
  });

  DreamPrices.fromJson(dynamic json) {
    id = json['id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    allowEmployee = json['allow_employee'];
    allowRegisteredMember = json['allow_registered_member'];
    allowWalkInMember = json['allow_walk_in_member'];
    isMemberRequired = json['is_member_required'];
    onlyForEmployees = json['only_for_employees'];

    if (json['member_groups'] != null) {
      memberGroups = [];
      json['member_groups'].forEach((v) {
        memberGroups?.add(MemberGroup.fromJson(v));
      });
    }

    if (json['employee_groups'] != null) {
      employeeGroups = [];
      json['employee_groups'].forEach((v) {
        employeeGroups?.add(EmployeeGroup.fromJson(v));
      });
    }

    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products?.add(Products.fromJson(v));
      });
    }
  }

  int? id;
  String? startDate;
  String? endDate;
  bool? allowEmployee;
  bool? allowRegisteredMember;
  bool? allowWalkInMember;
  bool? isMemberRequired;
  bool? onlyForEmployees;
  List<Products>? products;
  List<MemberGroup>? memberGroups;
  List<EmployeeGroup>? employeeGroups;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['start_date'] = startDate;
    map['end_date'] = endDate;
    map['allow_employee'] = allowEmployee;
    map['allow_registered_member'] = allowRegisteredMember;
    map['allow_walk_in_member'] = allowWalkInMember;
    map['is_member_required'] = isMemberRequired;
    map['only_for_employees'] = onlyForEmployees;

    if (products != null) {
      map['products'] = products?.map((v) => v.toJson()).toList();
    }
    if (memberGroups != null) {
      map['member_groups'] = memberGroups?.map((v) => v.toJson()).toList();
    }

    if (employeeGroups != null) {
      map['employee_groups'] = employeeGroups?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}

/// id : 1
/// product_id : 10000
/// price : 100.01

Products productsFromJson(String str) => Products.fromJson(json.decode(str));

String productsToJson(Products data) => json.encode(data.toJson());

class Products {
  Products({
    this.id,
    this.productId,
    this.price,
  });

  Products.fromJson(dynamic json) {
    id = json['id'];
    productId = json['product_id'];
    price = getDoubleValue(json['price']);
  }

  int? id;
  int? productId;
  double? price;

  Products copyWith({
    int? id,
    int? productId,
    double? price,
  }) =>
      Products(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        price: price ?? this.price,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['product_id'] = productId;
    map['price'] = price;
    return map;
  }
}
