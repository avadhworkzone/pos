import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ProfileDeleteEvent extends Equatable{
  const ProfileDeleteEvent();
}

class ProfileDeleteClickEvent
    extends ProfileDeleteEvent {
  final dynamic mProfileDeleteListRequest;
  const ProfileDeleteClickEvent({@required this.mProfileDeleteListRequest});

  @override
  List<Object> get props => [mProfileDeleteListRequest];
}
