import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_commission_list/bloc/get_promoter_commission_list_event.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_commission_list/bloc/get_promoter_commission_list_state.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_commission_list/repo/get_promoter_commission_list_repo.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_commission_list/repo/get_promoter_commission_list_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';

class GetPromoterCommissionListBloc extends Bloc<GetPromoterCommissionListEvent,
    GetPromoterCommissionListState> {
  final GetPromoterCommissionListRepository repository =
      GetPromoterCommissionListRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  GetPromoterCommissionListBloc()
      : super(const GetPromoterCommissionListState()) {
    on<GetPromoterCommissionListClickEvent>(
      (event, emit) async {
        try {
          if (event.eventStatus ==
              GetPromoterCommissionListEventStatus.initial) {
            if (state.mCommissionList.isNotEmpty) {
              state.mCommissionList.clear();
            }
            emit(state.copyWith(
                status: GetPromoterCommissionListStatus.loading));
          } else if (event.eventStatus ==
              GetPromoterCommissionListEventStatus.refresh) {
            if (state.mCommissionList.isNotEmpty) {
              state.mCommissionList.clear();
            }
          } else {}
          var response = await repository.fetchGetPromoterCommissionList(
              event.mGetPromoterCommissionListRequest);

          if (response is GetPromoterCommissionListResponse) {
            if (response.commissionHistory != null) {
              if (response.commissionHistory!.isNotEmpty) {
                emit(state.copyWith(
                    mGetPromoterCommissionListResponse: response,
                    status: GetPromoterCommissionListStatus.success,
                    mCommissionList: List.of(state.mCommissionList)
                      ..addAll(
                        response.commissionHistory!,
                      ),
                    hasReachedMax: response.lastPage));
              } else {
                emit(state.copyWith(
                    status: GetPromoterCommissionListStatus.success,
                    mGetPromoterCommissionListResponse: response,
                    mCommissionList: state.mCommissionList,
                    hasReachedMax: response.lastPage));
              }
            } else {
              emit(state.copyWith(
                  status: GetPromoterCommissionListStatus.failed,
                  webResponseFailed: WebResponseFailed(
                      statusMessage:
                          "Unable to process your request right now")));
            }
          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: GetPromoterCommissionListStatus.failed,
                webResponseFailed: response));
          }
        } catch (e) {
          emit(state.copyWith(
              status: GetPromoterCommissionListStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
