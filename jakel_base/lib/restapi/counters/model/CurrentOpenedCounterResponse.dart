import 'dart:convert';

import 'package:jakel_base/restapi/counters/model/GetCountersResponse.dart';

/// counter : {"id":72,"counter_update_id":3148,"name":"ARAPWT01","is_locked":false,"opened_at":"2023-05-07 14:52:51"}

CurrentOpenedCounterResponse currentOpenedCounterResponseFromJson(String str) =>
    CurrentOpenedCounterResponse.fromJson(json.decode(str));

String currentOpenedCounterResponseToJson(CurrentOpenedCounterResponse data) =>
    json.encode(data.toJson());

class CurrentOpenedCounterResponse {
  CurrentOpenedCounterResponse({
    this.counter,
  });

  CurrentOpenedCounterResponse.fromJson(dynamic json) {
    counter =
        json['counter'] != null ? Counters.fromJson(json['counter']) : null;
  }

  Counters? counter;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (counter != null) {
      map['counter'] = counter?.toJson();
    }
    return map;
  }
}

/// id : 72
/// counter_update_id : 3148
/// name : "ARAPWT01"
/// is_locked : false
/// opened_at : "2023-05-07 14:52:51"

Counters counterFromJson(String str) => Counters.fromJson(json.decode(str));

String counterToJson(Counters data) => json.encode(data.toJson());
