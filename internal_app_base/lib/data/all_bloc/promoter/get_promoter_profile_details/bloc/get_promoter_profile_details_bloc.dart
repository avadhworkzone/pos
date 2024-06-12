import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_profile_details/bloc/get_promoter_profile_details_event.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_profile_details/bloc/get_promoter_profile_details_state.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_profile_details/repo/get_promoter_profile_details_repo.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_profile_details/repo/get_promoter_profile_details_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';


class GetPromoteProfileDetailsBloc extends Bloc<
    GetPromoteProfileDetailsEvent,
    GetPromoteProfileDetailsState> {
  final GetPromoteProfileDetailsRepository repository =
      GetPromoteProfileDetailsRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  GetPromoteProfileDetailsBloc()
      : super( const GetPromoteProfileDetailsState()) {
    on<GetPromoteProfileDetailsClickEvent>(
      (event, emit) async {
        emit(state.copyWith(
            status: GetPromoteProfileDetailsStatus.loading));
        try {
          var response =
              await repository.fetchGetPromoteProfileDetails(event.mGetPromoteProfileDetailsRequest);

          if (response is GetPromoteProfileDetailsResponse) {

              emit(state.copyWith(
                status: GetPromoteProfileDetailsStatus.success,
                mGetPromoteProfileDetailsResponse: response,
              ));

          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: GetPromoteProfileDetailsStatus.failed,
                webResponseFailed: response));
          }
        } catch (e) {
          emit(state.copyWith(
              status: GetPromoteProfileDetailsStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
