import 'package:equatable/equatable.dart';

abstract class GetStoreManagerProfileDetailsEvent extends Equatable{
  const GetStoreManagerProfileDetailsEvent();
}

class GetStoreManagerProfileDetailsClickEvent
    extends GetStoreManagerProfileDetailsEvent {

  final dynamic mGetStoreManagerProfileDetailsRequest;
  const GetStoreManagerProfileDetailsClickEvent({required this.mGetStoreManagerProfileDetailsRequest});

  @override
  List<Object> get props => [mGetStoreManagerProfileDetailsRequest];
}
