import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../../restapi/denominations/model/DenominationsResponse.dart';
import 'DenominationsLocalApi.dart';

class DenominationsLocalApiImpl extends DenominationsLocalApi {
  final String _boxName = "denominationsBox";

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
  Future<List<DenominationKey>> getAll() async {
    var box = await _getBox();
    List<DenominationKey> allLists = List.empty(growable: true);
    for (Map<dynamic, dynamic> map in box.values) {
      var userBodyData = json.encode(map);
      Map<String, dynamic> decodedMap = json.decode(userBodyData);
      allLists.add(DenominationKey.fromJson(decodedMap));
    }
    return Future<List<DenominationKey>>.value(allLists);
  }

  @override
  Future<void> save(List<DenominationKey> elements) async {
    var box = await _getBox();
    await deleteAll();
    for (DenominationKey element in elements) {
      await box.put(element.id, element.toJson());
    }
  }

  @override
  Future<List<DenominationKey>> search(String search) {
    return getAll();
  }

  @override
  Future<DenominationKey> getById(int id) async {
    var box = await _getBox();
    var userBodyData = json.encode(box.get(id));
    Map<String, dynamic> decodedMap = json.decode(userBodyData);
    return DenominationKey.fromJson(decodedMap);
  }

  @override
  Future<bool> deleteAll() async {
    List<DenominationKey> allLists = await getAll();
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
