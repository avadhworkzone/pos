import 'package:jakel_base/restapi/products/model/ProductsResponse.dart';
import 'package:jakel_base/restapi/products/model/UnitOfMeasureResponse.dart';
import 'package:jakel_base/utils/num_utils.dart';

class ProductsData {
  Products? product;
  UnitOfMeasures? unitOfMeasures;
  Derivatives? derivatives;
  double taxPercentage;

  ProductsData(
      {this.unitOfMeasures,
      this.product,
      this.derivatives,
      this.taxPercentage = 0.0});

  factory ProductsData.fromJson(dynamic json) {
    return ProductsData(
      product:
          json['product'] != null ? Products.fromJson(json['product']) : null,
      unitOfMeasures: json['unitOfMeasures'] != null
          ? UnitOfMeasures.fromJson(json['unitOfMeasures'])
          : null,
      derivatives: json['derivatives'] != null
          ? Derivatives.fromJson(json['derivatives'])
          : null,
      taxPercentage: getDoubleValue(json['taxPercentage']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['taxPercentage'] = taxPercentage;

    if (product != null) {
      data['product'] = product?.toJson();
    }

    if (unitOfMeasures != null) {
      data['unitOfMeasures'] = unitOfMeasures?.toJson();
    }

    if (derivatives != null) {
      data['derivatives'] = derivatives?.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return '${toJson()}';
  }

  String getProductName() {
    if (derivatives != null && derivatives!.name != null) {
      return "${product!.name!} - ${derivatives!.name!}";
    }

    if (product!.name != null) {
      return product!.name!;
    }
    return "";
  }

  String getProductImage() {
    if (product!.name != null) {
      return product!.name!;
    }
    return "";
  }

  String getProductColor() {
    if (product!.color != null) {
      return product!.color!.name!;
    }
    return "";
  }

  String getProductSize() {
    if (product!.size != null) {
      return product!.size!.name!;
    }
    return "";
  }

  String getProductStyle() {
    if (product!.style != null) {
      return product!.style!.name!;
    }
    return "";
  }

  String getProductBrand() {
    if (product!.brand != null) {
      return product!.brand!.name!;
    }
    return "";
  }

  double getProductPrice() {
    if (derivatives != null && derivatives!.ratio != null) {
      return product!.price! * (1 / derivatives!.ratio!);
    }

    if (product!.price != null) {
      return product!.price!;
    }

    return 0.0;
  }

  isUnitOfMeasureItem() {
    if (product!.unitOfMeasure != null) {
      return true;
    }
    return false;
  }
}
