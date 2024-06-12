import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:member_app/data/all_bloc/profile_pic_upload/bloc/profile_pic_update_event.dart';
import 'package:member_app/data/all_bloc/profile_pic_upload/bloc/profile_pic_update_state.dart';
import 'package:member_app/data/all_bloc/profile_pic_upload/repo/profile_pic_update_repo.dart';
import 'package:member_app/data/all_bloc/profile_pic_upload/repo/profile_pic_update_response.dart';
import 'package:member_app/data/local/shared_prefs/shared_prefs.dart';
import 'package:member_app/data/remote/web_response_failed.dart';
import 'package:member_app/data/remote/web_service.dart';


class ProfilePicUpdateBloc extends Bloc<
    ProfilePicUpdateEvent,
    ProfilePicUpdateState> {
  final ProfilePicUpdateRepository repository =
      ProfilePicUpdateRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  ProfilePicUpdateBloc()
      : super( const ProfilePicUpdateState()) {
    on<ProfilePicUpdateClickEvent>(
      (event, emit) async {
        emit(state.copyWith(
            status: ProfilePicUpdateStatus.loading));
        try {
          var response =
              await repository.fetchProfilePicUpdate(event.mProfilePicUpdateListRequest);

          if (response is ProfilePicUpdateResponse) {

              emit(state.copyWith(
                status: ProfilePicUpdateStatus.success,
                mProfilePicUpdateResponse: response,
              ));

          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: ProfilePicUpdateStatus.failed,
                webResponseFailed: WebResponseFailed(
                    statusMessage:
                        "Unable to process your request right now")));
          }
        } catch (e) {
          emit(state.copyWith(
              status: ProfilePicUpdateStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
