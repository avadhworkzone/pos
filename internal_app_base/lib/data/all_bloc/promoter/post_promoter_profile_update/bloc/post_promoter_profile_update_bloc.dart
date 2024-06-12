import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/post_promoter_profile_update/bloc/post_promoter_profile_update_event.dart';
import 'package:internal_base/data/all_bloc/promoter/post_promoter_profile_update/bloc/post_promoter_profile_update_state.dart';
import 'package:internal_base/data/all_bloc/promoter/post_promoter_profile_update/repo/post_promoter_profile_update_repo.dart';
import 'package:internal_base/data/all_bloc/promoter/post_promoter_profile_update/repo/post_promoter_profile_update_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_response_error_message.dart';
import 'package:internal_base/data/remote/web_service.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';



class PostPromoterProfileUpdateBloc extends Bloc<
    PostPromoterProfileUpdateEvent,
    PostPromoterProfileUpdateState> {
  final PostPromoterProfileUpdateRepository repository =
      PostPromoterProfileUpdateRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  PostPromoterProfileUpdateBloc()
      : super( const PostPromoterProfileUpdateState()) {
    on<PostPromoterProfileUpdateClickEvent>(
      (event, emit) async {
        emit(state.copyWith(
            status: PostPromoterProfileUpdateStatus.loading));
        try {
          var response =
              await repository.fetchPostPromoterProfileUpdate(event.mPostPromoterProfileUpdateListRequest);

          if (response is PostPromoterProfileUpdateResponse) {
              emit(state.copyWith(
                status: PostPromoterProfileUpdateStatus.success,
                mPostPromoterProfileUpdateResponse: response,

              ));

          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: PostPromoterProfileUpdateStatus.failed,
                webResponseFailed: response));
          }
        } catch (e) {
          emit(state.copyWith(
              status: PostPromoterProfileUpdateStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
