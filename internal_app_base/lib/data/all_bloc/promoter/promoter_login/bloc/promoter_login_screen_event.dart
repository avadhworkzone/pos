import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class PromoterLoginScreenEvent extends Equatable{
  const PromoterLoginScreenEvent();
}

class PromoterLoginScreenClickEvent
    extends PromoterLoginScreenEvent {
  final dynamic mPromoterLoginScreenListRequest;
  const PromoterLoginScreenClickEvent({@required this.mPromoterLoginScreenListRequest});

  @override
  List<Object> get props => [mPromoterLoginScreenListRequest];
}
