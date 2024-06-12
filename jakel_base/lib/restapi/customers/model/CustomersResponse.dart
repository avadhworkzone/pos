import 'dart:convert';

import 'package:jakel_base/restapi/customers/model/MemberGroupResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';

/// customers : [{"id":1,"type_details":{"id":1,"name":"VIP"},"title_details":{"id":2,"name":"DATIN_SERI"},"gender_details":{"id":1,"name":"MALE"},"race_details":{"id":2,"name":"CHINESE"},"first_name":"Test121212","last_name":"Test","mobile_number":"132 35","email":"test@gmail.com","address_line_1":"test","address_line_2":"teas","city":"test","area_code":"123122","date_of_birth":"2020-01-01","total_orders":0,"spent_till_now":4221.83,"last_purchase_date":"2022-10-02 09:24:08","photo_url":"","total_loyalty_points":261.83,"membership_id":1,"registered_at":"2022-08-06 09:03:15","vouchers":[{"id":17,"voucher_configuration_id":3,"discount_type":"FLAT","number":"3166413335795917001","minimum_spend_amount":120,"percentage":10,"flat_amount":10,"used_at":"2022-12-25","expiry_date":"2022-12-25","exclude_products":[1],"exclude_categories":[2]}]}]
/// total_records : 17
/// last_page : 17
/// current_page : 1
/// per_page : 1

CustomersResponse customersReponseFromJson(String str) =>
    CustomersResponse.fromJson(json.decode(str));

String customersResponseToJson(CustomersResponse data) =>
    json.encode(data.toJson());

class CustomersResponse {
  CustomersResponse({
    this.members,
    this.customer,
    this.totalRecords,
    this.lastPage,
    this.currentPage,
    this.perPage,
    this.message,
  });

  CustomersResponse.fromJson(dynamic json) {
    if (json['members'] != null) {
      members = [];
      json['members'].forEach((v) {
        members?.add(Customers.fromJson(v));
      });
    }

    if (json['member'] != null) {
      customer = json['member'] != null
          ? Customers.fromJson(json['member'])
          : null;
    }
    totalRecords = json['total_records'];
    lastPage = json['last_page'];
    currentPage = json['current_page'];
    perPage = json['per_page'];
    message = json['message'];
  }

  List<Customers>? members;
  Customers? customer;
  int? totalRecords;
  int? lastPage;
  int? currentPage;
  int? perPage;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (members != null) {
      map['members'] = members?.map((v) => v.toJson()).toList();
    }
    map['total_records'] = totalRecords;
    map['last_page'] = lastPage;
    map['current_page'] = currentPage;
    map['per_page'] = perPage;
    map['message'] = message;
    return map;
  }
}

/// id : 1
/// type_details : {"id":1,"name":"VIP"}
/// title_details : {"id":2,"name":"DATIN_SERI"}
/// gender_details : {"id":1,"name":"MALE"}
/// race_details : {"id":2,"name":"CHINESE"}
/// first_name : "Test121212"
/// last_name : "Test"
/// mobile_number : "132 35"
/// email : "test@gmail.com"
/// address_line_1 : "test"
/// address_line_2 : "teas"
/// city : "test"
/// area_code : "123122"
/// date_of_birth : "2020-01-01"
/// total_orders : 0
/// spent_till_now : 4221.83
/// last_purchase_date : "2022-10-02 09:24:08"
/// photo_url : ""
/// total_loyalty_points : 261.83
/// membership_id : 1
/// registered_at : "2022-08-06 09:03:15"
/// vouchers : [{"id":17,"voucher_configuration_id":3,"discount_type":"FLAT","number":"3166413335795917001","minimum_spend_amount":120,"percentage":10,"flat_amount":10,"used_at":"2022-12-25","expiry_date":"2022-12-25","exclude_products":[1],"exclude_categories":[2]}]

Customers customersFromJson(String str) => Customers.fromJson(json.decode(str));

String customersToJson(Customers data) => json.encode(data.toJson());

class Customers {
  Customers({
    this.id,
    this.typeDetails,
    this.titleDetails,
    this.genderDetails,
    this.raceDetails,
    this.memberGroup,
    this.firstName,
    this.lastName,
    this.mobileNumber,
    this.email,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.areaCode,
    this.dateOfBirth,
    this.totalOrders,
    this.spentTillNow,
    this.lastPurchaseDate,
    this.photoUrl,
    this.totalLoyaltyPoints,
    this.membershipId,
    this.registeredAt,
    this.customerVouchers,
    this.companyName,
    this.companyRegistrationNumber,
    this.companyTax,
    this.companyPhone,
    this.notes,
    this.cardNumber,
    this.voucherGenerated,
  });

  Customers.fromJson(dynamic json) {
    id = json['id'];
    typeDetails = json['type_details'] != null
        ? TypeDetails.fromJson(json['type_details'])
        : null;
    titleDetails = json['title_details'] != null
        ? TitleDetails.fromJson(json['title_details'])
        : null;
    genderDetails = json['gender_details'] != null
        ? GenderDetails.fromJson(json['gender_details'])
        : null;
    raceDetails = json['race_details'] != null
        ? RaceDetails.fromJson(json['race_details'])
        : null;
    memberGroup =
        json['group'] != null ? MemberGroup.fromJson(json['group']) : null;

    firstName = json['first_name'];
    lastName = json['last_name'];
    mobileNumber = json['mobile_number'];
    email = json['email'];
    addressLine1 = json['address_line_1'];
    addressLine2 = json['address_line_2'];
    city = json['city'];
    areaCode = json['area_code'];
    dateOfBirth = json['date_of_birth'];
    totalOrders = json['total_orders'];
    spentTillNow = getDoubleValue(json['spent_till_now']);
    lastPurchaseDate = json['last_purchase_date'];
    photoUrl = json['photo_url'];
    totalLoyaltyPoints = getDoubleValue(json['total_loyalty_points']);
    membershipId = json['membership_id'];
    registeredAt = json['registered_at'];
    companyName = json['company_name'];
    companyRegistrationNumber = json['company_registration_number'];
    companyTax = json['company_tax'];
    companyPhone = json['company_phone'];
    notes = json['notes'];
    cardNumber = json['card_number'];
    voucherGenerated = json['voucher_generated'];
    if (json['vouchers'] != null) {
      customerVouchers = [];
      json['vouchers'].forEach((v) {
        customerVouchers?.add(CustomerVouchers.fromJson(v));
      });
    }
  }

  int? id;
  TypeDetails? typeDetails;
  TitleDetails? titleDetails;
  GenderDetails? genderDetails;
  RaceDetails? raceDetails;
  MemberGroup? memberGroup;
  String? firstName;
  String? lastName;
  String? mobileNumber;
  String? email;
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? areaCode;
  String? dateOfBirth;

  String? companyName;
  String? companyRegistrationNumber;
  String? companyTax;
  String? companyPhone;
  String? notes;
  String? cardNumber;
  int? totalOrders;
  double? spentTillNow;
  String? lastPurchaseDate;
  String? photoUrl;
  double? totalLoyaltyPoints;
  int? membershipId;
  String? registeredAt;
  List<CustomerVouchers>? customerVouchers;
  bool? voucherGenerated;

  Customers copyWith({
    int? id,
    TypeDetails? typeDetails,
    TitleDetails? titleDetails,
    GenderDetails? genderDetails,
    RaceDetails? raceDetails,
    MemberGroup? memberGroup,
    String? firstName,
    String? lastName,
    String? mobileNumber,
    String? email,
    String? cardNumber,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? areaCode,
    String? dateOfBirth,
    String? companyName,
    String? companyRegistrationNumber,
    String? companyTax,
    String? companyPhone,
    String? notes,
    int? totalOrders,
    double? spentTillNow,
    String? lastPurchaseDate,
    String? photoUrl,
    double? totalLoyaltyPoints,
    int? membershipId,
    String? registeredAt,
    List<CustomerVouchers>? customerVouchers,
    bool? voucherGenerated,
  }) =>
      Customers(
          id: id ?? this.id,
          cardNumber: cardNumber ?? this.cardNumber,
          typeDetails: typeDetails ?? this.typeDetails,
          titleDetails: titleDetails ?? this.titleDetails,
          genderDetails: genderDetails ?? this.genderDetails,
          raceDetails: raceDetails ?? this.raceDetails,
          memberGroup: memberGroup ?? this.memberGroup,
          firstName: firstName ?? this.firstName,
          lastName: lastName ?? this.lastName,
          mobileNumber: mobileNumber ?? this.mobileNumber,
          email: email ?? this.email,
          addressLine1: addressLine1 ?? this.addressLine1,
          addressLine2: addressLine2 ?? this.addressLine2,
          city: city ?? this.city,
          areaCode: areaCode ?? this.areaCode,
          dateOfBirth: dateOfBirth ?? this.dateOfBirth,
          totalOrders: totalOrders ?? this.totalOrders,
          spentTillNow: spentTillNow ?? this.spentTillNow,
          lastPurchaseDate: lastPurchaseDate ?? this.lastPurchaseDate,
          photoUrl: photoUrl ?? this.photoUrl,
          companyName: companyName ?? this.companyName,
          companyRegistrationNumber:
          companyRegistrationNumber ?? this.companyRegistrationNumber,
          companyTax: companyTax ?? this.companyTax,
          companyPhone: companyPhone ?? this.companyPhone,
          notes: notes ?? this.notes,
          totalLoyaltyPoints: totalLoyaltyPoints ?? this.totalLoyaltyPoints,
          membershipId: membershipId ?? this.membershipId,
          registeredAt: registeredAt ?? this.registeredAt,
          customerVouchers: customerVouchers ?? this.customerVouchers,
          voucherGenerated: voucherGenerated ?? this.voucherGenerated);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    if (typeDetails != null) {
      map['type_details'] = typeDetails?.toJson();
    }
    if (titleDetails != null) {
      map['title_details'] = titleDetails?.toJson();
    }
    if (genderDetails != null) {
      map['gender_details'] = genderDetails?.toJson();
    }
    if (raceDetails != null) {
      map['race_details'] = raceDetails?.toJson();
    }

    if (memberGroup != null) {
      map['group'] = memberGroup?.toJson();
    }

    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['mobile_number'] = mobileNumber;
    map['email'] = email;
    map['address_line_1'] = addressLine1;
    map['address_line_2'] = addressLine2;
    map['city'] = city;
    map['area_code'] = areaCode;
    map['date_of_birth'] = dateOfBirth;
    map['total_orders'] = totalOrders;
    map['spent_till_now'] = spentTillNow;
    map['last_purchase_date'] = lastPurchaseDate;
    map['photo_url'] = photoUrl;
    map['total_loyalty_points'] = totalLoyaltyPoints;
    map['membership_id'] = membershipId;
    map['registered_at'] = registeredAt;

    map['company_name'] = companyName;
    map['company_registration_number'] = companyRegistrationNumber;
    map['company_tax'] = companyTax;
    map['company_phone'] = companyPhone;
    map['notes'] = notes;
    map['card_number'] = cardNumber;
    if (customerVouchers != null) {
      map['vouchers'] = customerVouchers?.map((v) => v.toJson()).toList();
    }
    map['voucher_generated'] = voucherGenerated;

    return map;
  }
}

/// id : 17
/// voucher_configuration_id : 3
/// discount_type : "FLAT"
/// number : "3166413335795917001"
/// minimum_spend_amount : 120
/// percentage : 10
/// flat_amount : 10
/// used_at : "2022-12-25"
/// expiry_date : "2022-12-25"
/// exclude_products : [1]
/// exclude_categories : [2]

CustomerVouchers customerVouchersFromJson(String str) =>
    CustomerVouchers.fromJson(json.decode(str));

String customerVouchersToJson(CustomerVouchers data) =>
    json.encode(data.toJson());

class CustomerVouchers {
  CustomerVouchers({
    this.id,
    this.voucherConfigurationId,
    this.discountType,
    this.number,
    this.voucherType,
    this.minimumSpendAmount,
    this.percentage,
    this.flatAmount,
    this.usedAt,
    this.expiryDate,
    this.excludeProducts,
    this.excludeCategories,
  });

  CustomerVouchers.fromJson(dynamic json) {
    id = json['id'];
    voucherConfigurationId = json['voucher_configuration_id'];
    discountType = json['discount_type'];
    number = json['number'];
    voucherType = json['voucher_type'];
    minimumSpendAmount = getDoubleValue(json['minimum_spend_amount']);
    percentage = getDoubleValue(json['percentage']);
    flatAmount = getDoubleValue(json['flat_amount']);
    usedAt = json['used_at'];
    expiryDate = json['expiry_date'];
    excludeProducts = json['exclude_products'] != null
        ? json['exclude_products'].cast<int>()
        : [];
    excludeCategories = json['exclude_categories'] != null
        ? json['exclude_categories'].cast<int>()
        : [];
  }

  int? id;
  int? voucherConfigurationId;
  String? discountType;
  String? voucherType;
  String? number;
  double? minimumSpendAmount;
  double? percentage;
  double? flatAmount;
  String? usedAt;
  String? expiryDate;
  List<int>? excludeProducts;
  List<int>? excludeCategories;

  CustomerVouchers copyWith({
    int? id,
    int? voucherConfigurationId,
    String? discountType,
    String? voucherType,
    String? number,
    double? minimumSpendAmount,
    double? percentage,
    double? flatAmount,
    String? usedAt,
    String? expiryDate,
    List<int>? excludeProducts,
    List<int>? excludeCategories,
  }) =>
      CustomerVouchers(
        id: id ?? this.id,
        voucherConfigurationId:
        voucherConfigurationId ?? this.voucherConfigurationId,
        discountType: discountType ?? this.discountType,
        voucherType: voucherType ?? this.voucherType,
        number: number ?? this.number,
        minimumSpendAmount: minimumSpendAmount ?? this.minimumSpendAmount,
        percentage: percentage ?? this.percentage,
        flatAmount: flatAmount ?? this.flatAmount,
        usedAt: usedAt ?? this.usedAt,
        expiryDate: expiryDate ?? this.expiryDate,
        excludeProducts: excludeProducts ?? this.excludeProducts,
        excludeCategories: excludeCategories ?? this.excludeCategories,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['voucher_configuration_id'] = voucherConfigurationId;
    map['discount_type'] = discountType;
    map['number'] = number;
    map['minimum_spend_amount'] = minimumSpendAmount;
    map['percentage'] = percentage;
    map['voucher_type'] = voucherType;
    map['flat_amount'] = flatAmount;
    map['used_at'] = usedAt;
    map['expiry_date'] = expiryDate;
    map['exclude_products'] = excludeProducts;
    map['exclude_categories'] = excludeCategories;
    return map;
  }
}

/// id : 2
/// name : "CHINESE"

RaceDetails raceDetailsFromJson(String str) =>
    RaceDetails.fromJson(json.decode(str));

String raceDetailsToJson(RaceDetails data) => json.encode(data.toJson());

class RaceDetails {
  RaceDetails({
    this.id,
    this.name,
  });

  RaceDetails.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }

  int? id;
  String? name;

  RaceDetails copyWith({
    int? id,
    String? name,
  }) =>
      RaceDetails(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}

/// id : 1
/// name : "MALE"

GenderDetails genderDetailsFromJson(String str) =>
    GenderDetails.fromJson(json.decode(str));

String genderDetailsToJson(GenderDetails data) => json.encode(data.toJson());

class GenderDetails {
  GenderDetails({
    this.id,
    this.name,
  });

  GenderDetails.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }

  int? id;
  String? name;

  GenderDetails copyWith({
    int? id,
    String? name,
  }) =>
      GenderDetails(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}

/// id : 2
/// name : "DATIN_SERI"

TitleDetails titleDetailsFromJson(String str) =>
    TitleDetails.fromJson(json.decode(str));

String titleDetailsToJson(TitleDetails data) => json.encode(data.toJson());

class TitleDetails {
  TitleDetails({
    this.id,
    this.name,
  });

  TitleDetails.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }

  int? id;
  String? name;

  TitleDetails copyWith({
    int? id,
    String? name,
  }) =>
      TitleDetails(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}

/// id : 1
/// name : "VIP"

TypeDetails typeDetailsFromJson(String str) =>
    TypeDetails.fromJson(json.decode(str));

String typeDetailsToJson(TypeDetails data) => json.encode(data.toJson());

class TypeDetails {
  TypeDetails({
    this.id,
    this.name,
  });

  TypeDetails.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }

  int? id;
  String? name;

  TypeDetails copyWith({
    int? id,
    String? name,
  }) =>
      TypeDetails(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}
