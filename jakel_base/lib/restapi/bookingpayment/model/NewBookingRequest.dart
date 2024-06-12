import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

import '../../sales/model/NewSaleRequest.dart';

/// customer_id : 1
/// amount : 10.5
/// remarks : "asdf"
/// payment_type_id : 1
/// products : [{"product_id":1,"quantity":1.01}]

NewBookingRequest newBookingRequestFromJson(String str) =>
    NewBookingRequest.fromJson(json.decode(str));

String newBookingRequestToJson(NewBookingRequest data) =>
    json.encode(data.toJson());

class NewBookingRequest {
  NewBookingRequest({
    int? customerId,
    String? offlineId,
    double? amount,
    String? remarks,
    int? paymentTypeId,
    NewMember? member,
    String? billReferenceNumber,
    List<int>? promoterIds,
    List<NewBookingProducts>? products,
    String? storeManagerId, // = "store_manager_id";
    String? storeManagerPasscode,
    String? happenedAt,
  }) {
    _customerId = customerId;
    _amount = amount;
    _offlineId = offlineId;
    _remarks = remarks;
    _billReferenceNumber = billReferenceNumber;
    _paymentTypeId = paymentTypeId;
    _products = products;
    _member = member;
    _promoterIds = promoterIds;
    _storeManagerId = storeManagerId;
    _storeManagerPasscode = storeManagerPasscode;
    _happenedAt = happenedAt;
  }

  NewBookingRequest.fromJson(dynamic json) {
    _customerId = json['member_id'];
    _offlineId = json['offline_id'];
    _amount = getDoubleValue(json['amount']);
    _remarks = json['remarks'];
    _billReferenceNumber = json['bill_reference_number'];
    _paymentTypeId = json['payment_type_id'];
    _storeManagerId = json['store_manager_id'];
    _storeManagerPasscode = json['store_manager_passcode'];
    _happenedAt = json['happened_at'];

    _promoterIds =
    json['promoterIds'] != null ? json['promoter_ids'].cast<int>() : [];

    if (json['products'] != null) {
      _products = [];
      json['products'].forEach((v) {
        _products?.add(NewBookingProducts.fromJson(v));
      });
    }

    _member =
    json['member'] != null ? NewMember.fromJson(json['member']) : null;
  }

  int? _customerId;
  double? _amount;
  String? _offlineId;
  String? _remarks;
  int? _paymentTypeId;
  String? _billReferenceNumber;
  List<int>? _promoterIds;
  List<NewBookingProducts>? _products;
  NewMember? _member;
  String? _storeManagerId;
  String? _storeManagerPasscode;
  String? _happenedAt;

  int? get customerId => _customerId;

  double? get amount => _amount;

  String? get remarks => _remarks;

  String? get offlineId => _offlineId;

  String? get billReferenceNumber => _billReferenceNumber;

  String? get storeManagerId => _storeManagerId;

  String? get storeManagerPasscode => _storeManagerPasscode;

  int? get paymentTypeId => _paymentTypeId;

  NewMember? get member => _member;

  List<int>? get promoterIds => _promoterIds;

  List<NewBookingProducts>? get products => _products;

  String? get happenedAt => _happenedAt;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['member_id'] = _customerId;
    map['amount'] = _amount;
    map['remarks'] = _remarks;
    map['offline_id'] = _offlineId;
    map['payment_type_id'] = _paymentTypeId;
    map['bill_reference_number'] = _billReferenceNumber;
    map['store_manager_id'] = _storeManagerId;
    map['store_manager_passcode'] = _storeManagerPasscode;
    map['happened_at'] = _happenedAt;

    if (_products != null) {
      map['products'] = _products?.map((v) => v.toJson()).toList();
    }

    if (_member != null) {
      map['member'] = _member?.toJson();
    }

    if (_promoterIds != null) {
      map['promoter_ids'] = _promoterIds?.map((v) => v).toList();
    }

    return map;
  }
}

/// product_id : 1
/// quantity : 1.01

NewBookingProducts productsFromJson(String str) =>
    NewBookingProducts.fromJson(json.decode(str));

String productsToJson(NewBookingProducts data) => json.encode(data.toJson());

class NewBookingProducts {
  NewBookingProducts({
    int? productId,
    int? quantity,
    List<int>? promoterIds,
  }) {
    _productId = productId;
    _quantity = quantity;
    _promoterIds = promoterIds;
  }

  NewBookingProducts.fromJson(dynamic json) {
    _productId = json['product_id'];
    _quantity = getInValue(json['quantity']);
    _promoterIds =
    json['promoterIds'] != null ? json['promoter_ids'].cast<int>() : [];
  }

  int? _productId;
  int? _quantity;
  List<int>? _promoterIds;

  List<int>? get promoterIds => _promoterIds;

  int? get productId => _productId;

  int? get quantity => _quantity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['product_id'] = _productId;
    map['quantity'] = _quantity;
    if (_promoterIds != null) {
      map['promoter_ids'] = _promoterIds?.map((v) => v).toList();
    }

    return map;
  }
}
