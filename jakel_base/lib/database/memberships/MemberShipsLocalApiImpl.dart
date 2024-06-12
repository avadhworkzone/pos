import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

import '../../restapi/customers/model/MembershipResponse.dart';
import 'MemberShipsLocalApi.dart';

class MemberShipsLocalApiImpl extends MemberShipsLocalApi {
  final String _boxName = "memberShipsBox";

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
  Future<List<Memberships>> getAll() async {
    var box = await _getBox();
    List<Memberships> allLists = List.empty(growable: true);
    for (Map<dynamic, dynamic> map in box.values) {
      var userBodyData = json.encode(map);
      Map<String, dynamic> decodedMap = json.decode(userBodyData);
      allLists.add(Memberships.fromJson(decodedMap));
    }
    return Future<List<Memberships>>.value(allLists);
  }

  @override
  Future<void> save(List<Memberships> elements) async {
    var box = await _getBox();
    await deleteAll();
    for (Memberships element in elements) {
      await box.put(element.id, element.toJson());
    }
  }

  @override
  Future<List<Memberships>> search(String search) {
    return getAll();
  }

  @override
  Future<Memberships?> getById(int id) async {
    var box = await _getBox();

    if (box.get(id) == null) {
      return null;
    }

    var userBodyData = json.encode(box.get(id));

    Map<String, dynamic> decodedMap = json.decode(userBodyData);

    return Memberships.fromJson(decodedMap);
  }

  @override
  Future<bool> deleteAll() async {
    List<Memberships> allLists = await getAll();
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
