import 'dart:convert';

/// counter_id : 1
/// opening_balance : 5.0

OpenCounterRequest openCounterRequestFromJson(String str) =>
    OpenCounterRequest.fromJson(json.decode(str));

String openCounterRequestToJson(OpenCounterRequest data) =>
    json.encode(data.toJson());

class OpenCounterRequest {
  OpenCounterRequest({
    int? counterId,
    double? openingBalance,
    String? openedByPosAt,
    bool? isSyncedToCloud, // Used Locally only.
    String? closedByPosAt, // Used Locally only.
    int? counterUpdateId,
  }) {
    _counterId = counterId;
    _openingBalance = openingBalance;
    _openedByPosAt = openedByPosAt;
    _isSyncedToCloud = isSyncedToCloud; // Used Locally only.
    _closedByPosAt = closedByPosAt; // Used Locally only.
    _counterUpdateId = counterUpdateId; // Used Locally only.
  }

  OpenCounterRequest.fromJson(dynamic json) {
    _counterId = json['counter_id'];
    _openingBalance = json['opening_balance'];
    _openedByPosAt = json['opened_by_pos_at'];
    _isSyncedToCloud = json['isSyncedToCloud']; // Used Locally only.
    _closedByPosAt = json['closedByPosAt']; // Used Locally only.
    _counterUpdateId = json['counterUpdateId']; // Used Locally only.
  }

  int? _counterId;
  double? _openingBalance;
  String? _openedByPosAt;
  bool? _isSyncedToCloud; // Used Locally only.
  String? _closedByPosAt; // Used Locally only.
  int? _counterUpdateId; // Used Locally only.

  int? get counterId => _counterId;

  double? get openingBalance => _openingBalance;

  String? get openedByPosAt => _openedByPosAt;

  String? get closedByPosAt => _closedByPosAt;

  bool? get isSyncedToCloud => _isSyncedToCloud; // Used Locally only.

  int? get counterUpdateId => _counterUpdateId; // Used Locally only.

  // Used Locally only.
  setIsSyncedToCloud(bool isSyncedToCloud) {
    _isSyncedToCloud = isSyncedToCloud;
  }

  // Used Locally only.
  setCounterUpdateId(int? counterUpdatedId) {
    _counterUpdateId = counterUpdatedId;
  }

  // Used Locally only.
  setClosedAt(String closedByPosAt) {
    _closedByPosAt = closedByPosAt;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['counter_id'] = _counterId;
    map['opening_balance'] = _openingBalance;
    map['opened_by_pos_at'] = _openedByPosAt;
    map['isSyncedToCloud'] = _isSyncedToCloud; // Used Locally only.
    map['closedByPosAt'] = _closedByPosAt; // Used Locally only.
    map['counterUpdateId'] = _counterUpdateId; // Used Locally only.
    return map;
  }
}
