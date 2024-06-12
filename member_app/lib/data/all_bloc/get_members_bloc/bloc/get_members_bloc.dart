import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:member_app/data/all_bloc/get_members_bloc/bloc/get_members_event.dart';
import 'package:member_app/data/all_bloc/get_members_bloc/bloc/get_members_state.dart';
import 'package:member_app/data/all_bloc/get_members_bloc/repo/get_members_repo.dart';
import 'package:member_app/data/all_bloc/get_members_bloc/repo/get_members_response.dart';
import 'package:member_app/data/local/shared_prefs/shared_prefs.dart';
import 'package:member_app/data/remote/web_response_failed.dart';
import 'package:member_app/data/remote/web_service.dart';


class GetMemberBloc extends Bloc<
    GetMemberEvent,
    GetMemberState> {
  final GetMemberRepository repository =
      GetMemberRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  GetMemberBloc()
      : super( const GetMemberState()) {
    on<GetMemberClickEvent>(
      (event, emit) async {
        emit(state.copyWith(
            status: GetMemberStatus.loading));
        try {
          var response =
              await repository.fetchGetMember();

          if (response is GetMemberResponse) {

              emit(state.copyWith(
                status: GetMemberStatus.success,
                mGetMemberResponse: response!,
              ));

          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: GetMemberStatus.failed,
                webResponseFailed: WebResponseFailed(
                    statusMessage:
                        "Unable to process your request right now")));
          }
        } catch (e) {
          emit(state.copyWith(
              status: GetMemberStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
