import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_products_details/bloc/warehouse_manager_products_details_event.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_products_details/bloc/warehouse_manager_products_details_state.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_products_details/repo/warehouse_manager_products_details_repo.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_products_details/repo/warehouse_manager_products_details_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';

class GetWarehouseManagerProductsDetailsBloc extends Bloc<
    GetWarehouseManagerProductsDetailsEvent,
    GetWarehouseManagerProductsDetailsState> {
  final GetWarehouseManagerProductsDetailsRepository repository =
      GetWarehouseManagerProductsDetailsRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  GetWarehouseManagerProductsDetailsBloc()
      : super(const GetWarehouseManagerProductsDetailsState()) {
    on<GetWarehouseManagerProductsDetailsClickEvent>(
      (event, emit) async {
        emit(state.copyWith(
            status: GetWarehouseManagerProductsDetailsStatus.loading));
        try {
          var response =
              await repository.fetchGetWarehouseManagerProductsDetails(
                  event.mGetWarehouseManagerProductsDetailsRequest);

          if (response is GetWarehouseManagerProductsDetailsResponse) {
            emit(state.copyWith(
              status: GetWarehouseManagerProductsDetailsStatus.success,
              mGetWarehouseManagerProductsDetailsResponse: response,
            ));
          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: GetWarehouseManagerProductsDetailsStatus.failed,
                webResponseFailed: response));
          }
        } catch (e) {
          emit(state.copyWith(
              status: GetWarehouseManagerProductsDetailsStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
