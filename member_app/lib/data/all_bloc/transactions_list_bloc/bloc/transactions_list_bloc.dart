import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:member_app/data/all_bloc/transactions_list_bloc/bloc/transactions_list_event.dart';
import 'package:member_app/data/all_bloc/transactions_list_bloc/bloc/transactions_list_state.dart';
import 'package:member_app/data/all_bloc/transactions_list_bloc/repo/transactions_list_repo.dart';
import 'package:member_app/data/all_bloc/transactions_list_bloc/repo/transactions_list_response.dart';
import 'package:member_app/data/local/shared_prefs/shared_prefs.dart';
import 'package:member_app/data/remote/web_response_failed.dart';
import 'package:member_app/data/remote/web_service.dart';

class TransactionsListBloc extends Bloc<
    TransactionsListEvent, TransactionsListState> {
  final TransactionsListRepository repository =
      TransactionsListRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  TransactionsListBloc()
      : super(const TransactionsListState()) {
    on<TransactionsListClickEvent>(
      (event, emit) async {
        try {
          if (event.eventStatus ==
              TransactionsListEventStatus.initial) {
            if (state.loyaltyPointsList.isNotEmpty) {
              state.loyaltyPointsList.clear();
            }
            emit(state.copyWith(
                status: TransactionsListStatus.loading));
          } else if (event.eventStatus ==
              TransactionsListEventStatus.refresh) {
            if (state.loyaltyPointsList.isNotEmpty) {
              state.loyaltyPointsList.clear();
            }
          }else{
          }
          var response = await repository.fetchTransactionsList(
              event.mTransactionsListRequest);

          if (response is TransactionsListResponse) {
            if (response.loyaltyPoints != null ) {
              if (response.loyaltyPoints!.isNotEmpty) {
                emit(state.copyWith(
                  mTransactionsListResponse: response,
                    status: TransactionsListStatus.success,
                    loyaltyPointsList: List.of(state.loyaltyPointsList)
                      ..addAll(
                        response.loyaltyPoints!,
                      ),
                    hasReachedMax: response.loyaltyPoints!.length==10));
              } else {
                emit(state.copyWith(
                    status: TransactionsListStatus.success,
                    mTransactionsListResponse: response,
                    loyaltyPointsList: state.loyaltyPointsList,
                    hasReachedMax: false));
              }
            } else {
              emit(state.copyWith(
                  status: TransactionsListStatus.failed,
                  webResponseFailed: WebResponseFailed(
                      statusMessage:
                          "Unable to process your request right now")));
            }
          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: TransactionsListStatus.failed,
                webResponseFailed: WebResponseFailed(
                    statusMessage:
                        "Unable to process your request right now")));
          }
        } catch (e) {
          emit(state.copyWith(
              status: TransactionsListStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
