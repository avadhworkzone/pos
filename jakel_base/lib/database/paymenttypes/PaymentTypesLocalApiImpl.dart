import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:jakel_base/restapi/paymenttypes/model/PaymentTypesResponse.dart';

import 'PaymentTypesLocalApi.dart';

class PaymentTypesLocalApiImpl extends PaymentTypesLocalApi {
  final String _boxName = "paymentTypesBox";

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
  Future<List<PaymentTypes>> getAll() async {
    var box = await _getBox();
    List<PaymentTypes> allLists = List.empty(growable: true);
    for (Map<dynamic, dynamic> map in box.values) {
      var userBodyData = json.encode(map);
      Map<String, dynamic> decodedMap = json.decode(userBodyData);
      allLists.add(PaymentTypes.fromJson(decodedMap));
    }
    return Future<List<PaymentTypes>>.value(allLists);
  }

  @override
  Future<void> save(List<PaymentTypes> elements) async {
    var box = await _getBox();
    await deleteAll();
    for (PaymentTypes element in elements) {
      await box.put(element.id, element.toJson());
    }
  }

  @override
  Future<List<PaymentTypes>> search(String search) {
    return getAll();
  }

  @override
  Future<PaymentTypes> getById(int id) async {
    var box = await _getBox();
    var userBodyData = json.encode(box.get(id));
    Map<String, dynamic> decodedMap = json.decode(userBodyData);
    return PaymentTypes.fromJson(decodedMap);
  }

  Future<bool> deleteAll() async {
    List<PaymentTypes> allLists = await getAll();
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
