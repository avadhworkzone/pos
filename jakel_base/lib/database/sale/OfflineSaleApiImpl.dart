import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jakel_base/database/sale/OfflineSaleApi.dart';

import 'model/CartSummary.dart';

class OfflineSaleApiImpl extends OfflineSaleApi {
  final String _boxName = "offlineSaleBox";

  Future<Box<dynamic>> _getBox() async {
    await Hive.openBox(_boxName);
    var box = Hive.box(_boxName);
    return box;
  }

  @override
  Future<bool> delete(String id) async {
    Box<dynamic> box = await _getBox();
    await box.delete(id);
    return true;
  }

  @override
  Future<List<CartSummary>> getAll() async {
    var box = await _getBox();
    List<CartSummary> allLists = List.empty(growable: true);
    for (Map<dynamic, dynamic> map in box.values) {
      var userBodyData = json.encode(map);
      Map<String, dynamic> decodedMap = json.decode(userBodyData);
      allLists.add(CartSummary.fromJson(decodedMap));
    }
    return Future<List<CartSummary>>.value(allLists);
  }

  @override
  Future<void> save(List<CartSummary> elements) async {
    var box = await _getBox();
    for (CartSummary element in elements) {
      await box.put(element.offlineSaleId, element.toJson());
    }
  }

  @override
  Future<List<CartSummary>> search(String search) {
    return getAll();
  }

  @override
  Future<CartSummary?> getById(String id) async {
    var box = await _getBox();
    if (box.containsKey(id)) {
      var userBodyData = json.encode(box.get(id));
      Map<String, dynamic> decodedMap = json.decode(userBodyData);
      return CartSummary.fromJson(decodedMap);
    } else {
      return null;
    }
  }

  @override
  Future<bool> deleteAll() async {
    List<CartSummary> allLists = await getAll();
    for (var value in allLists) {
      await delete(value.offlineSaleId!);
    }
    return true;
  }

  @override
  Future<void> clearBox() async {
    var box = await _getBox();
    await box.deleteFromDisk();
  }
}
