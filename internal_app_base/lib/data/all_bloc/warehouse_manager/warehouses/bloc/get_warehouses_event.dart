import 'package:equatable/equatable.dart';

abstract class GetWarehousesEvent extends Equatable {
  const GetWarehousesEvent();
}

class GetWarehousesClickEvent extends GetWarehousesEvent {
  const GetWarehousesClickEvent();

  @override
  List<Object> get props => [];
}
