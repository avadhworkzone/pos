import 'package:jakel_base/database/offlinedata/cashmovement/CashMovementRequest.dart';

// This stores all the sales data of this opened counter.
// Delete all the sales when counter is closed & synced.

abstract class OfflineCashMovementDataApi {
  Future<void> clearBox();

  Future<void> save(CashMovementRequest data);

  Future<List<CashMovementRequest>> get(String openedAt);

  Future<List<CashMovementRequest>> getNotSynced(String openedAt);

  Future<bool> deleteForCounterOpenedAt(String openedAt);
}
