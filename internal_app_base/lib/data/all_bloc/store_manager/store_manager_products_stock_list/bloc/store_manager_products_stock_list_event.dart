import 'package:equatable/equatable.dart';

enum GetStoreManagerProductsStockListEventStatus {
  initial,
  refresh,
  other
}

abstract class GetStoreManagerProductsStockListEvent extends Equatable{
  const GetStoreManagerProductsStockListEvent();
}

class GetStoreManagerProductsStockListClickEvent
    extends GetStoreManagerProductsStockListEvent {
  final dynamic mGetStoreManagerProductsStockListRequest;
  final dynamic mStringRequest;
  final GetStoreManagerProductsStockListEventStatus eventStatus;
  const GetStoreManagerProductsStockListClickEvent({required this.mGetStoreManagerProductsStockListRequest,required this.mStringRequest,required this.eventStatus });

  @override
  List<Object> get props => [mGetStoreManagerProductsStockListRequest,mStringRequest];
}
