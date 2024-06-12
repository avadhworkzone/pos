import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AddMemberEvent extends Equatable {
  const AddMemberEvent();
}

class AddMemberClickEvent extends AddMemberEvent {
  final dynamic mAddMemberListRequest;
  final dynamic mStoreID;
  const AddMemberClickEvent({@required this.mAddMemberListRequest, @required this.mStoreID});

  @override
  List<Object> get props => [mAddMemberListRequest, mStoreID];
}
