/// message : "Oops! The record could not be found!"

class WebResponseErrorMessage {
  WebResponseErrorMessage({
      this.message,});

  WebResponseErrorMessage.fromJson(dynamic json) {
    message = json['message'];
  }
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    return map;
  }

}