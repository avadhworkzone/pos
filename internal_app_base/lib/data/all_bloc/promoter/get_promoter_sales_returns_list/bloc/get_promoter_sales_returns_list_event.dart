import 'package:equatable/equatable.dart';

enum GetPromoterSalesReturnsListEventStatus { initial, refresh, other }

abstract class GetPromoterSalesReturnsListEvent extends Equatable {
  const GetPromoterSalesReturnsListEvent();
}

class GetPromoterSalesReturnsListClickEvent
    extends GetPromoterSalesReturnsListEvent {
  final dynamic mGetPromoterSalesReturnsListRequest;
  final GetPromoterSalesReturnsListEventStatus eventStatus;
  const GetPromoterSalesReturnsListClickEvent(
      {required this.mGetPromoterSalesReturnsListRequest,
      required this.eventStatus});

  @override
  List<Object> get props => [mGetPromoterSalesReturnsListRequest];
}
