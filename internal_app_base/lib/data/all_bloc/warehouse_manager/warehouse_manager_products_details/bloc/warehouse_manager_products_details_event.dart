import 'package:equatable/equatable.dart';

abstract class GetWarehouseManagerProductsDetailsEvent extends Equatable{
  const GetWarehouseManagerProductsDetailsEvent();
}

class GetWarehouseManagerProductsDetailsClickEvent
    extends GetWarehouseManagerProductsDetailsEvent {

  final dynamic mGetWarehouseManagerProductsDetailsRequest;
  const GetWarehouseManagerProductsDetailsClickEvent({required this.mGetWarehouseManagerProductsDetailsRequest});

  @override
  List<Object> get props => [mGetWarehouseManagerProductsDetailsRequest];
}
