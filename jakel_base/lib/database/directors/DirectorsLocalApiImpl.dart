import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:jakel_base/restapi/directors/model/DirectorsResponse.dart';

import 'DirectorsLocalApi.dart';

class DirectorsLocalApiImpl extends DirectorsLocalApi {
  final String _boxName = "directorsBox";

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
  Future<List<Directors>> getAll() async {
    var box = await _getBox();
    List<Directors> allLists = List.empty(growable: true);
    for (Map<dynamic, dynamic> map in box.values) {
      var userBodyData = json.encode(map);
      Map<String, dynamic> decodedMap = json.decode(userBodyData);
      allLists.add(Directors.fromJson(decodedMap));
    }
    return Future<List<Directors>>.value(allLists);
  }

  @override
  Future<void> save(List<Directors> elements) async {
    var box = await _getBox();
    await deleteAll();
    for (Directors element in elements) {
      await box.put(element.staffId, element.toJson());
    }
  }

  @override
  Future<List<Directors>> search(String search) {
    return getAll();
  }

  @override
  Future<Directors> getById(String id) async {
    var box = await _getBox();
    var userBodyData = json.encode(box.get(id));
    Map<String, dynamic> decodedMap = json.decode(userBodyData);
    return Directors.fromJson(decodedMap);
  }

  Future<bool> deleteAll() async {
    List<Directors> allLists = await getAll();
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
