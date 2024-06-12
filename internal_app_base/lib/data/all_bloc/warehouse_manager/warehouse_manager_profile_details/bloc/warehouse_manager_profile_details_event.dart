import 'package:equatable/equatable.dart';

abstract class GetWarehouseManagerProfileDetailsEvent extends Equatable {
  const GetWarehouseManagerProfileDetailsEvent();
}

class GetWarehouseManagerProfileDetailsClickEvent
    extends GetWarehouseManagerProfileDetailsEvent {
  final dynamic mGetWarehouseManagerProfileDetailsRequest;
  const GetWarehouseManagerProfileDetailsClickEvent(
      {required this.mGetWarehouseManagerProfileDetailsRequest});

  @override
  List<Object> get props => [mGetWarehouseManagerProfileDetailsRequest];
}
