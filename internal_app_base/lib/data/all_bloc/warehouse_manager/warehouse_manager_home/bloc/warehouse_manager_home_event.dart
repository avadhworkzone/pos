import 'package:equatable/equatable.dart';

abstract class GetWarehouseManagerHomeEvent extends Equatable {
  const GetWarehouseManagerHomeEvent();
}

class GetWarehouseManagerHomeClickEvent extends GetWarehouseManagerHomeEvent {
  final dynamic mGetWarehouseManagerHomeRequest;
  const GetWarehouseManagerHomeClickEvent(
      {required this.mGetWarehouseManagerHomeRequest});

  @override
  List<Object> get props => [mGetWarehouseManagerHomeRequest];
}
