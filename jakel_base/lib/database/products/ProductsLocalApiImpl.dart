import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:jakel_base/database/products/ProductsLocalApi.dart';
import 'package:jakel_base/restapi/products/model/ProductsResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';

class ProductsLocalApiImpl extends ProductsLocalApi {
  final String _boxName = "productsBox";

  Future<Box<dynamic>> _getBox() async {
    await Hive.openBox(_boxName);
    var box = Hive.box(_boxName);
    return box;
  }

  @override
  Future<bool> deleteProduct(int productId) async {
    Box<dynamic> box = await _getBox();
    await box.delete(productId);
    return true;
  }

  @override
  Future<List<Products>> getAllProducts() async {
    var productBox = await _getBox();
    List<Products> productLists = List.empty(growable: true);
    for (Map<dynamic, dynamic> map in productBox.values) {
      var userBodyData = json.encode(map);
      Map<String, dynamic> decodedMap = json.decode(userBodyData);
      productLists.add(Products.fromJson(decodedMap));
    }
    return Future<List<Products>>.value(productLists);
  }

  @override
  Future<void> saveProducts(List<Products> products) async {
    MyLogUtils.logDebug("saveProducts length: ${products.length} ");
    var productBox = await _getBox();
    for (Products product in products) {
      await deleteProduct(product.id ?? 0);
      await productBox.put(product.id, product.toJson());
    }
  }

  @override
  Future<List<Products>> searchProducts(String search) {
    return getAllProducts();
  }

  @override
  Future<bool> deleteAll() async {
    List<Products> allLists = await getAllProducts();
    for (var value in allLists) {
      await deleteProduct(value.id!);
    }
    return true;
  }

  @override
  Future<Products?> productById(int productId) async {
    var productBox = await _getBox();
    var map = productBox.get(productId);

    if (map == null) {
      return Future(() => null);
    }

    var userBodyData = json.encode(productBox.get(productId));
    Map<String, dynamic> decodedMap = json.decode(userBodyData);
    return Products.fromJson(decodedMap);
  }

  @override
  Future<void> clearBox() async {
    var box = await _getBox();
    await box.deleteFromDisk();
  }
}
