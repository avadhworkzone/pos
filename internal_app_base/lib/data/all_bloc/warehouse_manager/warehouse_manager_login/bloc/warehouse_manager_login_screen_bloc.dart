import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_login/bloc/warehouse_manager_login_screen_event.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_login/bloc/warehouse_manager_login_screen_state.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_login/repo/warehouse_manager_login_screen_repo.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_login/repo/warehouse_manager_login_screen_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';

class WarehouseManagerLoginScreenBloc extends Bloc<
    WarehouseManagerLoginScreenEvent, WarehouseManagerLoginScreenState> {
  final WarehouseManagerLoginScreenRepository repository =
      WarehouseManagerLoginScreenRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  WarehouseManagerLoginScreenBloc()
      : super(const WarehouseManagerLoginScreenState()) {
    on<WarehouseManagerLoginScreenClickEvent>(
      (event, emit) async {
        emit(state.copyWith(status: WarehouseManagerLoginScreenStatus.loading));
        try {
          var response = await repository.fetchWarehouseManagerLoginScreen(
              event.mWarehouseManagerLoginScreenListRequest);

          if (response is WarehouseManagerLoginScreenResponse) {
            emit(state.copyWith(
              status: WarehouseManagerLoginScreenStatus.success,
              mWarehouseManagerLoginScreenResponse: response,
            ));
          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: WarehouseManagerLoginScreenStatus.failed,
                webResponseFailed: response));
          }
        } catch (e) {
          emit(state.copyWith(
              status: WarehouseManagerLoginScreenStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
