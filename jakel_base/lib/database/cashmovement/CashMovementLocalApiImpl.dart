import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

import '../../restapi/cashmovement/model/CashMovementReasonResponse.dart';
import 'CashMovementLocalApi.dart';

class CashMovementLocalApiImpl extends CashMovementLocalApi {
  final String _boxName = "cashMovementBox";

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
  Future<List<CashMovementReasons>> getAll() async {
    var box = await _getBox();
    List<CashMovementReasons> allLists = List.empty(growable: true);
    for (Map<dynamic, dynamic> map in box.values) {
      var userBodyData = json.encode(map);
      Map<String, dynamic> decodedMap = json.decode(userBodyData);
      allLists.add(CashMovementReasons.fromJson(decodedMap));
    }
    return Future<List<CashMovementReasons>>.value(allLists);
  }

  @override
  Future<void> save(List<CashMovementReasons> elements) async {
    var box = await _getBox();
    await deleteAll();
    for (CashMovementReasons element in elements) {
      await box.put(element.id, element.toJson());
    }
  }

  @override
  Future<List<CashMovementReasons>> search(String search) {
    return getAll();
  }

  @override
  Future<CashMovementReasons> getById(int id) async {
    var box = await _getBox();
    var userBodyData = json.encode(box.get(id));
    Map<String, dynamic> decodedMap = json.decode(userBodyData);
    return CashMovementReasons.fromJson(decodedMap);
  }

  @override
  Future<bool> deleteAll() async {
    List<CashMovementReasons> allLists = await getAll();
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
