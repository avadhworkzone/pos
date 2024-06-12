import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class StoreManagerLoginScreenEvent extends Equatable{
  const StoreManagerLoginScreenEvent();
}

class StoreManagerLoginScreenClickEvent
    extends StoreManagerLoginScreenEvent {
  final dynamic mStoreManagerLoginScreenListRequest;
  const StoreManagerLoginScreenClickEvent({@required this.mStoreManagerLoginScreenListRequest});

  @override
  List<Object> get props => [mStoreManagerLoginScreenListRequest];
}
