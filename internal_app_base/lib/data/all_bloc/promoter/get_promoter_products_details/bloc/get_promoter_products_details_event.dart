import 'package:equatable/equatable.dart';

abstract class GetPromoterProductsDetailsEvent extends Equatable{
  const GetPromoterProductsDetailsEvent();
}

class GetPromoterProductsDetailsClickEvent
    extends GetPromoterProductsDetailsEvent {

  final dynamic mGetPromoterProductsDetailsRequest;
  const GetPromoterProductsDetailsClickEvent({required this.mGetPromoterProductsDetailsRequest});

  @override
  List<Object> get props => [mGetPromoterProductsDetailsRequest];
}
