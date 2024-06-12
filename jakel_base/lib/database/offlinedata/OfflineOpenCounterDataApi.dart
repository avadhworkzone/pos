import 'package:jakel_base/restapi/counters/model/OpenCounterRequest.dart';

abstract class OfflineOpenCounterDataApi {
  /// Set open counter balance
  Future<void> setOpenCounterRequest(OpenCounterRequest request);

  /// Get open counter balance
  Future<OpenCounterRequest?> getCurrentOpenedCounter();

  /// Check if closing counter is synced to server
  Future<bool?> isOpenCounterSynced(String openedAt);

  /// Set closing counter is synced to server
  Future<bool?> setOpenCounterSynced(String openedAt, bool isSynced);

  /// Clear Open Counter Request
  Future<void> clearOpenCounterRequest(String openedAt);

  /// Get all the open counters
  Future<List<OpenCounterRequest>> getAll();

  //Get open Counter using open at date time
  Future<OpenCounterRequest?> getCounterById(String openedAt);

  // After all data for that counter is synced, we should clear the synced counter data locally
  Future<void> deleteSyncedOpenCounter();

  Future<void> clearBox();
}
