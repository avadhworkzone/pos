import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:member_app/data/all_bloc/get_titles_bloc/bloc/get_titles_event.dart';
import 'package:member_app/data/all_bloc/get_titles_bloc/bloc/get_titles_state.dart';
import 'package:member_app/data/all_bloc/get_titles_bloc/repo/get_titles_repo.dart';
import 'package:member_app/data/all_bloc/get_titles_bloc/repo/get_titles_response.dart';
import 'package:member_app/data/local/shared_prefs/shared_prefs.dart';
import 'package:member_app/data/remote/web_response_failed.dart';
import 'package:member_app/data/remote/web_service.dart';


class GetTitlesBloc extends Bloc<
    GetTitlesEvent,
    GetTitlesState> {
  final GetTitlesRepository repository =
      GetTitlesRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  GetTitlesBloc()
      : super( const GetTitlesState()) {
    on<GetTitlesClickEvent>(
      (event, emit) async {
        emit(state.copyWith(
            status: GetTitlesStatus.loading));
        try {
          var response =
              await repository.fetchGetTitles();

          if (response is GetTitlesResponse) {

              emit(state.copyWith(
                status: GetTitlesStatus.success,
                mGetTitlesResponse: response,
              ));

          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: GetTitlesStatus.failed,
                webResponseFailed: WebResponseFailed(
                    statusMessage:
                        "Unable to process your request right now")));
          }
        } catch (e) {
          emit(state.copyWith(
              status: GetTitlesStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
