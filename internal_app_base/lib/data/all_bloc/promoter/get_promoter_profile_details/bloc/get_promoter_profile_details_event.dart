import 'package:equatable/equatable.dart';

abstract class GetPromoteProfileDetailsEvent extends Equatable{
  const GetPromoteProfileDetailsEvent();
}

class GetPromoteProfileDetailsClickEvent
    extends GetPromoteProfileDetailsEvent {

  final dynamic mGetPromoteProfileDetailsRequest;
  const GetPromoteProfileDetailsClickEvent({required this.mGetPromoteProfileDetailsRequest});

  @override
  List<Object> get props => [mGetPromoteProfileDetailsRequest];
}
