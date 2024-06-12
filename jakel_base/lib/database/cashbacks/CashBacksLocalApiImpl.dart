import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jakel_base/database/cashbacks/CashBacksLocalApi.dart';
import 'package:jakel_base/restapi/cashbacks/model/CashbacksResponse.dart';

class CashBacksLocalApiImpl extends CashBacksLocalApi {
  final String _boxName = "cashBacksBox";

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
  Future<List<Cashbacks>> getAll() async {
    var box = await _getBox();
    List<Cashbacks> allLists = List.empty(growable: true);
    for (Map<dynamic, dynamic> map in box.values) {
      var userBodyData = json.encode(map);
      Map<String, dynamic> decodedMap = json.decode(userBodyData);
      allLists.add(Cashbacks.fromJson(decodedMap));
    }
    return Future<List<Cashbacks>>.value(allLists);
  }

  @override
  Future<void> save(List<Cashbacks> elements) async {
    var box = await _getBox();
    await deleteAll();
    for (Cashbacks element in elements) {
      await box.put(element.id, element.toJson());
    }
  }

  @override
  Future<List<Cashbacks>> search(String search) {
    return getAll();
  }

  @override
  Future<Cashbacks> getById(int id) async {
    var box = await _getBox();
    var userBodyData = json.encode(box.get(id));
    Map<String, dynamic> decodedMap = json.decode(userBodyData);
    return Cashbacks.fromJson(decodedMap);
  }

  @override
  Future<bool> deleteAll() async {
    List<Cashbacks> allLists = await getAll();
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
