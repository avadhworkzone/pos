import 'package:jakel_base/restapi/products/model/ProductsResponse.dart';

extension ProductsExtension on Products {
  String getProductName() {
    if (name != null) {
      return name!;
    }
    return "";
  }

  String getProductImage() {
    if (name != null) {
      return name!;
    }
    return "";
  }

  String getProductColor() {
    if (color != null) {
      return color!.name!;
    }
    return "";
  }

  String getProductSize() {
    if (size != null) {
      return size!.name!;
    }
    return "";
  }

  double getProductPrice() {
    if (price != null) {
      return price!;
    }
    return 0.0;
  }

  isUnitOfMeasureItem() {
    if (unitOfMeasure != null) {
      return true;
    }
    return false;
  }
}
