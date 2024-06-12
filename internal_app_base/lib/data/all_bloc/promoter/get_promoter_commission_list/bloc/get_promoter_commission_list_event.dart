import 'package:equatable/equatable.dart';

enum GetPromoterCommissionListEventStatus { initial, refresh, other }

abstract class GetPromoterCommissionListEvent extends Equatable {
  const GetPromoterCommissionListEvent();
}

class GetPromoterCommissionListClickEvent
    extends GetPromoterCommissionListEvent {
  final dynamic mGetPromoterCommissionListRequest;
  final GetPromoterCommissionListEventStatus eventStatus;
  const GetPromoterCommissionListClickEvent(
      {required this.mGetPromoterCommissionListRequest,
      required this.eventStatus});

  @override
  List<Object> get props => [mGetPromoterCommissionListRequest];
}
