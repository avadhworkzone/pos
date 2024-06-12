import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:jakel_base/restapi/counters/model/GetCountersResponse.dart';
import 'package:jakel_base/restapi/counters/model/GetStoresResponse.dart';

import 'CounterLocalApi.dart';

class CounterLocalApiImpl extends CounterLocalApi {
  final String _boxName = "counter";
  final String _store = "store";
  final String _counter = "counter";

  @override
  Future<Counters?> getCounter() async {
    Box<dynamic> box = await _getBox();
    var content = box.get(_counter);

    if (content != null) {
      String? encoded = json.encode(content);
      Map<String, dynamic> decoded = json.decode(encoded);
      Counters? counter = Counters.fromJson(decoded);
      return Future.value(counter);
    }

    return Future.value(null);
  }

  @override
  Future<Stores?> getStore() async {
    Box<dynamic> box = await _getBox();
    var content = box.get(_store);

    if (content != null) {
      String? encoded = json.encode(content);
      Map<String, dynamic> decoded = json.decode(encoded);
      Stores? store = Stores.fromJson(decoded);
      return Future.value(store);
    }

    return Future.value(null);
  }

  @override
  Future<void> saveCounter(Counters counter) async {
    Box<dynamic> box = await _getBox();
    box.put(_counter, counter.toJson());
  }

  @override
  Future<void> saveStore(Stores store) async {
    Box<dynamic> box = await _getBox();
    box.put(_store, store.toJson());
  }

  Future<Box<dynamic>> _getBox() async {
    await Hive.openBox(_boxName);
    var box = Hive.box(_boxName);
    return box;
  }

  @override
  Future<bool> deleteCounter() async {
    Box<dynamic> box = await _getBox();
    await box.delete(_counter);
    return true;
  }

  @override
  Future<bool> deleteStore() async {
    Box<dynamic> box = await _getBox();
    await box.delete(_store);
    return true;
  }

  @override
  Future<void> clearBox() async {
    var box = await _getBox();
    await box.deleteFromDisk();
  }
}
