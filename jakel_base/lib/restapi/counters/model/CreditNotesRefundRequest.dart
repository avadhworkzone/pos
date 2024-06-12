import 'dart:convert';

/// payment_type_id:1
/// refund_payment_type_id:1
/// amount:1
/// store_manager_id:1
/// passcode:123456

CreditNotesRefundRequest creditNotesRefundRequestFromJson(String str) =>
    CreditNotesRefundRequest.fromJson(json.decode(str));

String creditNotesRefundRequestToJson(CreditNotesRefundRequest data) =>
    json.encode(data.toJson());

class CreditNotesRefundRequest {
  CreditNotesRefundRequest({
    String? refundPaymentTypeId,
    String? paymentTypeId,
    String? amount,
    String? storeManagerId,
    String? passcode, // Used Locally only.
  }) {
    _refundPaymentTypeId = refundPaymentTypeId;
    _paymentTypeId = paymentTypeId;
    _amount = amount;
    _storeManagerId = storeManagerId;
    _passcode = passcode; // Used Locally only.
  }

  CreditNotesRefundRequest.fromJson(dynamic json) {
    _refundPaymentTypeId = json['refund_payment_type_id'];
    _paymentTypeId = json['payment_type_id'];
    _amount = json['amount'];
    _storeManagerId = json['store_manager_id'];
    _passcode = json['passcode'];
  }

  String? _refundPaymentTypeId;
  String? _paymentTypeId;
  String? _amount;
  String? _storeManagerId;
  String? _passcode;

  String? get refundPaymentTypeId => _refundPaymentTypeId;
  
  String? get paymentTypeId => _paymentTypeId;

  String? get amount => _amount;

  String? get storeManagerId => _storeManagerId;

  String? get passcode => _passcode;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['refund_payment_type_id'] = _refundPaymentTypeId;
    map['payment_type_id'] = _paymentTypeId;
    map['amount'] = _amount;
    map['store_manager_id'] = _storeManagerId;
    map['passcode'] = _passcode; // Used Locally only.
    return map;
  }
}