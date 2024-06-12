import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jakel_base/database/priceoverridetypes/PriceOverrideTypesLocalApi.dart';
import 'package:jakel_base/restapi/priceoverridetypes/model/PriceOverrideTypesResponse.dart';


class PriceOverrideTypesLocalApiImpl extends PriceOverrideTypesLocalApi {
  final String _boxName = "PriceOverrideTypes";

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
  Future<List<PriceOverrideTypes>> getAll() async {
    var box = await _getBox();
    List<PriceOverrideTypes> allLists = List.empty(growable: true);
    for (Map<dynamic, dynamic> map in box.values) {
      var userBodyData = json.encode(map);
      Map<String, dynamic> decodedMap = json.decode(userBodyData);
      allLists.add(PriceOverrideTypes.fromJson(decodedMap));
    }
    return Future<List<PriceOverrideTypes>>.value(allLists);
  }

  @override
  Future<void> save(List<PriceOverrideTypes> elements) async {
    var box = await _getBox();
    await deleteAll();
    for (PriceOverrideTypes element in elements) {
      await box.put(element.id, element.toJson());
    }
  }

  @override
  Future<List<PriceOverrideTypes>> search(String search) {
    return getAll();
  }

  @override
  Future<PriceOverrideTypes> getById(int id) async {
    var box = await _getBox();
    var userBodyData = json.encode(box.get(id));
    Map<String, dynamic> decodedMap = json.decode(userBodyData);
    return PriceOverrideTypes.fromJson(decodedMap);
  }

  @override
  Future<bool> deleteAll() async {
    List<PriceOverrideTypes> allLists = await getAll();
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
