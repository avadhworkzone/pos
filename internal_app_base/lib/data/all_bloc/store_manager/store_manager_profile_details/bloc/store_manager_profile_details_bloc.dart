import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_profile_details/bloc/store_manager_profile_details_event.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_profile_details/bloc/store_manager_profile_details_state.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_profile_details/repo/store_manager_profile_details_repo.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_profile_details/repo/store_manager_profile_details_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';


class GetStoreManagerProfileDetailsBloc extends Bloc<
    GetStoreManagerProfileDetailsEvent,
    GetStoreManagerProfileDetailsState> {
  final GetStoreManagerProfileDetailsRepository repository =
      GetStoreManagerProfileDetailsRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  GetStoreManagerProfileDetailsBloc()
      : super( const GetStoreManagerProfileDetailsState()) {
    on<GetStoreManagerProfileDetailsClickEvent>(
      (event, emit) async {
        emit(state.copyWith(
            status: GetStoreManagerProfileDetailsStatus.loading));
        try {
          var response =
              await repository.fetchGetStoreManagerProfileDetails(event.mGetStoreManagerProfileDetailsRequest);

          if (response is GetStoreManagerProfileDetailsResponse) {

              emit(state.copyWith(
                status: GetStoreManagerProfileDetailsStatus.success,
                mGetStoreManagerProfileDetailsResponse: response,
              ));

          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: GetStoreManagerProfileDetailsStatus.failed,
                webResponseFailed: response));
          }
        } catch (e) {
          emit(state.copyWith(
              status: GetStoreManagerProfileDetailsStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
