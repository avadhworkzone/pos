import 'package:jakel_base/extension/ProductsDataExtension.dart';
import 'package:jakel_base/restapi/products/model/ProductsResponse.dart';
import 'package:jakel_base/restapi/products/model/UnitOfMeasureResponse.dart';
import 'package:jakel_base/restapi/promoters/model/PromotersResponse.dart';
import 'package:jakel_base/utils/num_utils.dart';

class ReturnItemDetails {
  int? saleReturnReasonId;
  String? batchNumber;
  double? quantity;

  ReturnItemDetails({this.saleReturnReasonId, this.batchNumber, this.quantity});

  factory ReturnItemDetails.fromJson(dynamic json) {
    return ReturnItemDetails(
      saleReturnReasonId: json['saleReturnReasonId'],
      quantity: json['quantity'],
      batchNumber: json['batchNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['saleReturnReasonId'] = saleReturnReasonId;

    data['quantity'] = quantity;

    data['batchNumber'] = batchNumber;

    return data;
  }

  @override
  String toString() {
    return '${toJson()}';
  }
}
