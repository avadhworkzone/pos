import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:jakel_base/database/complimentaryreason/ComplimentaryReasonLocalApi.dart';
import 'package:jakel_base/restapi/complimentaryreason/model/ComplimentaryReasonResponse.dart';

class ComplimentaryReasonLocalApiImpl extends ComplimentaryReasonLocalApi {
  final String _boxName = "ComplimentaryReasonBox";

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
  Future<List<ComplimentaryItemReasons>> getAll() async {
    var box = await _getBox();
    List<ComplimentaryItemReasons> allLists = List.empty(growable: true);
    for (Map<dynamic, dynamic> map in box.values) {
      var userBodyData = json.encode(map);
      Map<String, dynamic> decodedMap = json.decode(userBodyData);
      allLists.add(ComplimentaryItemReasons.fromJson(decodedMap));
    }
    return Future<List<ComplimentaryItemReasons>>.value(allLists);
  }

  @override
  Future<void> save(List<ComplimentaryItemReasons> elements) async {
    var box = await _getBox();
    await deleteAll();
    for (ComplimentaryItemReasons element in elements) {
      await box.put(element.id, element.toJson());
    }
  }

  @override
  Future<List<ComplimentaryItemReasons>> search(String search) {
    return getAll();
  }

  @override
  Future<ComplimentaryItemReasons> getById(int id) async {
    var box = await _getBox();
    var userBodyData = json.encode(box.get(id));
    Map<String, dynamic> decodedMap = json.decode(userBodyData);
    return ComplimentaryItemReasons.fromJson(decodedMap);
  }

  @override
  Future<bool> deleteAll() async {
    List<ComplimentaryItemReasons> allLists = await getAll();
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
