import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class GetMemberDetailsEvent extends Equatable{
  const GetMemberDetailsEvent();
}

class GetMemberDetailsClickEvent
    extends GetMemberDetailsEvent {
  const GetMemberDetailsClickEvent();

  @override
  List<Object> get props => [];
}
