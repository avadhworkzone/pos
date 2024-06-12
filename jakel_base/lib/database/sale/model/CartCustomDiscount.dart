import 'package:jakel_base/restapi/directors/model/DirectorsResponse.dart';
import 'package:jakel_base/restapi/managers/model/StoreManagersResponse.dart';
import 'package:jakel_base/restapi/me/model/CurrentUserResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';

class CartCustomDiscount {
  Cashier? cashier;
  StoreManagers? manager;
  Directors? directors;
  double? discountPercentage;
  double? priceOverrideAmount;

  CartCustomDiscount({
    this.cashier,
    this.directors,
    this.manager,
    this.priceOverrideAmount,
    this.discountPercentage,
  });

  factory CartCustomDiscount.fromJson(dynamic json) {
    return CartCustomDiscount(
        cashier:
            json['cashier'] != null ? Cashier.fromJson(json['cashier']) : null,
        manager: json['manager'] != null
            ? StoreManagers.fromJson(json['manager'])
            : null,
        directors: json['directors'] != null
            ? Directors.fromJson(json['directors'])
            : null,
        discountPercentage: getDoubleValue(json['discountPercentage']),
        priceOverrideAmount: getDoubleValue(json['priceOverrideAmount']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (cashier != null) {
      data['cashier'] = cashier?.toJson();
    }

    if (manager != null) {
      data['manager'] = manager?.toJson();
    }

    if (directors != null) {
      data['directors'] = directors?.toJson();
    }

    data['discountPercentage'] = discountPercentage;

    data['priceOverrideAmount'] = priceOverrideAmount;

    return data;
  }
}
