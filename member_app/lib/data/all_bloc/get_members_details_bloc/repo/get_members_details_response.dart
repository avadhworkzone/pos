import 'package:member_app/data/all_bloc/get_members_details_bloc/repo/member_details.dart';

/// member_details : {"id":1,"type_details":{"id":2,"name":"Regular","key":"REGULAR"},"title_details":{"id":9,"name":"Mrs","key":"MRS"},"gender_details":{"id":2,"name":"Female","key":"FEMALE"},"race_details":{"id":1,"name":"Malay","key":"MALAY"},"first_name":"HAFILZAWATI BT AHMAD","last_name":"","mobile_number":"60199920101","email":"740629025816@ariani.my","address_line_1":"ARIANI GALLERY GONG BADAK","address_line_2":"","city":"","area_code":"","date_of_birth":"1974-06-29","total_orders":0,"spent_till_now":100,"last_purchase_date":"2023-03-05 09:55:20","company_name":"","company_registration_number":"","company_tax_number":"","company_phone":"","notes":"740629025816","photo_url":"","available_loyalty_points":100,"membership_id":1,"registered_at":"2023-01-31 11:17:27","card_number":"7562034807282519","store":"ARIANI GALLERY GONG BADAK","membership":"NORMAL MEMBER","company":{"id":1,"name":"ARIANI TEXTILES & MANUFACTURING (M) SDN. BHD.","code":"AR"}}
/// last_transactions_details : [{"points":50,"closing_loyalty_points_balance":100,"type_id":"SALE","affected_by_type":"SALE","happened_at":"2022-06-24 05:20:50"},{"points":50,"closing_loyalty_points_balance":50,"type_id":"SALE","affected_by_type":"SALE","happened_at":"2022-06-24 05:20:50"}]
/// currently_available_loyalty_points : 100
/// active_voucher_count : 0

class GetMemberDetailsResponse {
  GetMemberDetailsResponse({
    this.memberDetails,
    this.lastTransactionsDetails,
    this.currentlyAvailableLoyaltyPoints,
    this.activeVoucherCount,});

  GetMemberDetailsResponse.fromJson(dynamic json) {
    memberDetails = json['member_details'] != null ? MemberDetails.fromJson(json['member_details']) : null;
    if (json['last_transactions_details'] != null) {
      lastTransactionsDetails = [];
      json['last_transactions_details'].forEach((v) {
        lastTransactionsDetails?.add(LastTransactionsDetails.fromJson(v));
      });
    }
    currentlyAvailableLoyaltyPoints = json['currently_available_loyalty_points'].toString();
    activeVoucherCount = json['active_voucher_count'].toString();
  }
  MemberDetails? memberDetails;
  List<LastTransactionsDetails>? lastTransactionsDetails;
  String? currentlyAvailableLoyaltyPoints;
  String? activeVoucherCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (memberDetails != null) {
      map['member_details'] = memberDetails?.toJson();
    }
    if (lastTransactionsDetails != null) {
      map['last_transactions_details'] = lastTransactionsDetails?.map((v) => v.toJson()).toList();
    }
    map['currently_available_loyalty_points'] = currentlyAvailableLoyaltyPoints;
    map['active_voucher_count'] = activeVoucherCount;
    return map;
  }

}

/// points : 50
/// closing_loyalty_points_balance : 100
/// type_id : "SALE"
/// affected_by_type : "SALE"
/// happened_at : "2022-06-24 05:20:50"

class LastTransactionsDetails {
  LastTransactionsDetails({
    this.points,
    this.closingLoyaltyPointsBalance,
    this.typeId,
    this.affectedByType,
    this.happenedAt,
    this.type,
  });

  LastTransactionsDetails.fromJson(dynamic json) {
    points = json['points'].toString();
    closingLoyaltyPointsBalance = json['closing_loyalty_points_balance'].toString();
    typeId = json['type_id'];
    affectedByType = json['affected_by_type'];
    happenedAt = json['happened_at'];
    type = json['type'];
  }
  String? points;
  String? closingLoyaltyPointsBalance;
  String? typeId;
  String? affectedByType;
  String? happenedAt;
  String? type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['points'] = points;
    map['closing_loyalty_points_balance'] = closingLoyaltyPointsBalance;
    map['type_id'] = typeId;
    map['affected_by_type'] = affectedByType;
    map['happened_at'] = happenedAt;
    map['type'] = type;
    return map;
  }

}

// /// id : 1
// /// type_details : {"id":2,"name":"Regular","key":"REGULAR"}
// /// title_details : {"id":9,"name":"Mrs","key":"MRS"}
// /// gender_details : {"id":2,"name":"Female","key":"FEMALE"}
// /// race_details : {"id":1,"name":"Malay","key":"MALAY"}
// /// first_name : "HAFILZAWATI BT AHMAD"
// /// last_name : ""
// /// mobile_number : "60199920101"
// /// email : "740629025816@ariani.my"
// /// address_line_1 : "ARIANI GALLERY GONG BADAK"
// /// address_line_2 : ""
// /// city : ""
// /// area_code : ""
// /// date_of_birth : "1974-06-29"
// /// total_orders : 0
// /// spent_till_now : 100
// /// last_purchase_date : "2023-03-05 09:55:20"
// /// company_name : ""
// /// company_registration_number : ""
// /// company_tax_number : ""
// /// company_phone : ""
// /// notes : "740629025816"
// /// photo_url : ""
// /// available_loyalty_points : 100
// /// membership_id : 1
// /// registered_at : "2023-01-31 11:17:27"
// /// card_number : "7562034807282519"
// /// store : "ARIANI GALLERY GONG BADAK"
// /// membership : "NORMAL MEMBER"
// /// company : {"id":1,"name":"ARIANI TEXTILES & MANUFACTURING (M) SDN. BHD.","code":"AR"}
//
// class MemberDetails {
//   MemberDetails({
//     this.id,
//     this.typeDetails,
//     this.titleDetails,
//     this.genderDetails,
//     this.raceDetails,
//     this.firstName,
//     this.lastName,
//     this.mobileNumber,
//     this.email,
//     this.addressLine1,
//     this.addressLine2,
//     this.city,
//     this.areaCode,
//     this.dateOfBirth,
//     this.totalOrders,
//     this.spentTillNow,
//     this.lastPurchaseDate,
//     this.companyName,
//     this.companyRegistrationNumber,
//     this.companyTaxNumber,
//     this.companyPhone,
//     this.notes,
//     this.photoUrl,
//     this.availableLoyaltyPoints,
//     this.membershipId,
//     this.registeredAt,
//     this.cardNumber,
//     this.store,
//     this.membership,
//     this.iosDigitalPassLink,
//     this.androidDigitalPassLink,
//     this.company,});
//
//   MemberDetails.fromJson(dynamic json) {
//     id = json['id'];
//
//     typeDetails = json['type_details'] != null ? TypeDetails.fromJson(json['type_details']) : null;
//     titleDetails = json['title_details'] != null ? TitleDetails.fromJson(json['title_details']) : null;
//     genderDetails = json['gender_details'] != null ? GenderDetails.fromJson(json['gender_details']) : null;
//     raceDetails = json['race_details'] != null ? RaceDetails.fromJson(json['race_details']) : null;
//
//
//     firstName = json['first_name'].toString();
//     lastName = json['last_name'].toString();
//     mobileNumber = json['mobile_number'].toString();
//     email = json['email'].toString();
//     addressLine1 = json['address_line_1'].toString();
//     addressLine2 = json['address_line_2'].toString();
//     city = json['city'].toString();
//     areaCode = json['area_code'].toString();
//     dateOfBirth = json['date_of_birth'].toString();
//     totalOrders = json['total_orders'].toString();
//     spentTillNow = json['spent_till_now'].toString();
//     lastPurchaseDate = json['last_purchase_date'].toString();
//     companyName = json['company_name'].toString();
//     companyRegistrationNumber = json['company_registration_number'].toString();
//     companyTaxNumber = json['company_tax_number'].toString();
//     companyPhone = json['company_phone'].toString();
//     notes = json['notes'].toString();
//     photoUrl = json['photo_url'].toString();
//     availableLoyaltyPoints = json['available_loyalty_points'].toString();
//     membershipId = json['membership_id'].toString();
//     registeredAt = json['registered_at'].toString();
//     cardNumber = json['card_number'].toString();
//     store = json['store'].toString();
//     membership = json['membership'].toString();
//     iosDigitalPassLink = json['ios_digital_pass_link'].toString();
//     androidDigitalPassLink = json['android_digital_pass_link'].toString();
//     company = json['company'] != null ? Company.fromJson(json['company']) : null;
//   }
//   int? id;
//   TypeDetails? typeDetails;
//   TitleDetails? titleDetails;
//   GenderDetails? genderDetails;
//   RaceDetails? raceDetails;
//   String? firstName;
//   String? lastName;
//   String? mobileNumber;
//   String? email;
//   String? addressLine1;
//   String? addressLine2;
//   String? city;
//   String? areaCode;
//   String? dateOfBirth;
//   String? totalOrders;
//   String? spentTillNow;
//   String? lastPurchaseDate;
//   String? companyName;
//   String? companyRegistrationNumber;
//   String? companyTaxNumber;
//   String? companyPhone;
//   String? notes;
//   String? photoUrl;
//   String? availableLoyaltyPoints;
//   String? membershipId;
//   String? registeredAt;
//   String? cardNumber;
//   String? store;
//   String? membership;
//   String? iosDigitalPassLink;
//   String? androidDigitalPassLink;
//   Company? company;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['type_details'] = typeDetails;
//     map['title_details'] = titleDetails;
//     map['gender_details'] = genderDetails;
//     map['race_details'] = raceDetails;
//
//
//
//     map['first_name'] = firstName;
//     map['last_name'] = lastName;
//     map['mobile_number'] = mobileNumber;
//     map['email'] = email;
//     map['address_line_1'] = addressLine1;
//     map['address_line_2'] = addressLine2;
//     map['city'] = city;
//     map['area_code'] = areaCode;
//     map['date_of_birth'] = dateOfBirth;
//     map['total_orders'] = totalOrders;
//     map['spent_till_now'] = spentTillNow;
//     map['last_purchase_date'] = lastPurchaseDate;
//     map['company_name'] = companyName;
//     map['company_registration_number'] = companyRegistrationNumber;
//     map['company_tax_number'] = companyTaxNumber;
//     map['company_phone'] = companyPhone;
//     map['notes'] = notes;
//     map['photo_url'] = photoUrl;
//     map['available_loyalty_points'] = availableLoyaltyPoints;
//     map['membership_id'] = membershipId;
//     map['registered_at'] = registeredAt;
//     map['card_number'] = cardNumber;
//     map['store'] = store;
//     map['membership'] = membership;
//     map['ios_digital_pass_link'] = iosDigitalPassLink;
//     map['android_digital_pass_link'] = androidDigitalPassLink;
//     if (company != null) {
//       map['company'] = company?.toJson();
//     }
//     return map;
//   }
//
// }

/// id : 1
/// name : "ARIANI TEXTILES & MANUFACTURING (M) SDN. BHD."
/// code : "AR"

class Company {
  Company({
    this.id,
    this.name,
    this.code,});

  Company.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    code = json['code'].toString();
  }
  int? id;
  String? name;
  String? code;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['code'] = code;
    return map;
  }

}

/// id : 1
/// name : "Malay"
/// key : "MALAY"

class RaceDetails {
  RaceDetails({
    this.id,
    this.name,
    this.key,});

  RaceDetails.fromJson(dynamic json) {
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

/// id : 2
/// name : "Female"
/// key : "FEMALE"

class GenderDetails {
  GenderDetails({
    this.id,
    this.name,
    this.key,});

  GenderDetails.fromJson(dynamic json) {
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

/// id : 9
/// name : "Mrs"
/// key : "MRS"

class TitleDetails {
  TitleDetails({
    this.id,
    this.name,
    this.key,});

  TitleDetails.fromJson(dynamic json) {
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

/// id : 2
/// name : "Regular"
/// key : "REGULAR"

class TypeDetails {
  TypeDetails({
    this.id,
    this.name,
    this.key,});

  TypeDetails.fromJson(dynamic json) {
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