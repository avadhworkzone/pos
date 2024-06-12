import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../../restapi/sales/model/SaleReturnsResponse.dart';
import 'SaleReturnReasonLocalApi.dart';

class SaleReturnReasonLocalApiImpl extends SaleReturnReasonLocalApi {
  final String _boxName = "saleReturnReasonBox";

  Future<Box<dynamic>> _getBox() async {
    await Hive.openBox(_boxName);
    var box = Hive.box(_boxName);
    return box;
  }

  @override
  Future<bool> delete(int id) async {
    Box<dynamic> box = await _getBox();
    await box.delete(id);
    return true;
  }

  @override
  Future<List<SaleReturnReasons>> getAll() async {
    var box = await _getBox();
    List<SaleReturnReasons> allLists = List.empty(growable: true);
    for (Map<dynamic, dynamic> map in box.values) {
      var userBodyData = json.encode(map);
      Map<String, dynamic> decodedMap = json.decode(userBodyData);
      allLists.add(SaleReturnReasons.fromJson(decodedMap));
    }
    return Future<List<SaleReturnReasons>>.value(allLists);
  }

  @override
  Future<void> save(List<SaleReturnReasons> elements) async {
    var box = await _getBox();
    await deleteAll();
    for (SaleReturnReasons element in elements) {
      await box.put(element.id, element.toJson());
    }
  }

  @override
  Future<List<SaleReturnReasons>> search(String search) {
    return getAll();
  }

  @override
  Future<SaleReturnReasons> getById(int id) async {
    var box = await _getBox();
    var userBodyData = json.encode(box.get(id));
    Map<String, dynamic> decodedMap = json.decode(userBodyData);
    return SaleReturnReasons.fromJson(decodedMap);
  }

  @override
  Future<bool> deleteAll() async {
    List<SaleReturnReasons> allLists = await getAll();
    for (var value in allLists) {
      await delete(value.id!);
    }
    return true;
  }

  @override
  Future<void> clearBox() async {
    var box = await _getBox();
    await box.deleteFromDisk();
  }
}
