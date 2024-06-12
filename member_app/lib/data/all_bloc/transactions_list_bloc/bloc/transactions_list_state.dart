import 'package:equatable/equatable.dart';
import 'package:member_app/data/all_bloc/transactions_list_bloc/repo/transactions_list_response.dart';
import 'package:member_app/data/remote/web_response_failed.dart';

enum TransactionsListStatus { loading, success, failed }

class TransactionsListState extends Equatable {
  const TransactionsListState(
      {this.status = TransactionsListStatus.loading,
        this.loyaltyPointsList = const <LoyaltyPoints>[],
        this.mTransactionsListResponse,
        this.webResponseFailed,
      this.hasReachedMax= false});

  final TransactionsListStatus status;
  final List<LoyaltyPoints> loyaltyPointsList;
  final TransactionsListResponse? mTransactionsListResponse;
  final WebResponseFailed? webResponseFailed;
  final bool hasReachedMax;


  TransactionsListState copyWith({
    TransactionsListStatus? status,
    List<LoyaltyPoints>? loyaltyPointsList,
    TransactionsListResponse? mTransactionsListResponse,
    WebResponseFailed? webResponseFailed,
    bool? hasReachedMax
  }) {
    return TransactionsListState(
      status: status ?? this.status,
      loyaltyPointsList:
      loyaltyPointsList ?? this.loyaltyPointsList,
      mTransactionsListResponse:
      mTransactionsListResponse ?? this.mTransactionsListResponse,
      webResponseFailed:  webResponseFailed ?? this.webResponseFailed,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, TransactionsListResponse: $loyaltyPointsList }''';
  }

  @override
  List<Object> get props => [
    status,
    loyaltyPointsList,
    mTransactionsListResponse??TransactionsListResponse(),
    webResponseFailed ?? WebResponseFailed(),
    hasReachedMax
  ];
}
