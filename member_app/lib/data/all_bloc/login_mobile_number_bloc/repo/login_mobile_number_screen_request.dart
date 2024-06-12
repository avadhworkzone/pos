
/// mobile_number : 0129505989


class LoginMobileNumberScreenRequest {
  LoginMobileNumberScreenRequest({
    String? mobileNumber,}){
    _mobileNumber = mobileNumber;
  }

  LoginMobileNumberScreenRequest.fromJson(dynamic json) {
    _mobileNumber = json['mobile_number'];
  }
  String? _mobileNumber;

  String? get mobileNumber => _mobileNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['mobile_number'] = _mobileNumber;
    return map;
  }
}