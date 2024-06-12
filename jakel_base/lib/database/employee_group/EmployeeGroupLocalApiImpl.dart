import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../restapi/employees/model/EmployeeGroupResponse.dart';
import 'EmployeeGroupLocalApi.dart';

class EmployeeGroupLocalApiImpl extends EmployeeGroupLocalApi {
  final String _boxName = "employeeGroupTypesBox";

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
  Future<List<EmployeeGroup>> getAll() async {
    var box = await _getBox();
    List<EmployeeGroup> allLists = List.empty(growable: true);
    for (Map<dynamic, dynamic> map in box.values) {
      var userBodyData = json.encode(map);
      Map<String, dynamic> decodedMap = json.decode(userBodyData);
      allLists.add(EmployeeGroup.fromJson(decodedMap));
    }
    return Future<List<EmployeeGroup>>.value(allLists);
  }

  @override
  Future<void> save(List<EmployeeGroup> elements) async {
    var box = await _getBox();
    await deleteAll();
    for (EmployeeGroup element in elements) {
      await box.put(element.id, element.toJson());
    }
  }

  @override
  Future<List<EmployeeGroup>> search(String search) {
    return getAll();
  }

  @override
  Future<EmployeeGroup> getById(int id) async {
    var box = await _getBox();
    var userBodyData = json.encode(box.get(id));
    Map<String, dynamic> decodedMap = json.decode(userBodyData);
    return EmployeeGroup.fromJson(decodedMap);
  }

  @override
  Future<bool> deleteAll() async {
    List<EmployeeGroup> allLists = await getAll();
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
