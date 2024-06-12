import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_products_stock_list/bloc/get_promoter_products_stock_list_event.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_products_stock_list/bloc/get_promoter_products_stock_list_state.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_products_stock_list/repo/get_promoter_products_stock_list_repo.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_products_stock_list/repo/get_promoter_products_stock_list_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';

class GetPromoterProductsStockListBloc extends Bloc<
    GetPromoterProductsStockListEvent, GetPromoterProductsStockListState> {
  final GetPromoterProductsStockListRepository repository =
      GetPromoterProductsStockListRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  GetPromoterProductsStockListBloc()
      : super(const GetPromoterProductsStockListState()) {
    on<GetPromoterProductsStockListClickEvent>(
      (event, emit) async {
        try {
          if (event.eventStatus ==
              GetPromoterProductsStockListEventStatus.initial) {
            if (state.mStoreStock.isNotEmpty) {
              state.mStoreStock.clear();
            }
            emit(state.copyWith(
                status: GetPromoterProductsStockListStatus.loading));
          } else if (event.eventStatus ==
              GetPromoterProductsStockListEventStatus.refresh) {
            if (state.mStoreStock.isNotEmpty) {
              state.mStoreStock.clear();
            }
          }else{
          }
          var response = await repository.fetchGetPromoterProductsStockList(
              event.mGetPromoterProductsStockListRequest,event.mStringRequest);

          if (response is GetPromoterProductsStockListResponse) {
            if (response.storeStock != null ) {
              if (response.storeStock!.isNotEmpty) {
                emit(state.copyWith(
                  mGetPromoterProductsStockListResponse: response,
                    status: GetPromoterProductsStockListStatus.success,
                    mStoreStock: List.of(state.mStoreStock)
                      ..addAll(
                        response.storeStock!,
                      ),
                    hasReachedMax: response.lastPage));
              } else {
                emit(state.copyWith(
                    status: GetPromoterProductsStockListStatus.success,
                    mGetPromoterProductsStockListResponse: response,
                    mStoreStock: state.mStoreStock,
                    hasReachedMax: response.lastPage));
              }
            } else {
              emit(state.copyWith(
                  status: GetPromoterProductsStockListStatus.failed,
                  webResponseFailed: WebResponseFailed(
                      statusMessage:
                          "Unable to process your request right now")));
            }
          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: GetPromoterProductsStockListStatus.failed,
                webResponseFailed: response));
          }
        } catch (e) {
          emit(state.copyWith(
              status: GetPromoterProductsStockListStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
