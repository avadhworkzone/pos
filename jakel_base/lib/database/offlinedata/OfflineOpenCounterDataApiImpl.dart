import 'package:jakel_base/restapi/counters/model/OpenCounterRequest.dart';

import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';

import 'OfflineOpenCounterDataApi.dart';

class OfflineOpenCounterDataApiImpl extends OfflineOpenCounterDataApi {
  final String _boxName = "offlineOpenCounterData";

  Future<Box<dynamic>> _getBox() async {
    await Hive.openBox(_boxName);
    var box = Hive.box(_boxName);
    return box;
  }

  @override
  Future<List<OpenCounterRequest>> getAll() async {
    var box = await _getBox();
    List<OpenCounterRequest> allLists = List.empty(growable: true);
    for (dynamic map in box.values) {
      if (map is Map<dynamic, dynamic>) {
        var userBodyData = json.encode(map);
        Map<String, dynamic> decodedMap = json.decode(userBodyData);
        var counter = OpenCounterRequest.fromJson(decodedMap);
        if (counter.openingBalance != null) {
          allLists.add(counter);
        } else {
          await clearOpenCounterRequest(counter.openedByPosAt ?? '');
        }
      }
    }
    return Future<List<OpenCounterRequest>>.value(allLists);
  }

  @override
  Future<OpenCounterRequest?> getCurrentOpenedCounter() async {
    List<OpenCounterRequest> allLists = await getAll();
    for (var value in allLists) {
      if (value.closedByPosAt == null) {
        return value;
      }
    }
    return null;
  }

  @override
  Future<void> setOpenCounterRequest(OpenCounterRequest request) async {
    MyLogUtils.logDebug("setOpenCounterRequest : ${request.toJson()}");
    var box = await _getBox();
    await box.put(request.openedByPosAt ?? '', request.toJson());
  }

  @override
  Future<bool?> isOpenCounterSynced(String openedAt) async {
    var box = await _getBox();

    if (!box.containsKey(openedAt)) {
      return null;
    }
    var userBodyData = json.encode(box.get(openedAt));
    Map<String, dynamic> decodedMap = json.decode(userBodyData);
    return OpenCounterRequest.fromJson(decodedMap).isSyncedToCloud;
  }

  @override
  Future<OpenCounterRequest?> getCounterById(String openedAt) async {
    var box = await _getBox();

    if (!box.containsKey(openedAt)) {
      return null;
    }
    var userBodyData = json.encode(box.get(openedAt));
    Map<String, dynamic> decodedMap = json.decode(userBodyData);
    return OpenCounterRequest.fromJson(decodedMap);
  }

  @override
  Future<bool?> setOpenCounterSynced(String openedAt, bool isSynced) async {
    var box = await _getBox();

    if (!box.containsKey(openedAt)) {
      return null;
    }
    var userBodyData = json.encode(box.get(openedAt));
    Map<String, dynamic> decodedMap = json.decode(userBodyData);
    var openCounter = OpenCounterRequest.fromJson(decodedMap);
    openCounter.setIsSyncedToCloud(isSynced);
    await setOpenCounterRequest(openCounter);
    return openCounter.isSyncedToCloud;
  }

  @override
  Future<void> clearOpenCounterRequest(String openedAt) async {
    var box = await _getBox();
    await box.delete(openedAt);
  }

  @override
  Future<void> deleteSyncedOpenCounter() async {
    List<OpenCounterRequest> allLists = await getAll();
    for (var value in allLists) {
      await clearOpenCounterRequest(value.openedByPosAt ?? '');
    }
  }

  @override
  Future<void> clearBox() async {
    var box = await _getBox();
    await box.deleteFromDisk();
  }
}
