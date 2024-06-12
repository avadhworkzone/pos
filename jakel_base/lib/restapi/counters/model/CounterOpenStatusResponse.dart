import 'dart:convert';

/// isCounterOpened : false
/// isCounterClosed : false

CounterOpenStatusResponse counterOpenStatusResponseFromJson(String str) =>
    CounterOpenStatusResponse.fromJson(json.decode(str));

String counterOpenStatusResponseToJson(CounterOpenStatusResponse data) =>
    json.encode(data.toJson());

class CounterOpenStatusResponse {
  CounterOpenStatusResponse({
    this.isCounterOpened,
    this.isCounterClosed,
  });

  CounterOpenStatusResponse.fromJson(dynamic json) {
    isCounterOpened = json['isCounterOpened'];
    isCounterClosed = json['isCounterClosed'];
  }

  bool? isCounterOpened;
  bool? isCounterClosed;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isCounterOpened'] = isCounterOpened;
    map['isCounterClosed'] = isCounterClosed;
    return map;
  }
}
