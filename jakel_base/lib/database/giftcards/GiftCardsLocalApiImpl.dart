import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jakel_base/restapi/giftcards/model/GiftCardsResponse.dart';

import 'GiftCardsLocalApi.dart';

class GiftCardsLocalApiImpl extends GiftCardsLocalApi {
  final String _boxName = "giftCardsBox";

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
  Future<List<GiftCards>> getAll() async {
    var box = await _getBox();
    List<GiftCards> allLists = List.empty(growable: true);
    for (Map<dynamic, dynamic> map in box.values) {
      var userBodyData = json.encode(map);
      Map<String, dynamic> decodedMap = json.decode(userBodyData);
      allLists.add(GiftCards.fromJson(decodedMap));
    }
    return Future<List<GiftCards>>.value(allLists);
  }

  @override
  Future<void> save(List<GiftCards> elements) async {
    var box = await _getBox();
    await deleteAll();
    for (GiftCards element in elements) {
      await box.put(element.number, element.toJson());
    }
  }

  @override
  Future<List<GiftCards>> search(String search) {
    return getAll();
  }

  @override
  Future<GiftCards?> getById(String id) async {
    var box = await _getBox();
    if (box.containsKey(id)) {
      var userBodyData = json.encode(box.get(id));
      Map<String, dynamic> decodedMap = json.decode(userBodyData);
      return GiftCards.fromJson(decodedMap);
    } else {
      return null;
    }
  }

  @override
  Future<bool> deleteAll() async {
    List<GiftCards> allLists = await getAll();
    for (var value in allLists) {
      await delete(value.number!);
    }
    return true;
  }

  @override
  Future<void> clearBox() async {
    var box = await _getBox();
    await box.deleteFromDisk();
  }
}
