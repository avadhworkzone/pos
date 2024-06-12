import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:member_app/data/all_bloc/profile_delete_bloc/bloc/profile_delete_event.dart';
import 'package:member_app/data/all_bloc/profile_delete_bloc/bloc/profile_delete_state.dart';
import 'package:member_app/data/all_bloc/profile_delete_bloc/repo/profile_delete_repo.dart';
import 'package:member_app/data/all_bloc/profile_delete_bloc/repo/profile_delete_response.dart';
import 'package:member_app/data/all_bloc/profile_update_bloc/bloc/profile_update_event.dart';
import 'package:member_app/data/all_bloc/profile_update_bloc/bloc/profile_update_state.dart';
import 'package:member_app/data/all_bloc/profile_update_bloc/repo/profile_update_repo.dart';
import 'package:member_app/data/all_bloc/profile_update_bloc/repo/profile_update_response.dart';
import 'package:member_app/data/local/shared_prefs/shared_prefs.dart';
import 'package:member_app/data/remote/web_response_failed.dart';
import 'package:member_app/data/remote/web_service.dart';


class ProfileDeleteBloc extends Bloc<
    ProfileDeleteEvent,
    ProfileDeleteState> {
  final ProfileDeleteRepository repository =
      ProfileDeleteRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  ProfileDeleteBloc()
      : super( const ProfileDeleteState()) {
    on<ProfileDeleteClickEvent>(
      (event, emit) async {
        emit(state.copyWith(
            status: ProfileDeleteStatus.loading));
        try {
          var response =
              await repository.fetchProfileDelete(event.mProfileDeleteListRequest);

          if (response is ProfileDeleteResponse) {

              emit(state.copyWith(
                status: ProfileDeleteStatus.success,
                mProfileDeleteResponse: response,
              ));

          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: ProfileDeleteStatus.failed,
                webResponseFailed: WebResponseFailed(
                    statusMessage:
                        "Unable to process your request right now")));
          }
        } catch (e) {
          emit(state.copyWith(
              status: ProfileDeleteStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
