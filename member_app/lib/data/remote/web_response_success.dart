 // error : true
 // statusCode : 400
 // statusMessage : "Bad Request"
 // data : {"message":"Token is Expired"}
 // responseTime : 1639548038

class WebResponseSuccess {
  WebResponseSuccess({
      bool? error, 
      int? statusCode, 
      String? statusMessage, 
      Data? data, 
      int? responseTime,}){
    _error = error;
    _statusCode = statusCode;
    _statusMessage = statusMessage;
    _data = data;
    _responseTime = responseTime;
}

  WebResponseSuccess.fromJson(dynamic json) {
    _error = json['error'];
    _statusCode = json['statusCode'];
    _statusMessage = json['statusMessage'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _responseTime = json['responseTime'];
  }
  bool? _error;
  int? _statusCode;
  String? _statusMessage;
  Data? _data;
  int? _responseTime;

  bool? get error => _error;
  int? get statusCode => _statusCode;
  String? get statusMessage => _statusMessage;
  Data? get data => _data;
  int? get responseTime => _responseTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    map['statusCode'] = _statusCode;
    map['statusMessage'] = _statusMessage;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['responseTime'] = _responseTime;
    return map;
  }

}

/// message : "Token is Expired"

class Data {
  Data({
      String? message,}){
    _message = message;
}

  Data.fromJson(dynamic json) {
    _message = json['message'];
  }
  String? _message;

  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    return map;
  }

}