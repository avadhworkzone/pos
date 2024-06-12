import 'dart:convert';

/// offline_id : ""
/// happened_at : ""
/// payments : [{"payment_type_id":1,"declared_amount":90.90,"calculated_amount":90.80,"denominations":[{"denomination":"","quantity":1}]}]

PaymentDeclarationRequest paymentDeclarationRequestFromJson(String str) =>
    PaymentDeclarationRequest.fromJson(json.decode(str));

String paymentDeclarationRequestToJson(PaymentDeclarationRequest data) =>
    json.encode(data.toJson());

class PaymentDeclarationRequest {
  PaymentDeclarationRequest({
    this.offlineId,
    this.happenedAt,
    this.payments,
  });

  PaymentDeclarationRequest.fromJson(dynamic json) {
    offlineId = json['offline_id'];
    happenedAt = json['happened_at'];
    if (json['payments'] != null) {
      payments = [];
      json['payments'].forEach((v) {
        payments?.add(DeclarationPayments.fromJson(v));
      });
    }
  }

  String? offlineId;
  String? happenedAt;
  List<DeclarationPayments>? payments;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['offline_id'] = offlineId;
    map['happened_at'] = happenedAt;
    if (payments != null) {
      map['payments'] = payments?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// payment_type_id : 1
/// declared_amount : 90.90
/// calculated_amount : 90.80
/// denominations : [{"denomination":"","quantity":1}]

DeclarationPayments paymentsFromJson(String str) => DeclarationPayments.fromJson(json.decode(str));

String paymentsToJson(DeclarationPayments data) => json.encode(data.toJson());

class DeclarationPayments {
  DeclarationPayments({
    this.paymentTypeId,
    this.declaredAmount,
    this.calculatedAmount,
    this.denominations,
  });

  DeclarationPayments.fromJson(dynamic json) {
    paymentTypeId = json['payment_type_id'];
    declaredAmount = json['declared_amount'];
    calculatedAmount = json['calculated_amount'];
    if (json['denominations'] != null) {
      denominations = [];
      json['denominations'].forEach((v) {
        denominations?.add(DeclarationPaymentDenominations.fromJson(v));
      });
    }
  }

  int? paymentTypeId;
  double? declaredAmount;
  double? calculatedAmount;
  List<DeclarationPaymentDenominations>? denominations;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['payment_type_id'] = paymentTypeId;
    map['declared_amount'] = declaredAmount;
    map['calculated_amount'] = calculatedAmount;
    if (denominations != null) {
      map['denominations'] = denominations?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// denomination : ""
/// quantity : 1

DeclarationPaymentDenominations denominationsFromJson(String str) =>
    DeclarationPaymentDenominations.fromJson(json.decode(str));

String denominationsToJson(DeclarationPaymentDenominations data) => json.encode(data.toJson());

class DeclarationPaymentDenominations {
  DeclarationPaymentDenominations({
    this.denomination,
    this.quantity,
  });

  DeclarationPaymentDenominations.fromJson(dynamic json) {
    denomination = json['denomination'];
    quantity = json['quantity'];
  }

  String? denomination;
  int? quantity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['denomination'] = denomination;
    map['quantity'] = quantity;
    return map;
  }
}
