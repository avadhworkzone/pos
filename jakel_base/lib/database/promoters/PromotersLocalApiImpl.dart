import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:jakel_base/database/promoters/PromotersLocalApi.dart';

import '../../restapi/promoters/model/PromotersResponse.dart';

class PromotersLocalApiImpl extends PromotersLocalApi {
  final String _boxName = "promotersBox";

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
  Future<List<Promoters>> getAll() async {
    var box = await _getBox();
    List<Promoters> allLists = List.empty(growable: true);
    for (Map<dynamic, dynamic> map in box.values) {
      var userBodyData = json.encode(map);
      Map<String, dynamic> decodedMap = json.decode(userBodyData);
      allLists.add(Promoters.fromJson(decodedMap));
    }
    return Future<List<Promoters>>.value(allLists);
  }

  @override
  Future<void> save(List<Promoters> elements) async {
    var box = await _getBox();
    await deleteAll();
    for (Promoters element in elements) {
      await box.put(element.id, element.toJson());
    }
  }

  @override
  Future<List<Promoters>> search(String search) {
    return getAll();
  }

  @override
  Future<Promoters> getById(int id) async {
    var box = await _getBox();
    var userBodyData = json.encode(box.get(id));
    Map<String, dynamic> decodedMap = json.decode(userBodyData);
    return Promoters.fromJson(decodedMap);
  }

  @override
  Future<bool> deleteAll() async {
    List<Promoters> allLists = await getAll();
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
