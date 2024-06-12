import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_products_list/bloc/warehouse_manager_products_list_event.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_products_list/bloc/warehouse_manager_products_list_state.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_products_list/repo/warehouse_manager_products_list_repo.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_products_list/repo/warehouse_manager_products_list_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';

class GetWarehouseManagerProductsListBloc extends Bloc<
    GetWarehouseManagerProductsListEvent,
    GetWarehouseManagerProductsListState> {
  final GetWarehouseManagerProductsListRepository repository =
      GetWarehouseManagerProductsListRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  GetWarehouseManagerProductsListBloc()
      : super(const GetWarehouseManagerProductsListState()) {
    on<GetWarehouseManagerProductsListClickEvent>(
      (event, emit) async {
        try {
          if (event.eventStatus ==
              GetWarehouseManagerProductsListEventStatus.initial) {
            if (state.mProductsList.isNotEmpty) {
              state.mProductsList.clear();
            }
            emit(state.copyWith(
                status: GetWarehouseManagerProductsListStatus.loading));
          } else if (event.eventStatus ==
              GetWarehouseManagerProductsListEventStatus.refresh) {
            if (state.mProductsList.isNotEmpty) {
              state.mProductsList.clear();
            }
          } else {}
          var response = await repository.fetchGetWarehouseManagerProductsList(
              event.mGetWarehouseManagerProductsListRequest);

          if (response is GetWarehouseManagerProductsListResponse) {
            if (response.products != null) {
              if (response.products!.isNotEmpty) {
                emit(state.copyWith(
                    mGetWarehouseManagerProductsListResponse: response,
                    status: GetWarehouseManagerProductsListStatus.success,
                    mProductsList: List.of(state.mProductsList)
                      ..addAll(
                        response.products!,
                      ),
                    hasReachedMax: response.lastPage));
              } else {
                emit(state.copyWith(
                    status: GetWarehouseManagerProductsListStatus.success,
                    mGetWarehouseManagerProductsListResponse: response,
                    mProductsList: state.mProductsList,
                    hasReachedMax: response.lastPage));
              }
            } else {
              emit(state.copyWith(
                  status: GetWarehouseManagerProductsListStatus.failed,
                  webResponseFailed: WebResponseFailed(
                      statusMessage:
                          "Unable to process your request right now")));
            }
          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: GetWarehouseManagerProductsListStatus.failed,
                webResponseFailed: response));
          }
        } catch (e) {
          emit(state.copyWith(
              status: GetWarehouseManagerProductsListStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
