import 'package:equatable/equatable.dart';

enum GetWarehouseManagerProductsStockListEventStatus { initial, refresh, other }

abstract class GetWarehouseManagerProductsStockListEvent extends Equatable {
  const GetWarehouseManagerProductsStockListEvent();
}

class GetWarehouseManagerProductsStockListClickEvent
    extends GetWarehouseManagerProductsStockListEvent {
  final dynamic mGetWarehouseManagerProductsStockListRequest;
  final dynamic mStringRequest;
  final GetWarehouseManagerProductsStockListEventStatus eventStatus;
  const GetWarehouseManagerProductsStockListClickEvent(
      {required this.mGetWarehouseManagerProductsStockListRequest,
      required this.mStringRequest,
      required this.eventStatus});

  @override
  List<Object> get props =>
      [mGetWarehouseManagerProductsStockListRequest, mStringRequest];
}
