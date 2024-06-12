/// mobile_number : 0129505989
/// otp : 9999

class LoginMobileNumberOtpScreenRequest {
  LoginMobileNumberOtpScreenRequest({
    String? mobileNumber,
    String? otp,
  }) {
    _mobileNumber = mobileNumber;
    _otp = otp;
  }

  LoginMobileNumberOtpScreenRequest.fromJson(dynamic json) {
    _mobileNumber = json['mobile_number'];
    _otp = json['otp'];
  }

  String? _mobileNumber;
  String? _otp;

  String? get mobileNumber => _mobileNumber;

  String? get otp => _otp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['mobile_number'] = _mobileNumber;
    map['otp'] = _otp;
    return map;
  }
}
