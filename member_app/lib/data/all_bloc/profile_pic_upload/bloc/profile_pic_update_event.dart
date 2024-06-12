import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ProfilePicUpdateEvent extends Equatable{
  const ProfilePicUpdateEvent();
}

class ProfilePicUpdateClickEvent
    extends ProfilePicUpdateEvent {
  final dynamic mProfilePicUpdateListRequest;
  const ProfilePicUpdateClickEvent({@required this.mProfilePicUpdateListRequest});

  @override
  List<Object> get props => [mProfilePicUpdateListRequest];
}
