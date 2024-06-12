import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:jakel_base/database/vouchers/VouchersLocalApi.dart';
import 'package:jakel_base/restapi/vouchers/model/VouchersListResponse.dart';

class VouchersLocalApiImpl extends VouchersLocalApi {
  final String _boxName = "vouchersBox";

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
  Future<List<Vouchers>> getAll() async {
    var box = await _getBox();
    List<Vouchers> allLists = List.empty(growable: true);
    for (Map<dynamic, dynamic> map in box.values) {
      var userBodyData = json.encode(map);
      Map<String, dynamic> decodedMap = json.decode(userBodyData);
      allLists.add(Vouchers.fromJson(decodedMap));
    }
    return Future<List<Vouchers>>.value(allLists);
  }

  @override
  Future<void> save(List<Vouchers> elements) async {
    var box = await _getBox();
    for (Vouchers element in elements) {
      await delete(element.number ?? "");
      await box.put(element.number, element.toJson());
    }
  }

  @override
  Future<List<Vouchers>> search(String search) {
    return getAll();
  }

  @override
  Future<Vouchers?> getById(String id) async {
    var box = await _getBox();
    if (box.containsKey(id)) {
      var userBodyData = json.encode(box.get(id));
      Map<String, dynamic> decodedMap = json.decode(userBodyData);
      return Vouchers.fromJson(decodedMap);
    } else {
      return null;
    }
  }

  @override
  Future<bool> deleteAll() async {
    List<Vouchers> allLists = await getAll();
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
