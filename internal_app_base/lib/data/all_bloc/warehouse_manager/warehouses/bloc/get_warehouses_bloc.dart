import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouses/bloc/get_warehouses_event.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouses/bloc/get_warehouses_state.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouses/repo/get_warehouses_repo.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouses/repo/get_warehouses_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';

class GetWarehousesBloc extends Bloc<GetWarehousesEvent, GetWarehousesState> {
  final GetWarehousesRepository repository = GetWarehousesRepository(
      sharedPrefs: SharedPrefs(), webservice: Webservice());

  GetWarehousesBloc() : super(const GetWarehousesState()) {
    on<GetWarehousesClickEvent>(
      (event, emit) async {
        emit(state.copyWith(status: GetWarehousesStatus.loading));
        try {
          var response = await repository.fetchGetWarehouses();

          if (response is GetWarehousesResponse) {
            emit(state.copyWith(
              status: GetWarehousesStatus.success,
              mGetWarehousesResponse: response!,
            ));
          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: GetWarehousesStatus.failed,
                webResponseFailed: response));
          }
        } catch (e) {
          emit(state.copyWith(
              status: GetWarehousesStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
