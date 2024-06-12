import 'package:equatable/equatable.dart';

abstract class GetMemberEvent extends Equatable{
  const GetMemberEvent();
}

class GetMemberClickEvent
    extends GetMemberEvent {
  const GetMemberClickEvent();

  @override
  List<Object> get props => [];
}
