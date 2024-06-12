/// promoter_details : {"id":1,"username":"12020","employee_id":2,"first_name":"NAZREENA HAKIM BINTI HERMANSYAH","last_name":"","mobile_number":"01114290796","home_contact":"","address_line_1":"52 A JALAN RAJA MUDA MUSA","address_line_2":"","city":"","area_code":"","primary_contact_name":"","primary_contact_phone":"","photo":""}

class GetStoreManagerProfileDetailsResponse {
  GetStoreManagerProfileDetailsResponse({
    this.storeManagerDetails,});

  GetStoreManagerProfileDetailsResponse.fromJson(dynamic json) {
    storeManagerDetails = json['store_manager_details'] != null ? StoreManagerDetails.fromJson(json['store_manager_details']) : null;
  }
  StoreManagerDetails? storeManagerDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (storeManagerDetails != null) {
      map['store_manager_details'] = storeManagerDetails?.toJson();
    }
    return map;
  }

}

/// id : 1
/// username : "12020"
/// employee_id : 2
/// first_name : "NAZREENA HAKIM BINTI HERMANSYAH"
/// last_name : ""
/// mobile_number : "01114290796"
/// home_contact : ""
/// address_line_1 : "52 A JALAN RAJA MUDA MUSA"
/// address_line_2 : ""
/// city : ""
/// area_code : ""
/// primary_contact_name : ""
/// primary_contact_phone : ""
/// photo : ""

class StoreManagerDetails {
  StoreManagerDetails({
    this.id,
    this.username,
    this.email,
    this.employeeId,
    this.firstName,
    this.lastName,
    this.mobileNumber,
    this.homeContact,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.areaCode,
    this.primaryContactName,
    this.primaryContactPhone,
    this.photo,});

  StoreManagerDetails.fromJson(dynamic json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    employeeId = json['employee_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobileNumber = json['mobile_number'];
    homeContact = json['home_contact'];
    addressLine1 = json['address_line_1'];
    addressLine2 = json['address_line_2'];
    city = json['city'];
    areaCode = json['area_code'];
    primaryContactName = json['primary_contact_name'];
    primaryContactPhone = json['primary_contact_phone'];
    photo = json['photo'];
  }
  int? id;
  String? username;
  String? email;
  int? employeeId;
  String? firstName;
  String? lastName;
  String? mobileNumber;
  String? homeContact;
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? areaCode;
  String? primaryContactName;
  String? primaryContactPhone;
  String? photo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['username'] = (username??"").toString();
    map['email'] = (email??"").toString();
    map['employee_id'] = employeeId;
    map['first_name'] = (firstName??"").toString();
    map['last_name'] = (lastName??"").toString();
    map['mobile_number'] = (mobileNumber??"").toString();
    map['home_contact'] = (homeContact??"").toString();
    map['address_line_1'] = (addressLine1??"").toString();
    map['address_line_2'] = (addressLine2??"").toString();
    map['city'] = (city??"").toString();
    map['area_code'] = (areaCode??"").toString();
    map['primary_contact_name'] = (primaryContactName??"").toString();
    map['primary_contact_phone'] = (primaryContactPhone??"").toString();
    map['photo'] = (photo??"").toString();
    return map;
  }

}