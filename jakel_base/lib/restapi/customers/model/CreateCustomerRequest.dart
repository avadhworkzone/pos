import 'dart:convert';

/// type_id : 1
/// title_id : 1
/// race_id : 1
/// first_name : ""
/// last_name : ""
/// gender_id : 1
/// date_of_birth : 1
/// mobile_number : ""
/// email : ""
/// address_line_1 : ""
/// address_line_2 : ""
/// city : ""
/// area_code : ""
/// company_name : ""
/// company_registration_number : ""
/// company_tax_number : ""
/// company_phone : ""
/// notes : ""

CreateCustomerRequest createCustomerRequestFromJson(String str) =>
    CreateCustomerRequest.fromJson(json.decode(str));

String createCustomerRequestToJson(CreateCustomerRequest data) =>
    json.encode(data.toJson());

class CreateCustomerRequest {
  CreateCustomerRequest({
    int? typeId,
    int? titleId,
    int? raceId,
    String? firstName,
    String? lastName,
    int? genderId,
    String? dateOfBirth,
    String? mobileNumber,
    String? email,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? areaCode,
    String? companyName,
    String? companyRegistrationNumber,
    String? companyTaxNumber,
    String? companyPhone,
    String? notes,
    String? cardNumber,
  }) {
    _typeId = typeId;
    _titleId = titleId;
    _raceId = raceId;
    _firstName = firstName;
    _lastName = lastName;
    _genderId = genderId;
    _dateOfBirth = dateOfBirth;
    _mobileNumber = mobileNumber;
    _email = email;
    _addressLine1 = addressLine1;
    _addressLine2 = addressLine2;
    _city = city;
    _areaCode = areaCode;
    _companyName = companyName;
    _companyRegistrationNumber = companyRegistrationNumber;
    _companyTaxNumber = companyTaxNumber;
    _companyPhone = companyPhone;
    _notes = notes;
    _cardNumber = cardNumber;
  }

  CreateCustomerRequest.fromJson(dynamic json) {
    _typeId = json['type_id'];
    _titleId = json['title_id'];
    _raceId = json['race_id'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _genderId = json['gender_id'];
    _dateOfBirth = json['date_of_birth'];
    _mobileNumber = json['mobile_number'];
    _email = json['email'];
    _addressLine1 = json['address_line_1'];
    _addressLine2 = json['address_line_2'];
    _city = json['city'];
    _areaCode = json['area_code'];
    _companyName = json['company_name'];
    _companyRegistrationNumber = json['company_registration_number'];
    _companyTaxNumber = json['company_tax_number'];
    _companyPhone = json['company_phone'];
    _notes = json['notes'];
    _cardNumber = json['card_number'];
  }

  int? _typeId;
  int? _titleId;
  int? _raceId;
  String? _firstName;
  String? _lastName;
  int? _genderId;
  String? _dateOfBirth;
  String? _mobileNumber;
  String? _email;
  String? _addressLine1;
  String? _addressLine2;
  String? _city;
  String? _areaCode;
  String? _companyName;
  String? _companyRegistrationNumber;
  String? _companyTaxNumber;
  String? _companyPhone;
  String? _notes;
  String? _cardNumber;

  CreateCustomerRequest copyWith({
    int? typeId,
    int? titleId,
    int? raceId,
    String? firstName,
    String? lastName,
    int? genderId,
    String? dateOfBirth,
    String? mobileNumber,
    String? email,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? areaCode,
    String? companyName,
    String? companyRegistrationNumber,
    String? companyTaxNumber,
    String? companyPhone,
    String? notes,
    String? cardNumber,
  }) =>
      CreateCustomerRequest(
        typeId: typeId ?? _typeId,
        titleId: titleId ?? _titleId,
        raceId: raceId ?? _raceId,
        firstName: firstName ?? _firstName,
        lastName: lastName ?? _lastName,
        genderId: genderId ?? _genderId,
        dateOfBirth: dateOfBirth ?? _dateOfBirth,
        mobileNumber: mobileNumber ?? _mobileNumber,
        email: email ?? _email,
        addressLine1: addressLine1 ?? _addressLine1,
        addressLine2: addressLine2 ?? _addressLine2,
        city: city ?? _city,
        areaCode: areaCode ?? _areaCode,
        companyName: companyName ?? _companyName,
        companyRegistrationNumber:
            companyRegistrationNumber ?? _companyRegistrationNumber,
        companyTaxNumber: companyTaxNumber ?? _companyTaxNumber,
        companyPhone: companyPhone ?? _companyPhone,
        notes: notes ?? _notes,
        cardNumber: cardNumber ?? _cardNumber,
      );

  int? get typeId => _typeId;

  int? get titleId => _titleId;

  int? get raceId => _raceId;

  String? get firstName => _firstName;

  String? get lastName => _lastName;

  int? get genderId => _genderId;

  String? get dateOfBirth => _dateOfBirth;

  String? get mobileNumber => _mobileNumber;

  String? get email => _email;

  String? get addressLine1 => _addressLine1;

  String? get addressLine2 => _addressLine2;

  String? get city => _city;

  String? get areaCode => _areaCode;

  String? get companyName => _companyName;

  String? get companyRegistrationNumber => _companyRegistrationNumber;

  String? get companyTaxNumber => _companyTaxNumber;

  String? get companyPhone => _companyPhone;

  String? get notes => _notes;

  String? get cardNumber => _cardNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_typeId != null) map['type_id'] = _typeId;
    if (_titleId != null) map['title_id'] = _titleId;
    if (_raceId != null) map['race_id'] = _raceId;
    if (_firstName != null) map['first_name'] = _firstName;
    if (_lastName != null) map['last_name'] = _lastName;
    if (_genderId != null) map['gender_id'] = _genderId;
    if (_dateOfBirth != null) map['date_of_birth'] = _dateOfBirth;
    if (_mobileNumber != null) map['mobile_number'] = _mobileNumber;
    if (_email != null) map['email'] = _email;
    if (_addressLine1 != null) map['address_line_1'] = _addressLine1;
    if (_addressLine2 != null) map['address_line_2'] = _addressLine2;
    if (_city != null) map['city'] = _city;
    if (_areaCode != null) map['area_code'] = _areaCode;
    if (_companyName != null) map['company_name'] = _companyName;
    if (_companyRegistrationNumber != null)
      map['company_registration_number'] = _companyRegistrationNumber;
    if (_companyTaxNumber != null)
      map['company_tax_number'] = _companyTaxNumber;
    if (_companyPhone != null) map['company_phone'] = _companyPhone;
    if (_notes != null) map['notes'] = _notes;
    if (_cardNumber != null) map['card_number'] = _cardNumber;

    return map;
  }
}
