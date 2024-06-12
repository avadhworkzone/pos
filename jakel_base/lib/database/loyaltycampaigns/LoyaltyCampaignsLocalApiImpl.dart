import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:jakel_base/restapi/loyaltycampaigns/model/LoyaltyCampaignsResponse.dart';

import 'LoyaltyCampaignsLocalApi.dart';


class LoyaltyCampaignsLocalApiImpl extends LoyaltyCampaignsLocalApi {
  final String _boxName = "loyaltyCampaignsBox";

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
  Future<List<LoyaltyCampaigns>> getAll() async {
    var box = await _getBox();
    List<LoyaltyCampaigns> allLists = List.empty(growable: true);
    for (Map<dynamic, dynamic> map in box.values) {
      var userBodyData = json.encode(map);
      Map<String, dynamic> decodedMap = json.decode(userBodyData);
      allLists.add(LoyaltyCampaigns.fromJson(decodedMap));
    }
    return Future<List<LoyaltyCampaigns>>.value(allLists);
  }

  @override
  Future<void> save(List<LoyaltyCampaigns> elements) async {
    var box = await _getBox();
    await deleteAll();
    for (LoyaltyCampaigns element in elements) {
      await box.put(element.id, element.toJson());
    }
  }


  @override
  Future<bool> deleteAll() async {
    List<LoyaltyCampaigns> allLists = await getAll();
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
