import 'package:jakel_base/utils/MyLogUtils.dart';

import '../../restapi/counters/model/CloseCounterRequest.dart';
import 'OfflineCloseCounterDataApi.dart';
import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

class OfflineCloseCounterDataApiImpl extends OfflineCloseCounterDataApi {
  final String _boxName = "offlineCloseCounterData";

  Future<Box<dynamic>> _getBox() async {
    await Hive.openBox(_boxName);
    var box = Hive.box(_boxName);
    return box;
  }

  @override
  Future<void> clearCloseCounterRequest(String openedAt) async {
    var box = await _getBox();
    if (box.containsKey(openedAt)) {
      await box.delete(openedAt);
    }
  }

  @override
  Future<void> deleteSyncedClosedCounter() async {
    List<CloseCounterRequest> allLists = await getAll();
    for (var value in allLists) {
      await clearCloseCounterRequest(value.openedByPostAt ?? '');
    }
  }

  @override
  Future<List<CloseCounterRequest>> getAll() async {
    var box = await _getBox();
    List<CloseCounterRequest> allLists = List.empty(growable: true);
    for (dynamic map in box.values) {
      // Earlier one of the values used was bool & so this check is needed.
      if (map is Map<dynamic, dynamic>) {
        var userBodyData = json.encode(map);
        Map<String, dynamic> decodedMap = json.decode(userBodyData);
        allLists.add(CloseCounterRequest.fromJson(decodedMap));
      }
    }
    return Future<List<CloseCounterRequest>>.value(allLists);
  }

  @override
  Future<CloseCounterRequest?> getCounterById(String openedAt) async {
    MyLogUtils.logDebug("getCounterById openedAt :$openedAt ");

    var box = await _getBox();

    if (!box.containsKey(openedAt)) {
      return null;
    }
    var userBodyData = json.encode(box.get(openedAt));
    MyLogUtils.logDebug("getCounterById userBodyData :$userBodyData ");
    Map<String, dynamic> decodedMap = json.decode(userBodyData);
    return CloseCounterRequest.fromJson(decodedMap);
  }

  @override
  Future<void> setCloseCounterRequest(CloseCounterRequest request) async {
    var box = await _getBox();
    await box.put(request.openedByPostAt ?? '', request.toJson());
  }
  @override
  Future<void> clearBox() async {
    var box = await _getBox();
    await box.deleteFromDisk();
  }
}
