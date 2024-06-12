
/// grant_type : 0129505989
/// client_id : 0129505989
/// client_secret : 0129505989
/// username : 0129505989
/// password : 0129505989
/// scope : *


class StoreManagerLoginScreenRequest {
  StoreManagerLoginScreenRequest({
    String? grantType,
    String? clientId,
    String? clientSecret,
    String? userName,
    String? password,
    String? scope,
  }){
    _grantType = grantType;
    _clientId = clientId;
    _clientSecret = clientSecret;
    _userName = userName;
    _password = password;
    _scope = scope;
  }

  StoreManagerLoginScreenRequest.fromJson(dynamic json) {
    _grantType = json['grant_type'];
    _clientId = json['client_id'];
    _clientSecret = json['client_secret'];
    _userName = json['username'];
    _password = json['password'];
    _scope = json['scope'];
  }
  String? _grantType;
  String? _clientId;
  String? _clientSecret;
  String? _userName;
  String? _password;
  String? _scope;

  String? get grantType => _grantType;
  String? get clientId => _clientId;
  String? get clientSecret => _clientSecret;
  String? get userName => _userName;
  String? get password => _password;
  String? get scope => _scope;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['grant_type'] = _grantType;
    map['client_id'] = _clientId;
    map['client_secret'] = _clientSecret;
    map['username'] = _userName;
    map['password'] = _password;
    map['scope'] = _scope;
    return map;
  }
}