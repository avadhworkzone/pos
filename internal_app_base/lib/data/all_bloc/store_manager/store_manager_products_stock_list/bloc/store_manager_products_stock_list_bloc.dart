import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_products_stock_list/bloc/store_manager_products_stock_list_event.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_products_stock_list/bloc/store_manager_products_stock_list_state.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_products_stock_list/repo/store_manager_products_stock_list_repo.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_products_stock_list/repo/store_manager_products_stock_list_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';

class GetStoreManagerProductsStockListBloc extends Bloc<
    GetStoreManagerProductsStockListEvent,
    GetStoreManagerProductsStockListState> {
  final GetStoreManagerProductsStockListRepository repository =
      GetStoreManagerProductsStockListRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  GetStoreManagerProductsStockListBloc()
      : super(const GetStoreManagerProductsStockListState()) {
    on<GetStoreManagerProductsStockListClickEvent>(
      (event, emit) async {
        try {
          if (event.eventStatus ==
              GetStoreManagerProductsStockListEventStatus.initial) {
            if (state.mStoreStock.isNotEmpty) {
              state.mStoreStock.clear();
            }
            emit(state.copyWith(
                status: GetStoreManagerProductsStockListStatus.loading));
          } else if (event.eventStatus ==
              GetStoreManagerProductsStockListEventStatus.refresh) {
            if (state.mStoreStock.isNotEmpty) {
              state.mStoreStock.clear();
            }
          } else {}
          var response = await repository.fetchGetStoreManagerProductsStockList(
              event.mGetStoreManagerProductsStockListRequest,
              event.mStringRequest);

          if (response is GetStoreManagerProductsStockListResponse) {
            if (response.storeStock != null) {
              if (response.storeStock!.isNotEmpty) {
                emit(state.copyWith(
                    mGetStoreManagerProductsStockListResponse: response,
                    status: GetStoreManagerProductsStockListStatus.success,
                    mStoreStock: List.of(state.mStoreStock)
                      ..addAll(
                        response.storeStock!,
                      ),
                    hasReachedMax: response.lastPage));
              } else {
                emit(state.copyWith(
                    status: GetStoreManagerProductsStockListStatus.success,
                    mGetStoreManagerProductsStockListResponse: response,
                    mStoreStock: state.mStoreStock,
                    hasReachedMax: response.lastPage));
              }
            } else {
              emit(state.copyWith(
                  status: GetStoreManagerProductsStockListStatus.failed,
                  webResponseFailed: WebResponseFailed(
                      statusMessage:
                          "Unable to process your request right now")));
            }
          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: GetStoreManagerProductsStockListStatus.failed,
                webResponseFailed: response));
          }
        } catch (e) {
          emit(state.copyWith(
              status: GetStoreManagerProductsStockListStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
