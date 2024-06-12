import 'package:jakel_base/restapi/products/model/UnitOfMeasureResponse.dart';

import 'model/ProductsResponse.dart';

abstract class ProductsApi {
  Future<ProductsResponse> getProducts(int pageNo, int perPage);

  Future<UnitOfMeasureResponse> getUnitOfMeasures();
}
