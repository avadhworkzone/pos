import 'package:equatable/equatable.dart';

abstract class GetPromoterStoresEvent extends Equatable{
  const GetPromoterStoresEvent();
}

class GetPromoterStoresClickEvent
    extends GetPromoterStoresEvent {
  const GetPromoterStoresClickEvent();

  @override
  List<Object> get props => [];
}
