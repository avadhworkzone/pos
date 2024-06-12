import 'package:jakel_base/extension/ProductsDataExtension.dart';
import 'package:jakel_base/restapi/products/model/ProductsResponse.dart';

import 'package:jakel_base/utils/num_utils.dart';

import 'ReturnItemDetails.dart';

class ReturnItem {
  Products? product;
  int? saleItemId;
  double? pricePaidPerUnit;
  double? quantity;
  List<ReturnItemDetails>? saleReturnDetails;

  ReturnItem(
      {this.product,
      this.saleItemId,
      this.pricePaidPerUnit,
      this.quantity,
      this.saleReturnDetails});

  factory ReturnItem.fromJson(dynamic json) {
    return ReturnItem(
      saleReturnDetails: json['saleReturnDetails'] != null
          ? (json['saleReturnDetails'] as List)
              .map((i) => ReturnItemDetails.fromJson(i))
              .toList()
          : [],
      product:
          json['product'] != null ? Products.fromJson(json['product']) : null,
      saleItemId: json['saleItemId'],
      quantity: json['quantity'],
      pricePaidPerUnit: getDoubleValue(json['pricePaidPerUnit']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['saleItemId'] = saleItemId;

    data['quantity'] = quantity;

    if (product != null) {
      data['product'] = product?.toJson();
    }

    data['pricePaidPerUnit'] = pricePaidPerUnit;

    if (saleReturnDetails != null) {
      data['saleReturnDetails'] =
          saleReturnDetails?.map((v) => v.toJson()).toList();
    }

    return data;
  }

  @override
  String toString() {
    return '${toJson()}';
  }

  String getProductName() {
    return product!.getProductName();
  }
}
