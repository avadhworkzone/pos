import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

/// closing_balance : 10.05
/// mismatch_amount_reason : ""
/// denominations : [{"denomination":10.50,"quantity":1}]

CloseCounterRequest closeCounterRequestFromJson(String str) =>
    CloseCounterRequest.fromJson(json.decode(str));

String closeCounterRequestToJson(CloseCounterRequest data) =>
    json.encode(data.toJson());

class CloseCounterRequest {
  CloseCounterRequest({
    this.closingBalance,
    this.mismatchAmountReason,
    this.closedByPosAt,
    this.openedByPostAt,
    this.denominations,
  });

  CloseCounterRequest.fromJson(dynamic json) {
    closingBalance = getDoubleValue(json['closing_balance']);
    mismatchAmountReason = json['mismatch_amount_reason'];
    closedByPosAt = json['closed_by_pos_at'];
    openedByPostAt = json['openedByPostAt'];
    if (json['denominations'] != null) {
      denominations = [];
      json['denominations'].forEach((v) {
        denominations?.add(Denominations.fromJson(v));
      });
    }
  }

  double? closingBalance;
  String? mismatchAmountReason;
  String? closedByPosAt;
  String? openedByPostAt;
  List<Denominations>? denominations;

  setClosedByPostAt(String closedAt) {
    closedByPosAt = closedAt;
  }

  setOpenedByPost(String openedAt) {
    openedByPostAt = openedAt;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['closing_balance'] = closingBalance;
    map['mismatch_amount_reason'] = mismatchAmountReason;
    map['closed_by_pos_at'] = closedByPosAt;
    map['openedByPostAt'] = openedByPostAt;

    if (denominations != null) {
      map['denominations'] = denominations?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// denomination : 10.50
/// quantity : 1

Denominations denominationsFromJson(String str) =>
    Denominations.fromJson(json.decode(str));

String denominationsToJson(Denominations data) => json.encode(data.toJson());

class Denominations {
  Denominations({
    this.denomination,
    this.quantity,
  });

  Denominations.fromJson(dynamic json) {
    denomination = getDoubleValue(json['denomination']);
    quantity = json['quantity'];
  }

  double? denomination;
  int? quantity;

  Denominations copyWith({
    double? denomination,
    int? quantity,
  }) =>
      Denominations(
        denomination: denomination ?? this.denomination,
        quantity: quantity ?? this.quantity,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['denomination'] = denomination;
    map['quantity'] = quantity;
    return map;
  }
}
