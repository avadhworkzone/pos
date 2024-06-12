class ProfileDeleteResponse {
  ProfileDeleteResponse({
    this.message,
    this.status,});

  ProfileDeleteResponse.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
  }
  String? message;
  bool? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['status'] = status;
    return map;
  }

}