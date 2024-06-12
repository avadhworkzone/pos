import 'dart:convert';

import 'package:jakel_base/restapi/BaseResponse.dart';

/// cashier : {"username":"cashier","last_login_at":"2022-05-23 11:02:44"}
/// token : "17|OLEPMSHNKPJ2mCdBEsKeHKNXnbQITV1nKpxj0d73"

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    Cashier? cashier,
    String? token,
    String? message,
  }) {
    _cashier = cashier;
    _token = token;
    _message = message;
  }

  LoginResponse.fromJson(dynamic json) {
    _cashier =
        json['cashier'] != null ? Cashier.fromJson(json['cashier']) : null;
    _token = json['token'];
    _message = json['message'];
  }

  Cashier? _cashier;
  String? _token;
  String? _message;

  Cashier? get cashier => _cashier;

  String? get token => _token;

  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_cashier != null) {
      map['cashier'] = _cashier?.toJson();
    }
    map['token'] = _token;
    map['message'] = _message;
    return map;
  }
}

/// username : "cashier"
/// last_login_at : "2022-05-23 11:02:44"

Cashier cashierFromJson(String str) => Cashier.fromJson(json.decode(str));

String cashierToJson(Cashier data) => json.encode(data.toJson());

class Cashier {
  Cashier({
    String? username,
    String? lastLoginAt,
  }) {
    _username = username;
    _lastLoginAt = lastLoginAt;
  }

  Cashier.fromJson(dynamic json) {
    _username = json['username'];
    _lastLoginAt = json['last_login_at'];
  }

  String? _username;
  String? _lastLoginAt;

  Cashier copyWith({
    String? username,
    String? lastLoginAt,
  }) =>
      Cashier(
        username: username ?? _username,
        lastLoginAt: lastLoginAt ?? _lastLoginAt,
      );

  String? get username => _username;

  String? get lastLoginAt => _lastLoginAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = _username;
    map['last_login_at'] = _lastLoginAt;
    return map;
  }
}
