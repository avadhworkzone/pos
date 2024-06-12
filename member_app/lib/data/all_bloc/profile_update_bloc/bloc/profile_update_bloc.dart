import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:member_app/data/all_bloc/profile_update_bloc/bloc/profile_update_event.dart';
import 'package:member_app/data/all_bloc/profile_update_bloc/bloc/profile_update_state.dart';
import 'package:member_app/data/all_bloc/profile_update_bloc/repo/profile_update_repo.dart';
import 'package:member_app/data/all_bloc/profile_update_bloc/repo/profile_update_response.dart';
import 'package:member_app/data/local/shared_prefs/shared_prefs.dart';
import 'package:member_app/data/remote/web_response_failed.dart';
import 'package:member_app/data/remote/web_service.dart';


class ProfileUpdateBloc extends Bloc<
    ProfileUpdateEvent,
    ProfileUpdateState> {
  final ProfileUpdateRepository repository =
      ProfileUpdateRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  ProfileUpdateBloc()
      : super( const ProfileUpdateState()) {
    on<ProfileUpdateClickEvent>(
      (event, emit) async {
        emit(state.copyWith(
            status: ProfileUpdateStatus.loading));
        try {
          var response =
              await repository.fetchProfileUpdate(event.mProfileUpdateListRequest);

          if (response is ProfileUpdateResponse) {

              emit(state.copyWith(
                status: ProfileUpdateStatus.success,
                mProfileUpdateResponse: response,
              ));

          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: ProfileUpdateStatus.failed,
                webResponseFailed: WebResponseFailed(
                    statusMessage:
                        "Unable to process your request right now")));
          }
        } catch (e) {
          emit(state.copyWith(
              status: ProfileUpdateStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
