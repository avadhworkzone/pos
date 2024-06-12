import 'package:equatable/equatable.dart';

enum GetStoreManagerSalesListEventStatus {
  initial,
  refresh,
  other
}

abstract class GetStoreManagerSalesListEvent extends Equatable{
  const GetStoreManagerSalesListEvent();
}

class GetStoreManagerSalesListClickEvent
    extends GetStoreManagerSalesListEvent {
  final dynamic mGetStoreManagerSalesListRequest;
  final dynamic mStringRequest;
  final GetStoreManagerSalesListEventStatus eventStatus;
  const GetStoreManagerSalesListClickEvent({required this.mGetStoreManagerSalesListRequest,required this.mStringRequest,required this.eventStatus });

  @override
  List<Object> get props => [mGetStoreManagerSalesListRequest,mStringRequest];
}
