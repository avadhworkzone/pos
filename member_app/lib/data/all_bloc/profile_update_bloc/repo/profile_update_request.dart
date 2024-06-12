
// type_id:1
// title_id:1
// race_id:2
// gender_id:1
// first_name:Test Leo
// last_name:Test
// mobile_number:132 35
// email:test@gmail.com
// address_line_1:test
// address_line_2:teas
// city:test
// area_code:123122

class ProfileUpdateRequest {
  ProfileUpdateRequest({
    String? firstName,
    String? lastName,
    String? email,
    String? raceId,
    String? genderId,
    String? titleId,
    String? dateOfBirth,
    String? city,
    String? areaCode,
    String? addressLine1,
    String? addressLine2,
  }){
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _raceId = raceId;
    _genderId = genderId;
    _titleId = titleId;
    _dateOfBirth = dateOfBirth;
    _city = city;
    _areaCode = areaCode;
    _addressLine1 = addressLine1;
    _addressLine2 = addressLine2;
  }

  ProfileUpdateRequest.fromJson(dynamic json) {
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _email = json['email'];
    _raceId = json['race_id'];
    _genderId = json['gender_id'];
    _titleId = json['title_id'];
    _dateOfBirth = json['date_of_birth'];
    _city = json['city'];
    _areaCode = json['area_code'];
    _addressLine1 = json['address_line_1'];
    _addressLine2 = json['address_line_2'];
  }
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _raceId;
  String? _genderId;
  String? _titleId;
  String? _dateOfBirth;
  String? _city;
  String? _areaCode;
  String? _addressLine1;
  String? _addressLine2;

  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get raceId => _raceId;
  String? get genderId => _genderId;
  String? get titleId => _titleId;
  String? get dateOfBirth => _dateOfBirth;
  String? get city => _city;
  String? get areaCode => _areaCode;
  String? get addressLine1 => _addressLine1;
  String? get addressLine2 => _addressLine2;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['email'] = _email;
    map['race_id'] = _raceId;
    map['gender_id'] = _genderId;
    map['title_id'] = _titleId;
    map['date_of_birth'] = _dateOfBirth;
    map['city'] = _city;
    map['area_code'] = _areaCode;
    map['address_line_1'] = _addressLine1;
    map['address_line_2'] = _addressLine2;
    return map;
  }
}