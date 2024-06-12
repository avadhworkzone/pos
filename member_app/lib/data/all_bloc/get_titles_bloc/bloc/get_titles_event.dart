import 'package:equatable/equatable.dart';

abstract class GetTitlesEvent extends Equatable{
  const GetTitlesEvent();
}

class GetTitlesClickEvent
    extends GetTitlesEvent {
  const GetTitlesClickEvent();

  @override
  List<Object> get props => [];
}
