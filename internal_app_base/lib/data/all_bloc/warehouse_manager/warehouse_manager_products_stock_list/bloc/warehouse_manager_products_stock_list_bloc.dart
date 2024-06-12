import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_products_stock_list/bloc/warehouse_manager_products_stock_list_event.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_products_stock_list/bloc/warehouse_manager_products_stock_list_state.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_products_stock_list/repo/warehouse_manager_products_stock_list_repo.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_products_stock_list/repo/warehouse_manager_products_stock_list_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';

class GetWarehouseManagerProductsStockListBloc extends Bloc<
    GetWarehouseManagerProductsStockListEvent,
    GetWarehouseManagerProductsStockListState> {
  final GetWarehouseManagerProductsStockListRepository repository =
      GetWarehouseManagerProductsStockListRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  GetWarehouseManagerProductsStockListBloc()
      : super(const GetWarehouseManagerProductsStockListState()) {
    on<GetWarehouseManagerProductsStockListClickEvent>(
      (event, emit) async {
        try {
          if (event.eventStatus ==
              GetWarehouseManagerProductsStockListEventStatus.initial) {
            if (state.mWarehouseStock.isNotEmpty) {
              state.mWarehouseStock.clear();
            }
            emit(state.copyWith(
                status: GetWarehouseManagerProductsStockListStatus.loading));
          } else if (event.eventStatus ==
              GetWarehouseManagerProductsStockListEventStatus.refresh) {
            if (state.mWarehouseStock.isNotEmpty) {
              state.mWarehouseStock.clear();
            }
          } else {}
          var response =
              await repository.fetchGetWarehouseManagerProductsStockList(
                  event.mGetWarehouseManagerProductsStockListRequest,
                  event.mStringRequest);

          if (response is GetWarehouseManagerProductsStockListResponse) {
            if (response.warehouseStock != null) {
              if (response.warehouseStock!.isNotEmpty) {
                emit(state.copyWith(
                    mGetWarehouseManagerProductsStockListResponse: response,
                    status: GetWarehouseManagerProductsStockListStatus.success,
                    mWarehouseStock: List.of(state.mWarehouseStock)
                      ..addAll(
                        response.warehouseStock!,
                      ),
                    hasReachedMax: response.lastPage));
              } else {
                emit(state.copyWith(
                    status: GetWarehouseManagerProductsStockListStatus.success,
                    mGetWarehouseManagerProductsStockListResponse: response,
                    mWarehouseStock: state.mWarehouseStock,
                    hasReachedMax: response.lastPage));
              }
            } else {
              emit(state.copyWith(
                  status: GetWarehouseManagerProductsStockListStatus.failed,
                  webResponseFailed: WebResponseFailed(
                      statusMessage:
                          "Unable to process your request right now")));
            }
          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: GetWarehouseManagerProductsStockListStatus.failed,
                webResponseFailed: response));
          }
        } catch (e) {
          emit(state.copyWith(
              status: GetWarehouseManagerProductsStockListStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
