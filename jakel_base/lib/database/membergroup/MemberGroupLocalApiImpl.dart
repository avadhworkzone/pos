import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

import '../../restapi/customers/model/CustomerTypesResponse.dart';
import '../../restapi/customers/model/MemberGroupResponse.dart';
import 'MemberGroupLocalApi.dart';

class MemberGroupLocalApiImpl extends MemberGroupLocalApi {
  final String _boxName = "memberGroupTypesBox";

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
  Future<List<MemberGroup>> getAll() async {
    var box = await _getBox();
    List<MemberGroup> allLists = List.empty(growable: true);
    for (Map<dynamic, dynamic> map in box.values) {
      var userBodyData = json.encode(map);
      Map<String, dynamic> decodedMap = json.decode(userBodyData);
      allLists.add(MemberGroup.fromJson(decodedMap));
    }
    return Future<List<MemberGroup>>.value(allLists);
  }

  @override
  Future<void> save(List<MemberGroup> elements) async {
    var box = await _getBox();
    await deleteAll();
    for (MemberGroup element in elements) {
      await box.put(element.id, element.toJson());
    }
  }

  @override
  Future<List<MemberGroup>> search(String search) {
    return getAll();
  }

  @override
  Future<MemberGroup> getById(int id) async {
    var box = await _getBox();
    var userBodyData = json.encode(box.get(id));
    Map<String, dynamic> decodedMap = json.decode(userBodyData);
    return MemberGroup.fromJson(decodedMap);
  }

  @override
  Future<bool> deleteAll() async {
    List<MemberGroup> allLists = await getAll();
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
