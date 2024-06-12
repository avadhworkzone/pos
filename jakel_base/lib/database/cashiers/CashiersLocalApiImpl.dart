import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:jakel_base/database/cashiers/CashiersLocalApi.dart';
import 'package:jakel_base/restapi/cashiers/model/CashiersResponse.dart';

class CashiersLocalApiImpl extends CashiersLocalApi {
  final String _boxName = "cashiersBox";

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
  Future<List<Cashiers>> getAll() async {
    var box = await _getBox();
    List<Cashiers> allLists = List.empty(growable: true);
    for (Map<dynamic, dynamic> map in box.values) {
      var userBodyData = json.encode(map);
      Map<String, dynamic> decodedMap = json.decode(userBodyData);
      allLists.add(Cashiers.fromJson(decodedMap));
    }
    return Future<List<Cashiers>>.value(allLists);
  }

  @override
  Future<void> save(List<Cashiers> elements) async {
    var box = await _getBox();
    await deleteAll();
    for (Cashiers element in elements) {
      await box.put(element.staffId, element.toJson());
    }
  }

  @override
  Future<List<Cashiers>> search(String search) {
    return getAll();
  }

  @override
  Future<Cashiers> getById(String id) async {
    var box = await _getBox();
    var userBodyData = json.encode(box.get(id));
    Map<String, dynamic> decodedMap = json.decode(userBodyData);
    return Cashiers.fromJson(decodedMap);
  }

  @override
  Future<bool> deleteAll() async {
    List<Cashiers> allLists = await getAll();
    for (var value in allLists) {
      if (value.staffId != null) {
        await delete(value.staffId!);
      }
    }
    return true;
  }

  @override
  Future<void> clearBox() async {
    var box = await _getBox();
    await box.deleteFromDisk();
  }
}
