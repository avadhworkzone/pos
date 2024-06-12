import '../../restapi/counters/model/CloseCounterRequest.dart';

abstract class OfflineCloseCounterDataApi {
  /// Set close counter request
  Future<void> setCloseCounterRequest(CloseCounterRequest request);

  /// Clear Close Counter Request From Db
  Future<void> clearCloseCounterRequest(String openedAt);

  /// Get all the close counter request
  Future<List<CloseCounterRequest>> getAll();

  //Get open close using closed at date time
  Future<CloseCounterRequest?> getCounterById(String openedAt);

  // After all data for that counter is synced, we should clear the synced counter data locally
  Future<void> deleteSyncedClosedCounter();

  Future<void> clearBox();
}
