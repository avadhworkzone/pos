import 'package:equatable/equatable.dart';

abstract class GetStoreManagerProductsDetailsEvent extends Equatable{
  const GetStoreManagerProductsDetailsEvent();
}

class GetStoreManagerProductsDetailsClickEvent
    extends GetStoreManagerProductsDetailsEvent {

  final dynamic mGetStoreManagerProductsDetailsRequest;
  const GetStoreManagerProductsDetailsClickEvent({required this.mGetStoreManagerProductsDetailsRequest});

  @override
  List<Object> get props => [mGetStoreManagerProductsDetailsRequest];
}
