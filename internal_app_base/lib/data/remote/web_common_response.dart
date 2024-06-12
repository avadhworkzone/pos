// statusCode : 400
// statusMessage : "Bad Request"
// data :

class WebCommonResponse {
  WebCommonResponse({
    this.statusCode = "",
    this.statusMessage = "",
    this.data = "",
  });

  WebCommonResponse.fromJson(dynamic json) {
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    data = json['data'];
  }

  String statusCode = "";

  String statusMessage = "";

  String data = "";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status_code'] = statusCode;
    map['status_message'] = statusMessage;
    map['data'] = data;
    return map;
  }
}
