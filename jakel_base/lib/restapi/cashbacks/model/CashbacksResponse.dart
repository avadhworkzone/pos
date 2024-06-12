import 'dart:convert';

import 'package:jakel_base/utils/num_utils.dart';

/// cashbacks : [{"id":1,"exclude_by_type":"PRODUCTS","name":"Festival Cashback Offer","flat_amount":10.05,"minimum_spend_amount":150.50,"products":[9,10],"categories":[9,10]}]

CashbacksResponse cashbacksResponseFromJson(String str) =>
    CashbacksResponse.fromJson(json.decode(str));

String cashbacksResponseToJson(CashbacksResponse data) =>
    json.encode(data.toJson());

class CashbacksResponse {
  CashbacksResponse({
    this.cashbacks,
  });

  CashbacksResponse.fromJson(dynamic json) {
    if (json['cashbacks'] != null) {
      cashbacks = [];
      json['cashbacks'].forEach((v) {
        cashbacks?.add(Cashbacks.fromJson(v));
      });
    }
  }

  List<Cashbacks>? cashbacks;

  CashbacksResponse copyWith({
    List<Cashbacks>? cashbacks,
  }) =>
      CashbacksResponse(
        cashbacks: cashbacks ?? this.cashbacks,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (cashbacks != null) {
      map['cashbacks'] = cashbacks?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 1
/// exclude_by_type : "PRODUCTS"
/// name : "Festival Cashback Offer"
/// flat_amount : 10.05
/// minimum_spend_amount : 150.50
/// products : [9,10]
/// categories : [9,10]

Cashbacks cashbacksFromJson(String str) => Cashbacks.fromJson(json.decode(str));

String cashbacksToJson(Cashbacks data) => json.encode(data.toJson());

class Cashbacks {
  Cashbacks({
    this.id,
    this.excludeByType,
    this.name,
    this.flatAmount,
    this.minimumSpendAmount,
    this.products,
    this.categories,
  });

  Cashbacks.fromJson(dynamic json) {
    id = json['id'];
    excludeByType = json['exclude_by_type'];
    name = json['name'];
    flatAmount = getDoubleValue(json['flat_amount']);
    minimumSpendAmount = getDoubleValue(json['minimum_spend_amount']);
    products = json['products'] != null ? json['products'].cast<int>() : [];
    categories =
        json['categories'] != null ? json['categories'].cast<int>() : [];
  }

  int? id;
  String? excludeByType;
  String? name;
  double? flatAmount;
  double? minimumSpendAmount;
  List<int>? products;
  List<int>? categories;

  Cashbacks copyWith({
    int? id,
    String? excludeByType,
    String? name,
    double? flatAmount,
    double? minimumSpendAmount,
    List<int>? products,
    List<int>? categories,
  }) =>
      Cashbacks(
        id: id ?? this.id,
        excludeByType: excludeByType ?? this.excludeByType,
        name: name ?? this.name,
        flatAmount: flatAmount ?? this.flatAmount,
        minimumSpendAmount: minimumSpendAmount ?? this.minimumSpendAmount,
        products: products ?? this.products,
        categories: categories ?? this.categories,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['exclude_by_type'] = excludeByType;
    map['name'] = name;
    map['flat_amount'] = flatAmount;
    map['minimum_spend_amount'] = minimumSpendAmount;
    map['products'] = products;
    map['categories'] = categories;
    return map;
  }
}
