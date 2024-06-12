import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

/// counter_update_declaration_attempts : [{"counter_name":"NUR FAIZANA BINTI RASHID","offline_id":"113723221678011815059","happened_at":"2023-03-05 18:23:35","payments":[{"payment_type_name":"Cash","declared_amount":320.00,"calculated_amount":5999.35,"denominations":[{"quantity":"0","denomination":0.05},{"quantity":"0","denomination":0.10},{"quantity":"0","denomination":0.2},{"quantity":"0","denomination":0.5},{"quantity":"0","denomination":1.0},{"quantity":"0","denomination":5.0},{"quantity":"4","denomination":10.0},{"quantity":"4","denomination":20.0},{"quantity":"4","denomination":50.0},{"quantity":"0","denomination":100.0}]},{"payment_type_name":"Amex","declared_amount":40.00,"calculated_amount":300.00,"denominations":null},{"payment_type_name":"Online","declared_amount":50.00,"calculated_amount":2939.00,"denominations":null}]}]

PaymentDeclarationAttemptsResponse paymentDeclarationAttemptsResponseFromJson(
        String str) =>
    PaymentDeclarationAttemptsResponse.fromJson(json.decode(str));

String paymentDeclarationAttemptsResponseToJson(
        PaymentDeclarationAttemptsResponse data) =>
    json.encode(data.toJson());

class PaymentDeclarationAttemptsResponse {
  PaymentDeclarationAttemptsResponse({
    this.counterUpdateDeclarationAttempts,
  });

  PaymentDeclarationAttemptsResponse.fromJson(dynamic json) {
    if (json['counter_update_declaration_attempts'] != null) {
      counterUpdateDeclarationAttempts = [];
      json['counter_update_declaration_attempts'].forEach((v) {
        counterUpdateDeclarationAttempts
            ?.add(CounterUpdateDeclarationAttempts.fromJson(v));
      });
    }
  }

  List<CounterUpdateDeclarationAttempts>? counterUpdateDeclarationAttempts;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (counterUpdateDeclarationAttempts != null) {
      map['counter_update_declaration_attempts'] =
          counterUpdateDeclarationAttempts?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// counter_name : "NUR FAIZANA BINTI RASHID"
/// offline_id : "113723221678011815059"
/// happened_at : "2023-03-05 18:23:35"
/// payments : [{"payment_type_name":"Cash","declared_amount":320.00,"calculated_amount":5999.35,"denominations":[{"quantity":"0","denomination":0.05},{"quantity":"0","denomination":0.10},{"quantity":"0","denomination":0.2},{"quantity":"0","denomination":0.5},{"quantity":"0","denomination":1.0},{"quantity":"0","denomination":5.0},{"quantity":"4","denomination":10.0},{"quantity":"4","denomination":20.0},{"quantity":"4","denomination":50.0},{"quantity":"0","denomination":100.0}]},{"payment_type_name":"Amex","declared_amount":40.00,"calculated_amount":300.00,"denominations":null},{"payment_type_name":"Online","declared_amount":50.00,"calculated_amount":2939.00,"denominations":null}]

CounterUpdateDeclarationAttempts counterUpdateDeclarationAttemptsFromJson(
        String str) =>
    CounterUpdateDeclarationAttempts.fromJson(json.decode(str));

String counterUpdateDeclarationAttemptsToJson(
        CounterUpdateDeclarationAttempts data) =>
    json.encode(data.toJson());

class CounterUpdateDeclarationAttempts {
  CounterUpdateDeclarationAttempts({
    this.counterName,
    this.offlineId,
    this.happenedAt,
    this.payments,
  });

  CounterUpdateDeclarationAttempts.fromJson(dynamic json) {
    counterName = json['counter_name'];
    offlineId = json['offline_id'];
    happenedAt = json['happened_at'];
    if (json['payments'] != null) {
      payments = [];
      json['payments'].forEach((v) {
        payments?.add(AttemptPayments.fromJson(v));
      });
    }
  }

  String? counterName;
  String? offlineId;
  String? happenedAt;
  List<AttemptPayments>? payments;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['counter_name'] = counterName;
    map['offline_id'] = offlineId;
    map['happened_at'] = happenedAt;
    if (payments != null) {
      map['payments'] = payments?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// payment_type_name : "Cash"
/// declared_amount : 320.00
/// calculated_amount : 5999.35
/// denominations : [{"quantity":"0","denomination":0.05},{"quantity":"0","denomination":0.10},{"quantity":"0","denomination":0.2},{"quantity":"0","denomination":0.5},{"quantity":"0","denomination":1.0},{"quantity":"0","denomination":5.0},{"quantity":"4","denomination":10.0},{"quantity":"4","denomination":20.0},{"quantity":"4","denomination":50.0},{"quantity":"0","denomination":100.0}]

AttemptPayments paymentsFromJson(String str) =>
    AttemptPayments.fromJson(json.decode(str));

String paymentsToJson(AttemptPayments data) => json.encode(data.toJson());

class AttemptPayments {
  AttemptPayments({
    this.paymentTypeName,
    this.declaredAmount,
    this.calculatedAmount,
    this.denominations,
  });

  AttemptPayments.fromJson(dynamic json) {
    paymentTypeName = json['payment_type_name'];
    declaredAmount = getDoubleValue(json['declared_amount']);
    calculatedAmount = getDoubleValue(json['calculated_amount']);
    if (json['denominations'] != null) {
      denominations = [];
      json['denominations'].forEach((v) {
        denominations?.add(DeclarationDenominations.fromJson(v));
      });
    }
  }

  String? paymentTypeName;
  double? declaredAmount;
  double? calculatedAmount;
  List<DeclarationDenominations>? denominations;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['payment_type_name'] = paymentTypeName;
    map['declared_amount'] = declaredAmount;
    map['calculated_amount'] = calculatedAmount;
    if (denominations != null) {
      map['denominations'] = denominations?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// quantity : "0"
/// denomination : 0.05

DeclarationDenominations denominationsFromJson(String str) =>
    DeclarationDenominations.fromJson(json.decode(str));

String denominationsToJson(DeclarationDenominations data) =>
    json.encode(data.toJson());

class DeclarationDenominations {
  DeclarationDenominations({
    this.quantity,
    this.denomination,
  });

  DeclarationDenominations.fromJson(dynamic json) {
    quantity = json['quantity'];
    denomination = getDoubleValue(json['denomination']);
  }

  String? quantity;
  double? denomination;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['quantity'] = quantity;
    map['denomination'] = denomination;
    return map;
  }
}
