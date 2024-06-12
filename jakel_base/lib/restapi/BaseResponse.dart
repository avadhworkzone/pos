import 'dart:convert';
/// message : "asdasdf"

BaseResponse baseResponseFromJson(String str) => BaseResponse.fromJson(json.decode(str));
String baseResponseToJson(BaseResponse data) => json.encode(data.toJson());
class BaseResponse {
  BaseResponse({
      this.message,});

  BaseResponse.fromJson(dynamic json) {
    message = json['message'];
  }
  String? message;
BaseResponse copyWith({  String? message,
}) => BaseResponse(  message: message ?? this.message,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    return map;
  }

}