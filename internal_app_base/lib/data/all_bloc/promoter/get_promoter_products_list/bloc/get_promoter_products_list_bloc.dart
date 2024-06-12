import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_products_list/bloc/get_promoter_products_list_event.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_products_list/bloc/get_promoter_products_list_state.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_products_list/repo/get_promoter_products_list_repo.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_products_list/repo/get_promoter_products_list_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';

class GetPromoterProductsListBloc extends Bloc<
    GetPromoterProductsListEvent, GetPromoterProductsListState> {
  final GetPromoterProductsListRepository repository =
      GetPromoterProductsListRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  GetPromoterProductsListBloc()
      : super(const GetPromoterProductsListState()) {
    on<GetPromoterProductsListClickEvent>(
      (event, emit) async {
        try {
          if (event.eventStatus ==
              GetPromoterProductsListEventStatus.initial) {
            if (state.mProductsList.isNotEmpty) {
              state.mProductsList.clear();
            }
            emit(state.copyWith(
                status: GetPromoterProductsListStatus.loading));
          } else if (event.eventStatus ==
              GetPromoterProductsListEventStatus.refresh) {
            if (state.mProductsList.isNotEmpty) {
              state.mProductsList.clear();
            }
          }else{
          }
          var response = await repository.fetchGetPromoterProductsList(
              event.mGetPromoterProductsListRequest);

          if (response is GetPromoterProductsListResponse) {
            if (response.products != null ) {
              if (response.products!.isNotEmpty) {
                emit(state.copyWith(
                  mGetPromoterProductsListResponse: response,
                    status: GetPromoterProductsListStatus.success,
                    mProductsList: List.of(state.mProductsList)
                      ..addAll(
                        response.products!,
                      ),
                    hasReachedMax: response.lastPage));
              } else {
                emit(state.copyWith(
                    status: GetPromoterProductsListStatus.success,
                    mGetPromoterProductsListResponse: response,
                    mProductsList: state.mProductsList,
                    hasReachedMax: response.lastPage));
              }
            } else {
              emit(state.copyWith(
                  status: GetPromoterProductsListStatus.failed,
                  webResponseFailed: WebResponseFailed(
                      statusMessage:
                          "Unable to process your request right now")));
            }
          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: GetPromoterProductsListStatus.failed,
                webResponseFailed: response));
          }
        } catch (e) {
          emit(state.copyWith(
              status: GetPromoterProductsListStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
