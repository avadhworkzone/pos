import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jakel_base/constants.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';

import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'OnHoldSalesLocalApi.dart';

class OnHoldSalesLocalApiImpl extends OnHoldSalesLocalApi {
  final String _boxName = "onHoldSales";

  Future<Box<dynamic>> _getBox() async {
    await Hive.openBox(_boxName);
    var box = Hive.box(_boxName);
    return box;
  }

  @override
  Future<bool> delete(String id) async {
    Box<dynamic> box = await _getBox();
    if(!box.containsKey(id)){
      return false;
    }
    await box.delete(id);
    return true;
  }

  @override
  Future<List<CartSummary>> getAll() async {
    var box = await _getBox();
    List<CartSummary> allLists = List.empty(growable: true);

    for (Map<dynamic, dynamic> map in box.values) {
      try {
        var userBodyData = json.encode(map);
        Map<String, dynamic> decodedMap = json.decode(userBodyData);
        allLists.add(CartSummary.fromJson(decodedMap));
      } catch (e) {
        MyLogUtils.logDebug("box.values exception : $e");
        await delete(map['offlineSaleId'] ?? noData);
      }
    }
    return Future<List<CartSummary>>.value(allLists);
  }

  @override
  Future<void> saveAll(List<CartSummary> elements) async {
    var box = await _getBox();
    await deleteAll();
    for (CartSummary element in elements) {
      await box.put(element.offlineSaleId, element.toJson());
    }
  }

  @override
  Future<void> save(CartSummary element) async {
    var box = await _getBox();
    await delete(element.offlineSaleId!);
    await box.put(element.offlineSaleId, element.toJson());
  }

  @override
  Future<List<CartSummary>> search(String search) {
    return getAll();
  }

  @override
  Future<CartSummary> getById(String id) async {
    var box = await _getBox();
    var userBodyData = json.encode(box.get(id));
    Map<String, dynamic> decodedMap = json.decode(userBodyData);
    return CartSummary.fromJson(decodedMap);
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
