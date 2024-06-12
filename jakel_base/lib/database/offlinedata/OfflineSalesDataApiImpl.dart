import 'dart:convert';

import 'package:jakel_base/database/offlinedata/OfflineSalesDataApi.dart';
import 'package:jakel_base/restapi/sales/model/history/SalesResponse.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:jakel_base/restapi/sales/model/history/SaveSaleResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';

import '../../locator.dart';
import 'OfflineOpenCounterDataApi.dart';

class OfflineSalesDataApiImpl extends OfflineSalesDataApi {
  final String _boxName = "OfflineSalesData";

  Future<Box<dynamic>> _getBox() async {
    await Hive.openBox(_boxName);
    var box = Hive.box(_boxName);
    return box;
  }

  @override
  Future<Sales?> getById(String id) async {
    var box = await _getBox();
    if (box.containsKey(id)) {
      var userBodyData = json.encode(box.get(id));
      Map<String, dynamic> decodedMap = json.decode(userBodyData);
      return Sales.fromJson(decodedMap);
    } else {
      return null;
    }
  }

  @override
  Future<List<Sales>> getSales(String openedAt) async {
    var box = await _getBox();

    List<Sales> allLists = List.empty(growable: true);

    for (Map<dynamic, dynamic> map in box.values) {
      var userBodyData = json.encode(map);
      Map<String, dynamic> decodedMap = json.decode(userBodyData);
      var storedSales = Sales.fromJson(decodedMap);

      if (storedSales.counterOpenedAt == null) {
        await delete(storedSales.offlineSaleId!);
      } else {
        if (storedSales.counterOpenedAt == openedAt) {
          allLists.add(storedSales);
        }
      }
    }

    return Future<List<Sales>>.value(allLists);
  }

  @override
  Future<void> saveSales(Sales sale) async {
    var box = await _getBox();
    var offlineOpenCounterDataApi = locator.get<OfflineOpenCounterDataApi>();
    var currentOpenCounter =
        await offlineOpenCounterDataApi.getCurrentOpenedCounter();

    MyLogUtils.logDebug(
        "OfflineSalesDataApiImpl saveSales currentOpenCounter : -> ${currentOpenCounter?.toJson()}");

    sale.setCounterOpenedAt(currentOpenCounter?.openedByPosAt ?? '');

    MyLogUtils.logDebug(
        "OfflineSalesDataApiImpl saveSales sale : -> ${sale.toJson()}");

    await box.put(sale.offlineSaleId, sale.toJson());
  }

  @override
  Future<void> saveSale(Sale sale) async {
    return saveSales(Sales.fromJson(sale.toJson()));
  }

  // @override
  // Future<bool> deleteAll() async {
  //   List<Sales> allLists = await getSales();
  //   for (var value in allLists) {
  //     await delete(value.offlineSaleId!);
  //   }
  //   return true;
  // }

  Future<bool> delete(String id) async {
    Box<dynamic> box = await _getBox();
    await box.delete(id);
    return true;
  }

  @override
  Future<bool> deleteForCounterOpenedAt(String openedAt) async {
    List<Sales> allLists = await getSales(openedAt);
    for (var value in allLists) {
      if (value.counterOpenedAt == openedAt) {
        await delete(value.offlineSaleId!);
      }
    }
    return true;
  }

  @override
  Future<void> clearBox() async {
    var box = await _getBox();
    await box.deleteFromDisk();
  }
}
