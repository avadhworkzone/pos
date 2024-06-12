import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

import '../../restapi/customers/model/CustomerTypesResponse.dart';
import 'CustomerTypesLocalApi.dart';

class CustomerTypesLocalApiImpl extends CustomerTypesLocalApi {
  final String _boxName = "customerTypesBox";

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
  Future<List<CustomerTypes>> getAll() async {
    var box = await _getBox();
    List<CustomerTypes> allLists = List.empty(growable: true);
    for (Map<dynamic, dynamic> map in box.values) {
      var userBodyData = json.encode(map);
      Map<String, dynamic> decodedMap = json.decode(userBodyData);
      allLists.add(CustomerTypes.fromJson(decodedMap));
    }
    return Future<List<CustomerTypes>>.value(allLists);
  }

  @override
  Future<void> save(List<CustomerTypes> elements) async {
    var box = await _getBox();
    await deleteAll();
    for (CustomerTypes element in elements) {
      await box.put(element.id, element.toJson());
    }
  }

  @override
  Future<List<CustomerTypes>> search(String search) {
    return getAll();
  }

  @override
  Future<CustomerTypes> getById(int id) async {
    var box = await _getBox();
    var userBodyData = json.encode(box.get(id));
    Map<String, dynamic> decodedMap = json.decode(userBodyData);
    return CustomerTypes.fromJson(decodedMap);
  }

  @override
  Future<bool> deleteAll() async {
    List<CustomerTypes> allLists = await getAll();
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
