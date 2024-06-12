import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:jakel_base/database/dreamprice/DreamPriceLocalApi.dart';

import '../../restapi/dreamprice/model/DreamPriceResponse.dart';

class DreamPriceLocalApiImpl extends DreamPriceLocalApi {
  final String _boxName = "dreamPrice";

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
  Future<List<DreamPrices>> getAll() async {
    var box = await _getBox();
    List<DreamPrices> allLists = List.empty(growable: true);
    for (Map<dynamic, dynamic> map in box.values) {
      var userBodyData = json.encode(map);
      Map<String, dynamic> decodedMap = json.decode(userBodyData);
      allLists.add(DreamPrices.fromJson(decodedMap));
    }
    return Future<List<DreamPrices>>.value(allLists);
  }

  @override
  Future<void> save(List<DreamPrices> dreamPrices) async {
    var box = await _getBox();
    await deleteAll();
    for (DreamPrices element in dreamPrices) {
      await box.put(element.id, element.toJson());
    }
  }

  @override
  Future<List<DreamPrices>> search(String search) {
    return getAll();
  }

  @override
  Future<DreamPrices> getById(int id) async {
    var box = await _getBox();
    var userBodyData = json.encode(box.get(id));
    Map<String, dynamic> decodedMap = json.decode(userBodyData);
    return DreamPrices.fromJson(decodedMap);
  }

  Future<bool> deleteAll() async {
    List<DreamPrices> allLists = await getAll();
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
