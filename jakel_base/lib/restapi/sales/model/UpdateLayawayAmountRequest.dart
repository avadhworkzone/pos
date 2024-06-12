import 'dart:convert';

/// payments : [{"type_id":1,"amount":1.0}]

UpdateLayawayAmountRequest updateLayawayAmountRequestFromJson(String str) =>
    UpdateLayawayAmountRequest.fromJson(json.decode(str));

String updateLayawayAmountRequestToJson(UpdateLayawayAmountRequest data) =>
    json.encode(data.toJson());

class UpdateLayawayAmountRequest {
  UpdateLayawayAmountRequest({
    this.payments,});

  UpdateLayawayAmountRequest.fromJson(dynamic json) {
    if (json['payments'] != null) {
      payments = [];
      json['payments'].forEach((v) {
        payments?.add(LayawayPayments.fromJson(v));
      });
    }
  }

  List<LayawayPayments>? payments;

  UpdateLayawayAmountRequest copyWith({ List<LayawayPayments>? payments,
  }) =>
      UpdateLayawayAmountRequest(payments: payments ?? this.payments,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (payments != null) {
      map['payments'] = payments?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// type_id : 1
/// amount : 1.0

LayawayPayments paymentsFromJson(String str) => LayawayPayments.fromJson(json.decode(str));

String paymentsToJson(LayawayPayments data) => json.encode(data.toJson());

class LayawayPayments {
  LayawayPayments({
    this.typeId,
    this.loyaltyPoints,
    this.bookingPaymentId,
    this.creditNoteId,
    this.giftCardId,
    this.amount,});

  LayawayPayments.fromJson(dynamic json) {
    typeId = json['type_id'];
    loyaltyPoints = json['loyalty_points']??"";
    bookingPaymentId = json['booking_payment_id']??"";
    creditNoteId = json['credit_note_id']??"";
    giftCardId = json['gift_card_id']??"";
    amount = json['amount'];
  }

  int? typeId;
  int? loyaltyPoints;
  int? bookingPaymentId;
  int? creditNoteId;
  int? giftCardId;
  double? amount;

  LayawayPayments copyWith({ 
    int? typeId,
    int? loyaltyPoints,
    int? bookingPaymentId,
    int? creditNoteId,
    int? giftCardId,
    double? amount,
  }) =>
      LayawayPayments(typeId: typeId ?? this.typeId,
        amount: amount ?? this.amount,
        loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
        bookingPaymentId: bookingPaymentId ?? this.bookingPaymentId,
        creditNoteId: creditNoteId ?? this.creditNoteId,
        giftCardId: giftCardId ?? this.giftCardId,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type_id'] = typeId;
    map['loyalty_points'] = loyaltyPoints;
    map['booking_payment_id'] = bookingPaymentId;
    map['credit_note_id'] = creditNoteId;
    map['gift_card_id'] = giftCardId;
    map['amount'] = amount;
    return map;
  }

}