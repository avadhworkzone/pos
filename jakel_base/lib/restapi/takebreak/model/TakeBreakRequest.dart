import 'dart:convert';
/// offlineId : ""
/// takeBreak : true
/// happened_at : ""
/// counterOpenedAt : ""

TakeBreakRequest takeBreakModelFromJson(String str) => TakeBreakRequest.fromJson(json.decode(str));
String takeBreakModelToJson(TakeBreakRequest data) => json.encode(data.toJson());
class TakeBreakRequest {
  TakeBreakRequest({
      this.offlineId, 
      this.takeBreak, 
      this.happenedAt, 
      this.counterOpenedAt,});

  TakeBreakRequest.fromJson(dynamic json) {
    offlineId = json['offlineId'];
    takeBreak = json['takeBreak'];
    happenedAt = json['happened_at'];
    counterOpenedAt = json['counterOpenedAt'];
  }
  String? offlineId;
  bool? takeBreak;
  String? happenedAt;
  String? counterOpenedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['offlineId'] = offlineId;
    map['takeBreak'] = takeBreak;
    map['happened_at'] = happenedAt;
    map['counterOpenedAt'] = counterOpenedAt;
    return map;
  }

}