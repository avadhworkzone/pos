import 'package:equatable/equatable.dart';

abstract class GetStoreManagerHomeEvent extends Equatable{
  const GetStoreManagerHomeEvent();
}

class GetStoreManagerHomeClickEvent
    extends GetStoreManagerHomeEvent {

  final dynamic mGetStoreManagerHomeRequest;
  const GetStoreManagerHomeClickEvent({required this.mGetStoreManagerHomeRequest});

  @override
  List<Object> get props => [mGetStoreManagerHomeRequest];
}
