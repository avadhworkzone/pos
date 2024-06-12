import 'package:equatable/equatable.dart';

enum GetPromoterProductsStockListEventStatus {
  initial,
  refresh,
  other
}

abstract class GetPromoterProductsStockListEvent extends Equatable{
  const GetPromoterProductsStockListEvent();
}

class GetPromoterProductsStockListClickEvent
    extends GetPromoterProductsStockListEvent {
  final dynamic mGetPromoterProductsStockListRequest;
  final dynamic mStringRequest;
  final GetPromoterProductsStockListEventStatus eventStatus;
  const GetPromoterProductsStockListClickEvent({required this.mGetPromoterProductsStockListRequest,required this.mStringRequest,required this.eventStatus });

  @override
  List<Object> get props => [mGetPromoterProductsStockListRequest,mStringRequest];
}
