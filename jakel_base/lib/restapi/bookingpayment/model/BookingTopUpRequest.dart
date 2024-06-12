import 'dart:convert';

/// payment_type_id:1
/// amount:1


BookingTopUpRequest bookingTopUpRequestFromJson(String str) =>
    BookingTopUpRequest.fromJson(json.decode(str));

String bookingTopUpRequestToJson(BookingTopUpRequest data) =>
    json.encode(data.toJson());

class BookingTopUpRequest {
  BookingTopUpRequest({
    int? selectedBookingPaymentId,
    int? paymentTypeId,
    double? amount,
    String? happenedAt,
  }) {
    _selectedBookingPaymentId = selectedBookingPaymentId;
    _paymentTypeId = paymentTypeId;
    _amount = amount;
    _happenedAt = happenedAt;
  }

  BookingTopUpRequest.fromJson(dynamic json) {
    _paymentTypeId = json['payment_type_id'];
    _amount = json['amount'];
    _happenedAt = json['happened_at'];
  }

  int? _selectedBookingPaymentId;
  int? _paymentTypeId;
  double? _amount;
  String? _happenedAt;


  int? get selectedBookingPaymentId => _selectedBookingPaymentId;

  int? get paymentTypeId => _paymentTypeId;

  double? get amount => _amount;

  String? get happenedAt => _happenedAt;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['payment_type_id'] = _paymentTypeId;
    map['amount'] = _amount;
    // map['happened_at'] = _happenedAt;
    return map;
  }
}