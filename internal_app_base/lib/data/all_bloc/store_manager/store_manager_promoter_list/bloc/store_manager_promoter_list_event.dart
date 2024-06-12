import 'package:equatable/equatable.dart';

enum GetStoreManagerPromoterListEventStatus { initial, refresh, loading, other }

abstract class GetStoreManagerPromoterListEvent extends Equatable {
  const GetStoreManagerPromoterListEvent();
}

class GetStoreManagerPromoterListClickEvent
    extends GetStoreManagerPromoterListEvent {
  final dynamic mGetStoreManagerPromoterListRequest;
  // final dynamic mStringRequest;
  final GetStoreManagerPromoterListEventStatus eventStatus;
  const GetStoreManagerPromoterListClickEvent(
      {required this.mGetStoreManagerPromoterListRequest,
      required this.eventStatus});

  @override
  List<Object> get props => [
        mGetStoreManagerPromoterListRequest,
      ];
}
