import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../../restapi/managers/model/StoreManagersResponse.dart';
import 'StoreManagersLocalApi.dart';

class StoreManagersLocalApiImpl extends StoreManagersLocalApi {
  final String _boxName = "storeManagersBox";

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
  Future<List<StoreManagers>> getAll() async {
    var box = await _getBox();
    List<StoreManagers> allLists = List.empty(growable: true);
    for (Map<dynamic, dynamic> map in box.values) {
      var userBodyData = json.encode(map);
      Map<String, dynamic> decodedMap = json.decode(userBodyData);
      allLists.add(StoreManagers.fromJson(decodedMap));
    }
    return Future<List<StoreManagers>>.value(allLists);
  }

  @override
  Future<void> save(List<StoreManagers> elements) async {
    var box = await _getBox();
    await deleteAll();
    for (StoreManagers element in elements) {
      await box.put(element.staffId, element.toJson());
    }
  }

  @override
  Future<List<StoreManagers>> search(String search) {
    return getAll();
  }

  @override
  Future<StoreManagers> getById(String id) async {
    var box = await _getBox();
    var userBodyData = json.encode(box.get(id));
    Map<String, dynamic> decodedMap = json.decode(userBodyData);
    return StoreManagers.fromJson(decodedMap);
  }

  Future<bool> deleteAll() async {
    List<StoreManagers> allLists = await getAll();
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
