import 'package:equatable/equatable.dart';

enum GetPromoterProductsListEventStatus {
  initial,
  refresh,
  other
}

abstract class GetPromoterProductsListEvent extends Equatable{
  const GetPromoterProductsListEvent();
}

class GetPromoterProductsListClickEvent
    extends GetPromoterProductsListEvent {
  final dynamic mGetPromoterProductsListRequest;
  final GetPromoterProductsListEventStatus eventStatus;
  const GetPromoterProductsListClickEvent({required this.mGetPromoterProductsListRequest,required this.eventStatus });

  @override
  List<Object> get props => [mGetPromoterProductsListRequest];
}
