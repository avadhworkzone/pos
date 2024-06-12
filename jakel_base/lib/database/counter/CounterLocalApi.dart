import 'dart:developer';

import 'package:jakel_base/restapi/counters/model/GetStoresResponse.dart';

import '../../restapi/counters/model/GetCountersResponse.dart';

abstract class CounterLocalApi {
  /// Save current logged in user store
  Future<void> saveStore(Stores store);

  /// Get current logged in user store
  Future<Stores?> getStore();

  // Delete the current store
  Future<bool> deleteStore();

  /// Save Current logged in user counter
  Future<void> saveCounter(Counters counter);

  /// Get Current logged in user counter
  Future<Counters?> getCounter();

  // Delete the current counter
  Future<bool> deleteCounter();

  Future<void> clearBox();
}
