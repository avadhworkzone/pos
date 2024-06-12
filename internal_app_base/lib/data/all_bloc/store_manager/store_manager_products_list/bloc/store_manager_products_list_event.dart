import 'package:equatable/equatable.dart';

enum GetStoreManagerProductsListEventStatus {
  initial,
  refresh,
  other
}

abstract class GetStoreManagerProductsListEvent extends Equatable{
  const GetStoreManagerProductsListEvent();
}

class GetStoreManagerProductsListClickEvent
    extends GetStoreManagerProductsListEvent {
  final dynamic mGetStoreManagerProductsListRequest;
  final GetStoreManagerProductsListEventStatus eventStatus;
  const GetStoreManagerProductsListClickEvent({required this.mGetStoreManagerProductsListRequest,required this.eventStatus });

  @override
  List<Object> get props => [mGetStoreManagerProductsListRequest];
}
