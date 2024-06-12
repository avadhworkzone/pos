import 'dart:convert';

///total_records: 1,
/// last_page: 1,
/// current_page: 1,
/// per_page: 100,
/// employee_group: [{id: 1, name: Employee Groups, code: null, purchase_limit_type: {id: 3, name: By Amount, key: BY_AMOUNT}, limit_reset_type: {id: 1, name: By Month, key: BY_MONTH}, item_purchase_limit: 0, limit_reset: 0}]}

EmployeeGroupResponse employeeGroupResponseFromJson(String str) =>
    EmployeeGroupResponse.fromJson(json.decode(str));

String employeeGroupResponseToJson(EmployeeGroupResponse data) =>
    json.encode(data.toJson());

class EmployeeGroupResponse {
  EmployeeGroupResponse({
    this.totalRecords,
    this.lastPage,
    this.currentPage,
    this.perPage,
    this.employeeGroup,
  });

  EmployeeGroupResponse.fromJson(dynamic json) {
    totalRecords = json['total_records'];
    lastPage = json['last_page'];
    currentPage = json['current_page'];
    perPage = json['per_page'];
    if (json['employee_group'] != null) {
      employeeGroup = [];
      json['employee_group'].forEach((v) {
        employeeGroup?.add(EmployeeGroup.fromJson(v));
      });
    }
  }

  int? totalRecords;
  int? lastPage;
  int? currentPage;
  int? perPage;
  List<EmployeeGroup>? employeeGroup;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total_records'] = totalRecords;
    map['last_page'] = lastPage;
    map['current_page'] = currentPage;
    map['per_page'] = perPage;
    if (employeeGroup != null) {
      map['employee_group'] = employeeGroup?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

EmployeeGroup memberGroupFromJson(String str) =>
    EmployeeGroup.fromJson(json.decode(str));

String memberGroupToJson(EmployeeGroup data) => json.encode(data.toJson());

/// id : 1
/// name : "Employee Groups"
/// code : null
/// purchase_limit_type : {"id":3,"name":"By Amount","key":"BY_AMOUNT"}
/// limit_reset_type : {"id":1,"name":"By Month","key":"BY_MONTH"}
/// item_purchase_limit : 0
/// limit_reset : 0

class EmployeeGroup {
  EmployeeGroup({
    this.id,
    this.name,
    this.code,
    this.purchaseLimitType,
    this.limitResetType,
    this.itemPurchaseLimit,
    this.limitReset,
  });

  EmployeeGroup.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    code = json['code'].toString();
    purchaseLimitType = json['purchase_limit_type'] != null
        ? PurchaseLimitType.fromJson(json['purchase_limit_type'])
        : null;
    limitResetType = json['limit_reset_type'] != null
        ? LimitResetType.fromJson(json['limit_reset_type'])
        : null;
    itemPurchaseLimit = json['item_purchase_limit'].toString();
    limitReset = json['limit_reset'].toString();
  }

  int? id;
  String? name;
  String? code;
  PurchaseLimitType? purchaseLimitType;
  LimitResetType? limitResetType;
  String? itemPurchaseLimit;
  String? limitReset;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['code'] = code;
    if (purchaseLimitType != null) {
      map['purchase_limit_type'] = purchaseLimitType?.toJson();
    }
    if (limitResetType != null) {
      map['limit_reset_type'] = limitResetType?.toJson();
    }
    map['item_purchase_limit'] = itemPurchaseLimit;
    map['limit_reset'] = limitReset;
    return map;
  }
}

/// id : 1
/// name : "By Month"
/// key : "BY_MONTH"

class LimitResetType {
  LimitResetType({
    this.id,
    this.name,
    this.key,
  });

  LimitResetType.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    key = json['key'];
  }

  int? id;
  String? name;
  String? key;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['key'] = key;
    return map;
  }
}

/// id : 3
/// name : "By Amount"
/// key : "BY_AMOUNT"

class PurchaseLimitType {
  PurchaseLimitType({
    this.id,
    this.name,
    this.key,
  });

  PurchaseLimitType.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    key = json['key'];
  }

  int? id;
  String? name;
  String? key;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['key'] = key;
    return map;
  }
}
