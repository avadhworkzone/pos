import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class PostStoreManagerProfileUpdateEvent extends Equatable{
  const PostStoreManagerProfileUpdateEvent();
}

class PostStoreManagerProfileUpdateClickEvent
    extends PostStoreManagerProfileUpdateEvent {
  final dynamic mPostStoreManagerProfileUpdateListRequest;
  const PostStoreManagerProfileUpdateClickEvent({@required this.mPostStoreManagerProfileUpdateListRequest});

  @override
  List<Object> get props => [mPostStoreManagerProfileUpdateListRequest];
}
