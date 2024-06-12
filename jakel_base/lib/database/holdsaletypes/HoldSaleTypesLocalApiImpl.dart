import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:jakel_base/database/holdsaletypes/HoldSaleTypesLocalApi.dart';
import 'package:jakel_base/restapi/sales/model/HoldSaleTypesResponse.dart';

class HoldSaleTypesLocalApiImpl extends HoldSaleTypesLocalApi {
  final String _boxName = "holdSaleTypes";

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
  Future<List<Types>> getAll() async {
    var box = await _getBox();
    List<Types> allLists = List.empty(growable: true);
    for (Map<dynamic, dynamic> map in box.values) {
      var userBodyData = json.encode(map);
      Map<String, dynamic> decodedMap = json.decode(userBodyData);
      allLists.add(Types.fromJson(decodedMap));
    }
    return Future<List<Types>>.value(allLists);
  }

  @override
  Future<void> save(List<Types> elements) async {
    var box = await _getBox();
    await deleteAll();
    for (Types element in elements) {
      await box.put(element.id, element.toJson());
    }
  }

  @override
  Future<bool> deleteAll() async {
    List<Types> allLists = await getAll();
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
