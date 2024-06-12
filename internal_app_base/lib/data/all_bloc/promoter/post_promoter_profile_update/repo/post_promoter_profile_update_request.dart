
/// first_name : 0129505989
/// mobile_number : 0129505989
/// address_line_1 : *
/// address_line_2 : *
/// username : *\
/// city : *
/// area_code : *
/// primary_contact_name : *
/// primary_contact_phone : *
/// email : 0129505989

//////// 
/// last_name : 0129505989
/// home_contact : 0129505989
/// photo : *


class PostPromoterProfileUpdateRequest {
  PostPromoterProfileUpdateRequest({
    String? firstName,
    String? email,
    String? mobileNumber,
    String? addressLine1,
    String? userName,
    String? addressLine2,
    String? city,
    String? areaCode,
    String? primaryContactName,
    String? primaryContactPhone,
  }){
    _firstName = firstName;
    _email = email;
    _mobileNumber = mobileNumber;
    _addressLine1 = addressLine1;
    _userName = userName;
    _addressLine2 = addressLine2;
    _city = city;
    _areaCode = areaCode;
    _primaryContactName = primaryContactName;
    _primaryContactPhone = primaryContactPhone;
  }

  PostPromoterProfileUpdateRequest.fromJson(dynamic json) {
    _firstName = json['first_name'];
    _email = json['email'];
    _mobileNumber = json['mobile_number'];
    _addressLine1 = json['address_line_1'];
    _userName = json['username'];
    _addressLine2 = json['address_line_2'];
    _city = json['city'];
    _areaCode = json['area_code'];
    _primaryContactName = json['primary_contact_name'];
    _primaryContactPhone = json['primary_contact_phone'];
  }
  String? _firstName;
  String? _email;
  String? _mobileNumber;
  String? _addressLine1;
  String? _userName;
  String? _addressLine2;
  String? _city;
  String? _areaCode;
  String? _primaryContactName;
  String? _primaryContactPhone;

  String? get firstName => _firstName;
  String? get email => _email;
  String? get mobileNumber => _mobileNumber;
  String? get addressLine1 => _addressLine1;
  String? get userName => _userName;
  String? get addressLine2 => _addressLine2;
  String? get city => _city;
  String? get areaCode => _areaCode;
  String? get primaryContactName => _primaryContactName;
  String? get primaryContactPhone => _primaryContactPhone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_name'] = _firstName;
    map['email'] = _email;
    map['mobile_number'] = _mobileNumber;
    map['address_line_1'] = _addressLine1;
    map['username'] = _userName;
    map['address_line_2'] = _addressLine2;
    map['city'] = _city;
    map['area_code'] = _areaCode;
    map['primary_contact_name'] = _primaryContactName;
    map['primary_contact_phone'] = _primaryContactPhone;
    /// last_name : 0129505989
    /// home_contact : 0129505989
    /// photo : *
    return map;
  }
}