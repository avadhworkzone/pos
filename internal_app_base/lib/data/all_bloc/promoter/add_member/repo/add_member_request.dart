class AddMemberRequest {
  AddMemberRequest({
    String? firstName,
    String? mobileNumber,
    String? email,
    String? dateOfBirth,
  }) {
    _firstName = firstName;
    _mobileNumber = mobileNumber;
    _email = email;
    _dateOfBirth = dateOfBirth;
  }

  String? _firstName;
  String? _mobileNumber;
  String? _email;
  String? _dateOfBirth;

  String? get firstName => _firstName;
  String? get mobileNumber => _mobileNumber;
  String? get email => _email;
  String? get dateOfBirth => _dateOfBirth;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_name'] = _firstName;
    map['mobile_number'] = _mobileNumber;
    map['email'] = _email;
    map['date_of_birth'] = _dateOfBirth;

    return map;
  }
}
