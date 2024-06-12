
import 'package:jakel_base/restapi/sales/model/CancelLayawayAmountRequest.dart';
import 'package:jakel_base/restapi/sales/model/UpdateLayawayLoyaltyPointsRequest.dart';
import 'package:jakel_base/restapi/sales/model/HoldSaleTypesResponse.dart';
import 'package:jakel_base/restapi/sales/model/UpdateLayawayAmountRequest.dart';
import 'package:jakel_base/restapi/sales/model/cancel_layaway/CancelLayawayResponse.dart';
import 'package:jakel_base/restapi/sales/model/history/SalesResponse.dart';
import 'package:jakel_base/restapi/sales/model/history/SaveSaleResponse.dart';
import 'package:jakel_base/restapi/sales/model/NewSaleRequest.dart';
import 'package:jakel_base/restapi/sales/model/SaleReturnsResponse.dart';

import 'package:jakel_base/restapi/sales/model/void/VoidSaleReasonResponse.dart';
import 'package:jakel_base/restapi/sales/model/void/VoidSaleRequest.dart';

import 'model/NewOnHoldSaleRequest.dart';

abstract class SalesApi {
  Future<VoidSaleReasonResponse> getVoidSaleReason();

  Future<SaleReturnsResponse> getSaleReturnsReason();

  Future<SaveSaleResponse> saveNewSale(NewSaleRequest request);

  Future<SaveSaleResponse> voidSale(int saleId, VoidSaleRequest request);

  Future<SalesResponse> getSalesHistory(
      int pageNo,
      int perPage,
      int customerId,
      int employeeId,
      String? fromDate,
      String? toDate,
      String? searchText,
      int? counterId);

  Future<SalesResponse> getSaleById(String saleId);

  Future<SalesResponse> getPendingLayawaySale(String saleId);

  Future<SalesResponse> getLayawaySales(int pageNo, int perPage, int customerId,
      int employeeId, String? fromDate, String? toDate);

  Future<SalesResponse> getVoidSalesHistory(int pageNo, int perPage,
      int customerId, int employeeId, String? fromDate, String? toDate);

  Future<SaveSaleResponse> updateLayawayAmount(
      int saleId, UpdateLayawayAmountRequest request);

  Future<CancelLayawayResponse> cancelLayawayAmount(
      int saleId, CancelLayawayAmountRequest request);

  Future<SaveSaleResponse> updateLayawayLoyaltyPoints(
      int saleId, UpdateLayawayLoyaltyPointsRequest request);

  Future<SalesResponse> getSaleReturnsHistory(int pageNo, int perPage,
      int customerId, int employeeId, String? fromDate, String? toDate,String? searchText);


  Future<bool> holdSale(NewOnHoldSaleRequest request);

  Future<bool> cancelHoldSale(NewOnHoldSaleRequest request);

  Future<bool> releaseHoldSale(NewOnHoldSaleRequest request);

  Future<bool> completeHoldSale(NewOnHoldSaleRequest request);

  Future<HoldSaleTypesResponse> getHoldSaleTypes();
}
