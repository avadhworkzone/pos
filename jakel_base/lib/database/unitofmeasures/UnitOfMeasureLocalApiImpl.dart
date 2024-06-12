import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:jakel_base/database/unitofmeasures/UnitOfMeasureLocalApi.dart';
import 'package:jakel_base/restapi/products/model/UnitOfMeasureResponse.dart';

class UnitOfMeasureLocalApiImpl extends UnitOfMeasureLocalApi {
  final String _boxName = "unitOfMeasureBox";

  Future<Box<dynamic>> _getBox() async {
    await Hive.openBox(_boxName);
    var box = Hive.box(_boxName);
    return box;
  }

  @override
  Future<bool> delete(int unitOfMeasureId) async {
    Box<dynamic> box = await _getBox();
    await box.delete(unitOfMeasureId);
    return true;
  }

  @override
  Future<List<UnitOfMeasures>> getAll() async {
    var box = await _getBox();
    List<UnitOfMeasures> allLists = List.empty(growable: true);
    for (Map<dynamic, dynamic> map in box.values) {
      var userBodyData = json.encode(map);
      Map<String, dynamic> decodedMap = json.decode(userBodyData);
      allLists.add(UnitOfMeasures.fromJson(decodedMap));
    }
    return Future<List<UnitOfMeasures>>.value(allLists);
  }

  @override
  Future<void> save(List<UnitOfMeasures> unitOfMeasure) async {
    var box = await _getBox();
    await deleteAll();
    for (UnitOfMeasures element in unitOfMeasure) {
      await box.put(element.id, element.toJson());
    }
  }

  @override
  Future<List<UnitOfMeasures>> search(String search) {
    return getAll();
  }

  @override
  Future<UnitOfMeasures> getById(int id) async {
    var box = await _getBox();
    var userBodyData = json.encode(box.get(id));
    Map<String, dynamic> decodedMap = json.decode(userBodyData);
    return UnitOfMeasures.fromJson(decodedMap);
  }

  Future<bool> deleteAll() async {
    List<UnitOfMeasures> allLists = await getAll();
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
