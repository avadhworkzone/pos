import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

import '../../sales/model/NewSaleRequest.dart';

/// customer_id : 1
/// amount : 10.5
/// remarks : "asdf"
/// payment_type_id : 1
/// products : [{"product_id":1,"quantity":1.01}]

ResetBookingRequest resetBookingRequestFromJson(String str) =>
    ResetBookingRequest.fromJson(json.decode(str));

String resetBookingRequestToJson(ResetBookingRequest data) =>
    json.encode(data.toJson());

class ResetBookingRequest {
  ResetBookingRequest({
    List<ResetBookingProducts>? products,
    List<int>? promoterIds,
  }) {
    _products = products;
    _promoterIds = promoterIds;
  }

  ResetBookingRequest.fromJson(dynamic json) {


    if (json['products'] != null) {
      _products = [];
      json['products'].forEach((v) {
        _products?.add(ResetBookingProducts.fromJson(v));
      });

    }

    _promoterIds =
    json['promoterIds'] != null ? json['promoter_ids'].cast<int>() : [];
  }

  List<ResetBookingProducts>? _products;
  List<int>? _promoterIds;

  List<ResetBookingProducts>? get products => _products;

  List<int>? get promoterIds => _promoterIds;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (_products != null) {
      map['products'] = _products?.map((v) => v.toJson()).toList();
    }

    if (_promoterIds != null) {
      map['promoter_ids'] = _promoterIds?.map((v) => v).toList();
    }

    return map;
  }
}

/// product_id : 1
/// quantity : 1.01

ResetBookingProducts productsFromJson(String str) =>
    ResetBookingProducts.fromJson(json.decode(str));

String productsToJson(ResetBookingProducts data) => json.encode(data.toJson());

class ResetBookingProducts {
  ResetBookingProducts({
    int? productId,
    double? quantity,
    List<int>? promoterIds,
  }) {
    _productId = productId;
    _quantity = quantity;
    _promoterIds = promoterIds;
  }

  ResetBookingProducts.fromJson(dynamic json) {
    _productId = json['product_id'];
    _quantity = getRoundedDoubleValue(json['quantity']);
    _promoterIds =
    json['promoterIds'] != null ? json['promoter_ids'].cast<int>() : [];
  }

  int? _productId;
  double? _quantity;
  List<int>? _promoterIds;

  List<int>? get promoterIds => _promoterIds;

  int? get productId => _productId;

  double? get quantity => _quantity;

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
