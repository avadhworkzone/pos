class ProfilePicUpdateResponse {
  ProfilePicUpdateResponse({
    this.message,
    this.status,});

  ProfilePicUpdateResponse.fromJson(dynamic json) {
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