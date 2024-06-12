import 'package:equatable/equatable.dart';

abstract class GetStoreManagerStoresListEvent extends Equatable{
  const GetStoreManagerStoresListEvent();
}

class GetStoreManagerStoresListClickEvent
    extends GetStoreManagerStoresListEvent {
  const GetStoreManagerStoresListClickEvent();

  @override
  List<Object> get props => [];
}
