import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_sales_returns_list/bloc/get_promoter_sales_returns_list_event.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_sales_returns_list/bloc/get_promoter_sales_returns_list_state.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_sales_returns_list/repo/GetPromoterSalesReturnsListResponse.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_sales_returns_list/repo/get_promoter_sales_returns_list_repo.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';

class GetPromoterSalesReturnsListBloc extends Bloc<
    GetPromoterSalesReturnsListEvent, GetPromoterSalesReturnsListState> {
  final GetPromoterSalesReturnsListRepository repository =
      GetPromoterSalesReturnsListRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  GetPromoterSalesReturnsListBloc()
      : super(const GetPromoterSalesReturnsListState()) {
    on<GetPromoterSalesReturnsListClickEvent>(
      (event, emit) async {
        try {
          if (event.eventStatus ==
              GetPromoterSalesReturnsListEventStatus.initial) {
            if (state.mPromoterCommission.isNotEmpty) {
              state.mPromoterCommission.clear();
            }
            emit(state.copyWith(
                status: GetPromoterSalesReturnsListStatus.loading));
          } else if (event.eventStatus ==
              GetPromoterSalesReturnsListEventStatus.refresh) {
            if (state.mPromoterCommission.isNotEmpty) {
              state.mPromoterCommission.clear();
            }
          } else {}
          var response = await repository.fetchGetPromoterSalesReturnsList(
              event.mGetPromoterSalesReturnsListRequest);

          if (response is GetPromoterSalesReturnsListResponse) {
            if (response.sales != null) {
              if (response.sales!.isNotEmpty) {
                emit(state.copyWith(
                    mGetPromoterSalesReturnsListResponse: response,
                    status: GetPromoterSalesReturnsListStatus.success,
                    mPromoterCommission: List.of(state.mPromoterCommission)
                      ..addAll(
                        response.sales!,
                      ),
                    hasReachedMax: response.lastPage));
              } else {
                emit(state.copyWith(
                    status: GetPromoterSalesReturnsListStatus.success,
                    mGetPromoterSalesReturnsListResponse: response,
                    mPromoterCommission: state.mPromoterCommission,
                    hasReachedMax: response.lastPage));
              }
            } else {
              emit(state.copyWith(
                  status: GetPromoterSalesReturnsListStatus.failed,
                  webResponseFailed: WebResponseFailed(
                      statusMessage:
                          "Unable to process your request right now")));
            }
          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: GetPromoterSalesReturnsListStatus.failed,
                webResponseFailed: response));
          }
        } catch (e) {
          emit(state.copyWith(
              status: GetPromoterSalesReturnsListStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
