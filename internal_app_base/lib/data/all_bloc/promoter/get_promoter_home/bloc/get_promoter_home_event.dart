import 'package:equatable/equatable.dart';

abstract class GetPromoterHomeEvent extends Equatable{
  const GetPromoterHomeEvent();
}

class GetPromoterHomeClickEvent
    extends GetPromoterHomeEvent {

  final dynamic mGetPromoterHomeRequest;
  const GetPromoterHomeClickEvent({required this.mGetPromoterHomeRequest});

  @override
  List<Object> get props => [mGetPromoterHomeRequest];
}
