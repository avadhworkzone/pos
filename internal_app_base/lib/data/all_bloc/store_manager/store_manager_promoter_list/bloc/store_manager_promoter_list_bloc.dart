import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_promoter_list/bloc/store_manager_promoter_list_event.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_promoter_list/bloc/store_manager_promoter_list_state.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_promoter_list/repo/store_manager_promoter_list_repo.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_promoter_list/repo/store_manager_promoter_list_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';

class GetStoreManagerPromoterListBloc extends Bloc<
    GetStoreManagerPromoterListEvent, GetStoreManagerPromoterListState> {
  final GetStoreManagerPromoterListRepository repository =
      GetStoreManagerPromoterListRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  GetStoreManagerPromoterListBloc()
      : super(const GetStoreManagerPromoterListState()) {
    on<GetStoreManagerPromoterListClickEvent>(
      (event, emit) async {
        try {
          if (event.eventStatus ==
              GetStoreManagerPromoterListEventStatus.initial) {
            if (state.mPromoterListData.isNotEmpty) {
              state.mPromoterListData.clear();
            }
            emit(state.copyWith(
                status: GetStoreManagerPromoterListStatus.loading));
          } else if (event.eventStatus ==
              GetStoreManagerPromoterListEventStatus.refresh) {
            if (state.mPromoterListData.isNotEmpty) {
              state.mPromoterListData.clear();
            }
          } else {}
          var response = await repository.fetchGetStoreManagerPromoterList(
              event.mGetStoreManagerPromoterListRequest);

          if (response is GetStoreManagerPromoterListResponse) {
            if (response.promoters != null) {
              if (response.promoters!.isNotEmpty) {
                emit(state.copyWith(
                  mGetStoreManagerPromoterListResponse: response,
                  status: GetStoreManagerPromoterListStatus.success,
                  mPromoterListData: List.of(state.mPromoterListData)
                    ..addAll(
                      response.promoters!,
                    ),
                ));
              } else {
                emit(state.copyWith(
                  status: GetStoreManagerPromoterListStatus.success,
                  mGetStoreManagerPromoterListResponse: response,
                  mPromoterListData: state.mPromoterListData,
                ));
              }
            } else {
              emit(state.copyWith(
                  status: GetStoreManagerPromoterListStatus.failed,
                  webResponseFailed: WebResponseFailed(
                      statusMessage:
                          "Unable to process your request right now")));
            }
          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: GetStoreManagerPromoterListStatus.failed,
                webResponseFailed: response));
          }
        } catch (e) {
          emit(state.copyWith(
              status: GetStoreManagerPromoterListStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
