import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

import '../../restapi/vouchers/model/VoucherConfigurationResponse.dart';
import 'VoucherConfigLocalApi.dart';

class VoucherConfigLocalApiImpl extends VoucherConfigLocalApi {
  final String _boxName = "voucherConfigurationBox";

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
  Future<List<VoucherConfiguration>> getAll() async {
    var box = await _getBox();
    List<VoucherConfiguration> allLists = List.empty(growable: true);
    for (Map<dynamic, dynamic> map in box.values) {
      var userBodyData = json.encode(map);
      Map<String, dynamic> decodedMap = json.decode(userBodyData);
      allLists.add(VoucherConfiguration.fromJson(decodedMap));
    }
    return Future<List<VoucherConfiguration>>.value(allLists);
  }

  @override
  Future<void> save(List<VoucherConfiguration> elements) async {
    var box = await _getBox();
    await deleteAll();
    for (VoucherConfiguration element in elements) {
      await box.put(element.id, element.toJson());
    }
  }

  @override
  Future<List<VoucherConfiguration>> search(String search) {
    return getAll();
  }

  @override
  Future<VoucherConfiguration> getById(int id) async {
    var box = await _getBox();
    var userBodyData = json.encode(box.get(id));
    Map<String, dynamic> decodedMap = json.decode(userBodyData);
    return VoucherConfiguration.fromJson(decodedMap);
  }

  @override
  Future<bool> deleteAll() async {
    List<VoucherConfiguration> allLists = await getAll();
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
