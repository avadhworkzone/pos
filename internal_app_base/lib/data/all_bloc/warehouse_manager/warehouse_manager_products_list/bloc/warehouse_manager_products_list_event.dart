import 'package:equatable/equatable.dart';

enum GetWarehouseManagerProductsListEventStatus {
  initial,
  refresh,
  other
}

abstract class GetWarehouseManagerProductsListEvent extends Equatable{
  const GetWarehouseManagerProductsListEvent();
}

class GetWarehouseManagerProductsListClickEvent
    extends GetWarehouseManagerProductsListEvent {
  final dynamic mGetWarehouseManagerProductsListRequest;
  final GetWarehouseManagerProductsListEventStatus eventStatus;
  const GetWarehouseManagerProductsListClickEvent({required this.mGetWarehouseManagerProductsListRequest,required this.eventStatus });

  @override
  List<Object> get props => [mGetWarehouseManagerProductsListRequest];
}
