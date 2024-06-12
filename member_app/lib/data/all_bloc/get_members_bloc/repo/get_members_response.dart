import 'package:member_app/data/all_bloc/get_members_details_bloc/repo/member_details.dart';

/// members : [{"id":205436,"type_details":{"id":2,"name":"Regular","key":"REGULAR"},"title_details":{"id":10,"name":"Ms","key":"MS"},"gender_details":{"id":2,"name":"Female","key":"FEMALE"},"race_details":{"id":1,"name":"Malay","key":"MALAY"},"first_name":"SITI FAIRUS FAJILAH BT MAT ZIN","last_name":null,"mobile_number":"0129505989","email":"pe_yuk@gmail.com","address_line_1":"ARIANI PWTC","address_line_2":null,"city":null,"area_code":null,"date_of_birth":null,"total_orders":0,"spent_till_now":92.65,"last_purchase_date":"2023-02-15 01:16:03","company_name":null,"company_registration_number":null,"company_tax_number":null,"company_phone":null,"notes":"PUSPANITA 00022407-1","photo_url":"","available_loyalty_points":192,"membership_id":1,"registered_at":"2023-02-15 13:13:54","card_number":"880522035816","store":"ARIANI GALLERY PWTC","membership":"NORMAL MEMBER","company":{"id":1,"name":"ARIANI TEXTILES & MANUFACTURING (M) SDN. BHD.","code":"AR"}}]

class GetMemberResponse {
  GetMemberResponse({
    this.members,});

  GetMemberResponse.fromJson(dynamic json) {
    if (json['members'] != null) {
      members = [];
      json['members'].forEach((v) {
        members?.add(MemberDetails.fromJson(v));
      });
    }
  }
  List<MemberDetails>? members;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (members != null) {
      map['members'] = members?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

// /// id : 205436
// /// type_details : {"id":2,"name":"Regular","key":"REGULAR"}
// /// title_details : {"id":10,"name":"Ms","key":"MS"}
// /// gender_details : {"id":2,"name":"Female","key":"FEMALE"}
// /// race_details : {"id":1,"name":"Malay","key":"MALAY"}
// /// first_name : "SITI FAIRUS FAJILAH BT MAT ZIN"
// /// last_name : null
// /// mobile_number : "0129505989"
// /// email : "pe_yuk@gmail.com"
// /// address_line_1 : "ARIANI PWTC"
// /// address_line_2 : null
// /// city : null
// /// area_code : null
// /// date_of_birth : null
// /// total_orders : 0
// /// spent_till_now : 92.65
// /// last_purchase_date : "2023-02-15 01:16:03"
// /// company_name : null
// /// company_registration_number : null
// /// company_tax_number : null
// /// company_phone : null
// /// notes : "PUSPANITA 00022407-1"
// /// photo_url : ""
// /// available_loyalty_points : 192
// /// membership_id : 1
// /// registered_at : "2023-02-15 13:13:54"
// /// card_number : "880522035816"
// /// store : "ARIANI GALLERY PWTC"
// /// membership : "NORMAL MEMBER"
// /// company : {"id":1,"name":"ARIANI TEXTILES & MANUFACTURING (M) SDN. BHD.","code":"AR"}
//
// class Members {
//   Members({
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
//     this.company,});
//
//   Members.fromJson(dynamic json) {
//     id = json['id'];
//     typeDetails = json['type_details'] != null ? TypeDetails.fromJson(json['type_details']) : null;
//     titleDetails = json['title_details'] != null ? TitleDetails.fromJson(json['title_details']) : null;
//     genderDetails = json['gender_details'] != null ? GenderDetails.fromJson(json['gender_details']) : null;
//     raceDetails = json['race_details'] != null ? RaceDetails.fromJson(json['race_details']) : null;
//     firstName = json['first_name'];
//     lastName = json['last_name'];
//     mobileNumber = json['mobile_number'];
//     email = json['email'];
//     addressLine1 = json['address_line_1'];
//     addressLine2 = json['address_line_2'];
//     city = json['city'];
//     areaCode = json['area_code'];
//     dateOfBirth = json['date_of_birth'];
//     totalOrders = json['total_orders'];
//     spentTillNow = json['spent_till_now'];
//     lastPurchaseDate = json['last_purchase_date'];
//     companyName = json['company_name'];
//     companyRegistrationNumber = json['company_registration_number'];
//     companyTaxNumber = json['company_tax_number'];
//     companyPhone = json['company_phone'];
//     notes = json['notes'];
//     photoUrl = json['photo_url'];
//     availableLoyaltyPoints = json['available_loyalty_points'];
//     membershipId = json['membership_id'];
//     registeredAt = json['registered_at'];
//     cardNumber = json['card_number'];
//     store = json['store'];
//     membership = json['membership'];
//     company = json['company'] != null ? Company.fromJson(json['company']) : null;
//   }
//   int? id;
//   TypeDetails? typeDetails;
//   TitleDetails? titleDetails;
//   GenderDetails? genderDetails;
//   RaceDetails? raceDetails;
//   String? firstName;
//   dynamic lastName;
//   String? mobileNumber;
//   String? email;
//   String? addressLine1;
//   dynamic addressLine2;
//   dynamic city;
//   dynamic areaCode;
//   dynamic dateOfBirth;
//   int? totalOrders;
//   double? spentTillNow;
//   String? lastPurchaseDate;
//   dynamic companyName;
//   dynamic companyRegistrationNumber;
//   dynamic companyTaxNumber;
//   dynamic companyPhone;
//   String? notes;
//   String? photoUrl;
//   int? availableLoyaltyPoints;
//   int? membershipId;
//   String? registeredAt;
//   String? cardNumber;
//   String? store;
//   String? membership;
//   Company? company;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     if (typeDetails != null) {
//       map['type_details'] = typeDetails?.toJson();
//     }
//     if (titleDetails != null) {
//       map['title_details'] = titleDetails?.toJson();
//     }
//     if (genderDetails != null) {
//       map['gender_details'] = genderDetails?.toJson();
//     }
//     if (raceDetails != null) {
//       map['race_details'] = raceDetails?.toJson();
//     }
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
    code = json['code'];
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

/// id : 10
/// name : "Ms"
/// key : "MS"

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