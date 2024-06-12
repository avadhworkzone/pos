import 'package:jakel_base/restapi/products/model/ProductsResponse.dart';
import 'package:jakel_base/restapi/sales/model/history/SalesResponse.dart';
import 'package:jakel_base/utils/num_utils.dart';

import '../../../restapi/sales/model/SaleReturnsResponse.dart';

class SaleReturnsItemData {
  SaleItems? saleItem;
  Products? product;
  double? qty;
  int? uniqueId;
  String? batchNumber;
  SaleReturnReasons? reason;

  SaleReturnsItemData(
      {this.qty,
      this.saleItem,
      this.uniqueId,
      this.batchNumber,
      this.product,
      this.reason});

  factory SaleReturnsItemData.fromJson(dynamic json) {
    return SaleReturnsItemData(
      saleItem: json['saleItem'] != null
          ? SaleItems.fromJson(json['saleItem'])
          : null,
      product:
          json['product'] != null ? Products.fromJson(json['saleItem']) : null,
      reason: json['reason'] != null
          ? SaleReturnReasons.fromJson(json['reason'])
          : null,
      qty: getDoubleValue(json['qty']),
      uniqueId: json['uniqueId'],
      batchNumber: json['batchNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (saleItem != null) {
      data['saleItem'] = saleItem?.toJson();
    }

    if (product != null) {
      data['product'] = product?.toJson();
    }

    if (reason != null) {
      data['reason'] = reason?.toJson();
    }

    data['qty'] = qty;
    data['uniqueId'] = uniqueId;
    data['batchNumber'] = batchNumber;
    return data;
  }
}
