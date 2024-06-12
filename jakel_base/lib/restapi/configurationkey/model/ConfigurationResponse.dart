import 'dart:convert';

/// url : "https://devpos.jakel.my"

ConfigurationResponse configurationResponseFromJson(String str) =>
    ConfigurationResponse.fromJson(json.decode(str));

String configurationResponseToJson(ConfigurationResponse data) =>
    json.encode(data.toJson());

class ConfigurationResponse {
  ConfigurationResponse({this.url, this.message});

  ConfigurationResponse.fromJson(dynamic json) {
    url = json['url'];
    message = json['message'];
  }

  String? url;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url'] = url;
    map['message'] = message;
    return map;
  }
}
