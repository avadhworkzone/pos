import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class PostPromoterProfileUpdateEvent extends Equatable{
  const PostPromoterProfileUpdateEvent();
}

class PostPromoterProfileUpdateClickEvent
    extends PostPromoterProfileUpdateEvent {
  final dynamic mPostPromoterProfileUpdateListRequest;
  const PostPromoterProfileUpdateClickEvent({@required this.mPostPromoterProfileUpdateListRequest});

  @override
  List<Object> get props => [mPostPromoterProfileUpdateListRequest];
}
