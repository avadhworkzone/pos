import 'package:equatable/equatable.dart';

enum TransactionsListEventStatus {
  initial,
  refresh,
  other
}

abstract class TransactionsListEvent extends Equatable{
  const TransactionsListEvent();
}

class TransactionsListClickEvent
    extends TransactionsListEvent {
  final dynamic mTransactionsListRequest;
  final TransactionsListEventStatus eventStatus;
  const TransactionsListClickEvent({required this.mTransactionsListRequest,required this.eventStatus });

  @override
  List<Object> get props => [mTransactionsListRequest];
}
