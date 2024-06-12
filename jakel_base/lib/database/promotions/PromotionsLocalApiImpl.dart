import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../../restapi/promotions/model/PromotionsResponse.dart';
import 'PromotionsLocalApi.dart';

class PromotionsLocalApiImpl extends PromotionsLocalApi {
  final String _boxName = "promotionsBox";

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
  Future<List<Promotions>> getAll() async {
    var box = await _getBox();
    List<Promotions> allLists = List.empty(growable: true);
    for (Map<dynamic, dynamic> map in box.values) {
      var userBodyData = json.encode(map);
      Map<String, dynamic> decodedMap = json.decode(userBodyData);
      allLists.add(Promotions.fromJson(decodedMap));
    }
    return Future<List<Promotions>>.value(allLists);
  }

  @override
  Future<void> save(List<Promotions> elements) async {
    var box = await _getBox();
    await deleteAll();
    for (Promotions element in elements) {
      await box.put(element.id, element.toJson());
    }
  }

  @override
  Future<List<Promotions>> search(String search) {
    return getAll();
  }

  @override
  Future<Promotions> getById(int id) async {
    var box = await _getBox();
    var userBodyData = json.encode(box.get(id));
    Map<String, dynamic> decodedMap = json.decode(userBodyData);
    return Promotions.fromJson(decodedMap);
  }

  @override
  Future<bool> deleteAll() async {
    List<Promotions> allLists = await getAll();
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
