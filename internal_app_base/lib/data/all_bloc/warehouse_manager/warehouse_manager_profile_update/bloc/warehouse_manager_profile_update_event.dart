import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class PostWarehouseManagerProfileUpdateEvent extends Equatable {
  const PostWarehouseManagerProfileUpdateEvent();
}

class PostWarehouseManagerProfileUpdateClickEvent
    extends PostWarehouseManagerProfileUpdateEvent {
  final dynamic mPostWarehouseManagerProfileUpdateListRequest;
  const PostWarehouseManagerProfileUpdateClickEvent(
      {@required this.mPostWarehouseManagerProfileUpdateListRequest});

  @override
  List<Object> get props => [mPostWarehouseManagerProfileUpdateListRequest];
}
