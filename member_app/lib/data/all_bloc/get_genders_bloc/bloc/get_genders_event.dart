import 'package:equatable/equatable.dart';


abstract class GetGendersEvent extends Equatable{
  const GetGendersEvent();
}

class GetGendersClickEvent
    extends GetGendersEvent {
  const GetGendersClickEvent();

  @override
  List<Object> get props => [];
}
