import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_profile_update/bloc/store_manager_profile_update_event.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_profile_update/bloc/store_manager_profile_update_state.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_profile_update/repo/store_manager_profile_update_repo.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_profile_update/repo/store_manager_profile_update_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_service.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';

class PostStoreManagerProfileUpdateBloc extends Bloc<
    PostStoreManagerProfileUpdateEvent,
    PostStoreManagerProfileUpdateState> {
  final PostStoreManagerProfileUpdateRepository repository =
      PostStoreManagerProfileUpdateRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  PostStoreManagerProfileUpdateBloc()
      : super( const PostStoreManagerProfileUpdateState()) {
    on<PostStoreManagerProfileUpdateClickEvent>(
      (event, emit) async {
        emit(state.copyWith(
            status: PostStoreManagerProfileUpdateStatus.loading));
        try {
          var response =
              await repository.fetchPostStoreManagerProfileUpdate(event.mPostStoreManagerProfileUpdateListRequest);

          if (response is PostStoreManagerProfileUpdateResponse) {
              emit(state.copyWith(
                status: PostStoreManagerProfileUpdateStatus.success,
                mPostStoreManagerProfileUpdateResponse: response,

              ));

          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: PostStoreManagerProfileUpdateStatus.failed,
                webResponseFailed: response));
          }
        } catch (e) {
          emit(state.copyWith(
              status: PostStoreManagerProfileUpdateStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
