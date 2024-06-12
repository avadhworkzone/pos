import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ProfileUpdateEvent extends Equatable{
  const ProfileUpdateEvent();
}

class ProfileUpdateClickEvent
    extends ProfileUpdateEvent {
  final dynamic mProfileUpdateListRequest;
  const ProfileUpdateClickEvent({@required this.mProfileUpdateListRequest});

  @override
  List<Object> get props => [mProfileUpdateListRequest];
}
