import 'dart:convert';

/// payment_types : [{"id":1,"name":"DEBIT CARD","sub_payment_types":[{"id":2,"name":"Mastero Debit Cart","is_customer_required":false,"is_available_for_refund":false}],"is_customer_required":true,"is_available_for_refund":true}]

PaymentTypesResponse paymentTypesResponseFromJson(String str) =>
    PaymentTypesResponse.fromJson(json.decode(str));

String paymentTypesResponseToJson(PaymentTypesResponse data) =>
    json.encode(data.toJson());

class PaymentTypesResponse {
  PaymentTypesResponse({
    List<PaymentTypes>? paymentTypes,
  }) {
    _paymentTypes = paymentTypes;
  }

  PaymentTypesResponse.fromJson(dynamic json) {
    if (json['payment_types'] != null) {
      _paymentTypes = [];
      json['payment_types'].forEach((v) {
        _paymentTypes?.add(PaymentTypes.fromJson(v));
      });
    }
  }

  List<PaymentTypes>? _paymentTypes;

  PaymentTypesResponse copyWith({
    List<PaymentTypes>? paymentTypes,
  }) =>
      PaymentTypesResponse(
        paymentTypes: paymentTypes ?? _paymentTypes,
      );

  List<PaymentTypes>? get paymentTypes => _paymentTypes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_paymentTypes != null) {
      map['payment_types'] = _paymentTypes?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 1
/// name : "DEBIT CARD"
/// sub_payment_types : [{"id":2,"name":"Mastero Debit Cart","is_customer_required":false,"is_available_for_refund":false}]
/// is_customer_required : true
/// is_available_for_refund : true
/// localId :'', Used locally. Not from rest api. Create an id locally for allowing mutiple payments of same payment type

PaymentTypes paymentTypesFromJson(String str) =>
    PaymentTypes.fromJson(json.decode(str));

String paymentTypesToJson(PaymentTypes data) => json.encode(data.toJson());

class PaymentTypes {
  PaymentTypes({
    int? id,
    String? name,
    String? localId,
    String? image,
    String? paymentTerminalKey,
    List<SubPaymentTypes>? subPaymentTypes,
    bool? isCardPayment ,
    bool? isCustomerRequired,
    bool? isAvailableForRefund,
    bool? triggerMayBankCard,
    bool? triggerMayBankQrCode,
  }) {
    _id = id;
    _name = name;
    _localId = localId;
    _image = image;
    _paymentTerminalKey = paymentTerminalKey;
    _subPaymentTypes = subPaymentTypes;
    _isCardPayment = isCardPayment;
    _isCustomerRequired = isCustomerRequired;
    _isAvailableForRefund = isAvailableForRefund;
    _triggerMayBankCard = triggerMayBankCard;
    _triggerMayBankQrCode = triggerMayBankQrCode;
  }

  PaymentTypes.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _localId = json['localId'];
    _image = json['image_name'];
    _paymentTerminalKey = json['payment_terminal_key'];
    if (json['sub_payment_types'] != null) {
      _subPaymentTypes = [];
      json['sub_payment_types'].forEach((v) {
        _subPaymentTypes?.add(SubPaymentTypes.fromJson(v));
      });
    }
    _isCardPayment = json['is_card_payment'];
    _isCustomerRequired = json['is_member_required'];
    _isAvailableForRefund = json['is_available_for_refund'];
    _triggerMayBankCard = json['trigger_maybank_card'];
    _triggerMayBankQrCode = json['trigger_maybank_qr_code'];
  }

  int? _id;
  String? _name;
  String? _localId;
  String? _image;
  List<SubPaymentTypes>? _subPaymentTypes;
  bool? _isCardPayment ;
  bool? _isCustomerRequired;
  bool? _isAvailableForRefund;
  bool? _triggerMayBankCard;
  bool? _triggerMayBankQrCode;
  String? _paymentTerminalKey;

  int? get id => _id;

  String? get name => _name;

  String? get paymentTerminalKey => _paymentTerminalKey;

  String? get localId => _localId;

  String? get image => _image;

  List<SubPaymentTypes>? get subPaymentTypes => _subPaymentTypes;

  bool? get isCustomerRequired => _isCustomerRequired;

  bool? get isAvailableForRefund => _isAvailableForRefund;

  bool? get triggerMayBankCard => _triggerMayBankCard;

  bool? get triggerMayBankQrCode => _triggerMayBankQrCode;

  bool? get isCardPayment => _isCardPayment;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['localId'] = _localId;
    map['image_name'] = _image;
    map['payment_terminal_key'] = _paymentTerminalKey;

    if (_subPaymentTypes != null) {
      map['sub_payment_types'] =
          _subPaymentTypes?.map((v) => v.toJson()).toList();
    }
    map['is_card_payment'] = _isCardPayment;
    map['is_member_required'] = _isCustomerRequired;
    map['is_available_for_refund'] = _isAvailableForRefund;
    map['trigger_maybank_card'] = _triggerMayBankCard;
    map['trigger_maybank_qr_code'] = _triggerMayBankQrCode;

    return map;
  }
}

/// id : 2
/// name : "Mastero Debit Cart"
/// is_customer_required : false
/// is_available_for_refund : false

SubPaymentTypes subPaymentTypesFromJson(String str) =>
    SubPaymentTypes.fromJson(json.decode(str));

String subPaymentTypesToJson(SubPaymentTypes data) =>
    json.encode(data.toJson());

class SubPaymentTypes {
  SubPaymentTypes({
    int? id,
    String? name,
    bool? isCustomerRequired,
    bool? isAvailableForRefund,
  }) {
    _id = id;
    _name = name;
    _isCustomerRequired = isCustomerRequired;
    _isAvailableForRefund = isAvailableForRefund;
  }

  SubPaymentTypes.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _isCustomerRequired = json['is_customer_required'];
    _isAvailableForRefund = json['is_available_for_refund'];
  }

  int? _id;
  String? _name;
  bool? _isCustomerRequired;
  bool? _isAvailableForRefund;

  SubPaymentTypes copyWith({
    int? id,
    String? name,
    bool? isCustomerRequired,
    bool? isAvailableForRefund,
  }) =>
      SubPaymentTypes(
        id: id ?? _id,
        name: name ?? _name,
        isCustomerRequired: isCustomerRequired ?? _isCustomerRequired,
        isAvailableForRefund: isAvailableForRefund ?? _isAvailableForRefund,
      );

  int? get id => _id;

  String? get name => _name;

  bool? get isCustomerRequired => _isCustomerRequired;

  bool? get isAvailableForRefund => _isAvailableForRefund;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['is_customer_required'] = _isCustomerRequired;
    map['is_available_for_refund'] = _isAvailableForRefund;
    return map;
  }
}
