import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_home/bloc/warehouse_manager_home_event.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_home/bloc/warehouse_manager_home_state.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_home/repo/warehouse_manager_home_repo.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_home/repo/warehouse_manager_home_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';

class GetWarehouseManagerHomeBloc
    extends Bloc<GetWarehouseManagerHomeEvent, GetWarehouseManagerHomeState> {
  final GetWarehouseManagerHomeRepository repository =
      GetWarehouseManagerHomeRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  GetWarehouseManagerHomeBloc() : super(const GetWarehouseManagerHomeState()) {
    on<GetWarehouseManagerHomeClickEvent>(
      (event, emit) async {
        emit(state.copyWith(status: GetWarehouseManagerHomeStatus.loading));
        try {
          var response = await repository.fetchGetWarehouseManagerHome(
              event.mGetWarehouseManagerHomeRequest);

          if (response is GetWarehouseManagerHomeResponse) {
            emit(state.copyWith(
              status: GetWarehouseManagerHomeStatus.success,
              mGetWarehouseManagerHomeResponse: response,
            ));
          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: GetWarehouseManagerHomeStatus.failed,
                webResponseFailed: response));
          }
        } catch (e) {
          emit(state.copyWith(
              status: GetWarehouseManagerHomeStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
