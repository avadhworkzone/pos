import 'dart:convert';

import 'package:jakel_base/database/offlinedata/OfflineCashMovementDataApi.dart';
import 'package:jakel_base/database/offlinedata/cashmovement/CashMovementRequest.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OfflineCashMovementDataApiImpl extends OfflineCashMovementDataApi {
  final String _boxName = "cashMovementOfflineData";

  Future<Box<dynamic>> _getBox() async {
    await Hive.openBox(_boxName);
    var box = Hive.box(_boxName);
    return box;
  }

  @override
  Future<bool> deleteForCounterOpenedAt(String openedAt) async {
    var box = await _getBox();
    for (dynamic map in box.values) {
      if (map is Map<dynamic, dynamic>) {
        var userBodyData = json.encode(map);
        Map<String, dynamic> decodedMap = json.decode(userBodyData);
        var cashMovements = CashMovementRequest.fromJson(decodedMap);
        if (cashMovements.openByPosAt == openedAt) {
          await box.delete(cashMovements.happenedAt);
        }
      }
    }
    return true;
  }

  @override
  Future<List<CashMovementRequest>> get(String openedAt) async {
    var box = await _getBox();
    List<CashMovementRequest> allLists = List.empty(growable: true);
    for (dynamic map in box.values) {
      if (map is Map<dynamic, dynamic>) {
        var userBodyData = json.encode(map);
        Map<String, dynamic> decodedMap = json.decode(userBodyData);
        var cashMovements = CashMovementRequest.fromJson(decodedMap);
        if (cashMovements.openByPosAt == openedAt) {
          allLists.add(cashMovements);
        }
      }
    }
    return Future<List<CashMovementRequest>>.value(allLists);
  }

  @override
  Future<void> save(CashMovementRequest data) async {
    var box = await _getBox();
    await box.put(data.happenedAt ?? '', data.toJson());
  }

  @override
  Future<List<CashMovementRequest>> getNotSynced(String openedAt) async {
    var box = await _getBox();
    List<CashMovementRequest> allLists = List.empty(growable: true);
    for (dynamic map in box.values) {
      if (map is Map<dynamic, dynamic>) {
        var userBodyData = json.encode(map);
        Map<String, dynamic> decodedMap = json.decode(userBodyData);
        var cashMovements = CashMovementRequest.fromJson(decodedMap);
        if (cashMovements.openByPosAt == openedAt &&
            (cashMovements.isSynced == null ||
                cashMovements.isSynced == false)) {
          allLists.add(cashMovements);
        }
      }
    }
    return Future<List<CashMovementRequest>>.value(allLists);
  }

  @override
  Future<void> clearBox() async {
    var box = await _getBox();
    await box.deleteFromDisk();
  }
}
