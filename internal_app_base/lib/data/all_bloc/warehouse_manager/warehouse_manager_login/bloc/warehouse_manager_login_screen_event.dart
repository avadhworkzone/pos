import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class WarehouseManagerLoginScreenEvent extends Equatable{
  const WarehouseManagerLoginScreenEvent();
}

class WarehouseManagerLoginScreenClickEvent
    extends WarehouseManagerLoginScreenEvent {
  final dynamic mWarehouseManagerLoginScreenListRequest;
  const WarehouseManagerLoginScreenClickEvent({@required this.mWarehouseManagerLoginScreenListRequest});

  @override
  List<Object> get props => [mWarehouseManagerLoginScreenListRequest];
}
