import 'package:equatable/equatable.dart';

abstract class GetRacesEvent extends Equatable{
  const GetRacesEvent();
}

class GetRacesClickEvent
    extends GetRacesEvent {
  const GetRacesClickEvent();

  @override
  List<Object> get props => [];
}
