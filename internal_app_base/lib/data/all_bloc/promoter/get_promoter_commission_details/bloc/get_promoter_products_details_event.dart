import 'package:equatable/equatable.dart';

abstract class GetPromoterCommissionDetailsEvent extends Equatable {
  const GetPromoterCommissionDetailsEvent();
}

class GetPromoterCommissionDetailsClickEvent
    extends GetPromoterCommissionDetailsEvent {
  final dynamic mGetPromoterCommissionDetailsRequest;
  const GetPromoterCommissionDetailsClickEvent(
      {required this.mGetPromoterCommissionDetailsRequest});

  @override
  List<Object> get props => [mGetPromoterCommissionDetailsRequest];
}
