import 'package:jakel_base/restapi/sales/model/history/SalesResponse.dart';
import 'package:jakel_base/restapi/sales/model/history/SaveSaleResponse.dart';

// This stores all the sales data of this opened counter.
// Delete all the sales when counter is closed & synced.

abstract class OfflineSalesDataApi {
  Future<void> saveSales(Sales sale);

  Future<void> saveSale(Sale sale);

  Future<List<Sales>> getSales(String openedAt);

  Future<Sales?> getById(String id);

  // Future<bool> deleteAll();

  Future<bool> deleteForCounterOpenedAt(String openedAt);

  Future<void> clearBox();
}
