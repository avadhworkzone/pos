import 'package:equatable/equatable.dart';

enum MemberVoucherPaginatedListEventStatus {
  initial,
  refresh,
  other
}

abstract class MemberVoucherPaginatedListEvent extends Equatable{
  const MemberVoucherPaginatedListEvent();
}

class MemberVoucherPaginatedListClickEvent
    extends MemberVoucherPaginatedListEvent {
  final dynamic mMemberVoucherPaginatedListRequest;
  final MemberVoucherPaginatedListEventStatus eventStatus;
  const MemberVoucherPaginatedListClickEvent({required this.mMemberVoucherPaginatedListRequest,required this.eventStatus });

  @override
  List<Object> get props => [mMemberVoucherPaginatedListRequest];
}
