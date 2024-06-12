/// message : "Please enter valid mobile number."
/// errors : {"mobile_number":["Please enter valid mobile number."]}

class LoginMobileNumberScreenResponseUnSuccess {
  LoginMobileNumberScreenResponseUnSuccess({
      this.message, 
      this.errors,});

  LoginMobileNumberScreenResponseUnSuccess.fromJson(dynamic json) {
    message = json['message'];
    errors = json['errors'] != null ? Errors.fromJson(json['errors']) : null;
  }
  String? message;
  Errors? errors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (errors != null) {
      map['errors'] = errors?.toJson();
    }
    return map;
  }

}

/// mobile_number : ["Please enter valid mobile number."]

class Errors {
  Errors({
      this.mobileNumber,});

  Errors.fromJson(dynamic json) {
    mobileNumber = json['mobile_number'] != null ? json['mobile_number'].cast<String>() : [];
  }
  List<String>? mobileNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['mobile_number'] = mobileNumber;
    return map;
  }

}