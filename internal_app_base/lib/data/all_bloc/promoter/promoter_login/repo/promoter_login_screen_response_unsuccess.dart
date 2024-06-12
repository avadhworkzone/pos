/// error : "invalid_grant"
/// error_description : "The user credentials were incorrect."
/// message : "The user credentials were incorrect."

class PromoterLoginScreenResponseUnSuccess {
  PromoterLoginScreenResponseUnSuccess({
    this.error,
    this.errorDescription,
    this.message,});

  PromoterLoginScreenResponseUnSuccess.fromJson(dynamic json) {
    error = json['error'];
    errorDescription = json['error_description'];
    message = json['message'];
  }
  String? error;
  String? errorDescription;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = error;
    map['error_description'] = errorDescription;
    map['message'] = message;
    return map;
  }

}