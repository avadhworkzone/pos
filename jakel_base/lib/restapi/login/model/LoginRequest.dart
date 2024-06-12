import 'dart:convert';
/// username : ""
/// pin : ""

LoginRequest loginRequestFromJson(String str) => LoginRequest.fromJson(json.decode(str));
String loginRequestToJson(LoginRequest data) => json.encode(data.toJson());
class LoginRequest {
  LoginRequest({
      String? username, 
      String? pin,}){
    _username = username;
    _pin = pin;
}

  LoginRequest.fromJson(dynamic json) {
    _username = json['username'];
    _pin = json['pin'];
  }
  String? _username;
  String? _pin;
LoginRequest copyWith({  String? username,
  String? pin,
}) => LoginRequest(  username: username ?? _username,
  pin: pin ?? _pin,
);
  String? get username => _username;
  String? get pin => _pin;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = _username;
    map['pin'] = _pin;
    return map;
  }

}