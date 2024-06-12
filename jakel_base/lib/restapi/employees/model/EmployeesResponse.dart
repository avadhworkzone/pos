import 'dart:convert';

import 'package:jakel_base/restapi/employees/model/EmployeeGroupResponse.dart';
import 'package:jakel_base/utils/num_utils.dart';

/// employees : [{"id":10,"first_name":"Mariona","last_name":"","email":"mariona@jakelmall.com","mobile_number":"076543299722","home_contact":"","address_line_1":"Bangsar","address_line_2":"","city":"","area_code":"","date_of_joining":"","primary_contact_name":"","primary_contact_phone":"","staff_id":"Mariona003","membership_id":"","ic_number":"","job_type":1,"spent_till_now":0.0,"total_loyalty_points":0.0,"photo_url":"","registered_at":"2022-11-17 16:04:25"}]
/// total_records : 10
/// last_page : 1
/// current_page : 1
/// per_page : 10

EmployeesResponse employeesResponseFromJson(String str) =>
    EmployeesResponse.fromJson(json.decode(str));

String employeesResponseToJson(EmployeesResponse data) =>
    json.encode(data.toJson());

class EmployeesResponse {
  EmployeesResponse({
    this.employees,
    this.totalRecords,
    this.lastPage,
    this.currentPage,
    this.perPage,
  });

  EmployeesResponse.fromJson(dynamic json) {
    if (json['employees'] != null) {
      employees = [];
      json['employees'].forEach((v) {
        employees?.add(Employees.fromJson(v));
      });
    }
    totalRecords = json['total_records'];
    lastPage = json['last_page'];
    currentPage = json['current_page'];
    perPage = json['per_page'];
  }

  List<Employees>? employees;
  int? totalRecords;
  int? lastPage;
  int? currentPage;
  int? perPage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (employees != null) {
      map['employees'] = employees?.map((v) => v.toJson()).toList();
    }
    map['total_records'] = totalRecords;
    map['last_page'] = lastPage;
    map['current_page'] = currentPage;
    map['per_page'] = perPage;
    return map;
  }
}

/// id : 10
/// first_name : "Mariona"
/// last_name : ""
/// email : "mariona@jakelmall.com"
/// mobile_number : "076543299722"
/// home_contact : ""
/// address_line_1 : "Bangsar"
/// address_line_2 : ""
/// city : ""
/// area_code : ""
/// date_of_joining : ""
/// primary_contact_name : ""
/// primary_contact_phone : ""
/// staff_id : "Mariona003"
/// membership_id : ""
/// ic_number : ""
/// job_type : 1
/// spent_till_now : 0.0
/// total_loyalty_points : 0.0
/// photo_url : ""
/// registered_at : "2022-11-17 16:04:25"

Employees employeesFromJson(String str) => Employees.fromJson(json.decode(str));

String employeesToJson(Employees data) => json.encode(data.toJson());

class Employees {
  Employees({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.mobileNumber,
    this.homeContact,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.areaCode,
    this.dateOfJoining,
    this.primaryContactName,
    this.primaryContactPhone,
    this.staffId,
    this.membershipId,
    this.icNumber,
    this.jobType,
    this.spentTillNow,
    this.usedLimit,
    this.totalLoyaltyPoints,
    this.photoUrl,
    this.registeredAt,
    this.employeeGroup,
  });

  Employees.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    mobileNumber = json['mobile_number'];
    homeContact = json['home_contact'];
    addressLine1 = json['address_line_1'];
    addressLine2 = json['address_line_2'];
    city = json['city'];
    areaCode = json['area_code'];
    dateOfJoining = json['date_of_joining'];
    primaryContactName = json['primary_contact_name'];
    primaryContactPhone = json['primary_contact_phone'];
    staffId = json['staff_id'];
    membershipId = getInValue(json['membership_id']);
    icNumber = json['ic_number'];
    jobType = json['job_type'];
    spentTillNow = getDoubleValue(json['spent_till_now']);
    usedLimit = getDoubleValue(json['used_limit']);
    totalLoyaltyPoints = getDoubleValue(json['total_loyalty_points']);
    photoUrl = json['photo_url'];
    registeredAt = json['registered_at'];
    employeeGroup =
    json['group'] != null ? EmployeeGroup.fromJson(json['group']) : null;
  }

  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? mobileNumber;
  String? homeContact;
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? areaCode;
  String? dateOfJoining;
  String? primaryContactName;
  String? primaryContactPhone;
  String? staffId;
  int? membershipId;
  String? icNumber;
  int? jobType;
  double? spentTillNow;
  double? usedLimit;
  double? totalLoyaltyPoints;
  String? photoUrl;
  String? registeredAt;
  EmployeeGroup? employeeGroup;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['email'] = email;
    map['mobile_number'] = mobileNumber;
    map['home_contact'] = homeContact;
    map['address_line_1'] = addressLine1;
    map['address_line_2'] = addressLine2;
    map['city'] = city;
    map['area_code'] = areaCode;
    map['date_of_joining'] = dateOfJoining;
    map['primary_contact_name'] = primaryContactName;
    map['primary_contact_phone'] = primaryContactPhone;
    map['staff_id'] = staffId;
    map['membership_id'] = membershipId;
    map['ic_number'] = icNumber;
    map['job_type'] = jobType;
    map['spent_till_now'] = spentTillNow;
    map['used_limit'] = usedLimit;
    map['total_loyalty_points'] = totalLoyaltyPoints;
    map['photo_url'] = photoUrl;
    map['registered_at'] = registeredAt;
    if (employeeGroup != null) {
      map['group'] = employeeGroup?.toJson();
    }
    return map;
  }
}
