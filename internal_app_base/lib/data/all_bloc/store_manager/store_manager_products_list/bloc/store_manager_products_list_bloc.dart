import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_products_list/bloc/store_manager_products_list_event.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_products_list/bloc/store_manager_products_list_state.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_products_list/repo/store_manager_products_list_repo.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_products_list/repo/store_manager_products_list_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';

class GetStoreManagerProductsListBloc extends Bloc<
    GetStoreManagerProductsListEvent, GetStoreManagerProductsListState> {
  final GetStoreManagerProductsListRepository repository =
      GetStoreManagerProductsListRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  GetStoreManagerProductsListBloc()
      : super(const GetStoreManagerProductsListState()) {
    on<GetStoreManagerProductsListClickEvent>(
      (event, emit) async {
        try {
          if (event.eventStatus ==
              GetStoreManagerProductsListEventStatus.initial) {
            if (state.mProductsList.isNotEmpty) {
              state.mProductsList.clear();
            }
            emit(state.copyWith(
                status: GetStoreManagerProductsListStatus.loading));
          } else if (event.eventStatus ==
              GetStoreManagerProductsListEventStatus.refresh) {
            if (state.mProductsList.isNotEmpty) {
              state.mProductsList.clear();
            }
          }else{
          }
          var response = await repository.fetchGetStoreManagerProductsList(
              event.mGetStoreManagerProductsListRequest);

          if (response is GetStoreManagerProductsListResponse) {
            if (response.products != null ) {
              if (response.products!.isNotEmpty) {
                emit(state.copyWith(
                  mGetStoreManagerProductsListResponse: response,
                    status: GetStoreManagerProductsListStatus.success,
                    mProductsList: List.of(state.mProductsList)
                      ..addAll(
                        response.products!,
                      ),
                    hasReachedMax: response.lastPage));
              } else {
                emit(state.copyWith(
                    status: GetStoreManagerProductsListStatus.success,
                    mGetStoreManagerProductsListResponse: response,
                    mProductsList: state.mProductsList,
                    hasReachedMax: response.lastPage));
              }
            } else {
              emit(state.copyWith(
                  status: GetStoreManagerProductsListStatus.failed,
                  webResponseFailed: WebResponseFailed(
                      statusMessage:
                          "Unable to process your request right now")));
            }
          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: GetStoreManagerProductsListStatus.failed,
                webResponseFailed: response));
          }
        } catch (e) {
          emit(state.copyWith(
              status: GetStoreManagerProductsListStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
