import 'package:jakel_base/restapi/products/model/ProductsResponse.dart';

import '../../restapi/counters/model/GetCountersResponse.dart';

abstract class ProductsLocalApi {
  /// Save products
  Future<void> saveProducts(List<Products> products);

  /// Get current logged in user store
  Future<List<Products>> getAllProducts();

  // Delete the current store
  Future<bool> deleteProduct(int productId);

  /// Get current logged in user store
  Future<List<Products>> searchProducts(String search);

  /// Delete all
  Future<bool> deleteAll();

  //Get product By Id
  Future<Products?> productById(int productId);

  Future<void> clearBox();
}
