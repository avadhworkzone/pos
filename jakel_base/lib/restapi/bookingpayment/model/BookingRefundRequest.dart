import 'dart:convert';

/// payment_type_id:1
/// refund_payment_type_id:1
/// amount:1


BookingRefundRequest bookingRefundRequestFromJson(String str) =>
    BookingRefundRequest.fromJson(json.decode(str));

String bookingRefundRequestToJson(BookingRefundRequest data) =>
    json.encode(data.toJson());

class BookingRefundRequest {
  BookingRefundRequest({
    String? refundPaymentTypeId,
    String? paymentTypeId,
    String? amount,
    String? happenedAt,
  }) {
    _refundPaymentTypeId = refundPaymentTypeId;
    _paymentTypeId = paymentTypeId;
    _amount = amount;
    _happenedAt = happenedAt;
  }

  BookingRefundRequest.fromJson(dynamic json) {
    _refundPaymentTypeId = json['refund_payment_type_id'];
    _paymentTypeId = json['payment_type_id'];
    _amount = json['amount'];
    _happenedAt = json['happened_at'];
  }

  String? _refundPaymentTypeId;
  String? _paymentTypeId;
  String? _amount;
  String? _happenedAt;

  String? get refundPaymentTypeId => _refundPaymentTypeId;

  String? get paymentTypeId => _paymentTypeId;

  String? get amount => _amount;

  String? get happenedAt => _happenedAt;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['refund_payment_type_id'] = _refundPaymentTypeId;
    map['payment_type_id'] = _paymentTypeId;
    map['amount'] = _amount;
    map['happened_at'] = _happenedAt;
    return map;
  }
}