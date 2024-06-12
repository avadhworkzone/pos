import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_profile_details/bloc/warehouse_manager_profile_details_event.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_profile_details/bloc/warehouse_manager_profile_details_state.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_profile_details/repo/warehouse_manager_profile_details_repo.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_profile_details/repo/warehouse_manager_profile_details_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';

class GetWarehouseManagerProfileDetailsBloc extends Bloc<
    GetWarehouseManagerProfileDetailsEvent,
    GetWarehouseManagerProfileDetailsState> {
  final GetWarehouseManagerProfileDetailsRepository repository =
      GetWarehouseManagerProfileDetailsRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  GetWarehouseManagerProfileDetailsBloc()
      : super(const GetWarehouseManagerProfileDetailsState()) {
    on<GetWarehouseManagerProfileDetailsClickEvent>(
      (event, emit) async {
        emit(state.copyWith(
            status: GetWarehouseManagerProfileDetailsStatus.loading));
        try {
          var response =
              await repository.fetchGetWarehouseManagerProfileDetails(
                  event.mGetWarehouseManagerProfileDetailsRequest);

          if (response is GetWarehouseManagerProfileDetailsResponse) {
            emit(state.copyWith(
              status: GetWarehouseManagerProfileDetailsStatus.success,
              mGetWarehouseManagerProfileDetailsResponse: response,
            ));
          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: GetWarehouseManagerProfileDetailsStatus.failed,
                webResponseFailed: response));
          }
        } catch (e) {
          emit(state.copyWith(
              status: GetWarehouseManagerProfileDetailsStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
