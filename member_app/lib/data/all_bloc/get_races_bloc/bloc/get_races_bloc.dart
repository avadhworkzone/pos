import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:member_app/data/all_bloc/get_races_bloc/bloc/get_races_event.dart';
import 'package:member_app/data/all_bloc/get_races_bloc/bloc/get_races_state.dart';
import 'package:member_app/data/all_bloc/get_races_bloc/repo/get_races_repo.dart';
import 'package:member_app/data/all_bloc/get_races_bloc/repo/get_races_response.dart';
import 'package:member_app/data/local/shared_prefs/shared_prefs.dart';
import 'package:member_app/data/remote/web_response_failed.dart';
import 'package:member_app/data/remote/web_service.dart';


class GetRacesBloc extends Bloc<
    GetRacesEvent,
    GetRacesState> {
  final GetRacesRepository repository =
      GetRacesRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  GetRacesBloc()
      : super( const GetRacesState()) {
    on<GetRacesClickEvent>(
      (event, emit) async {
        emit(state.copyWith(
            status: GetRacesStatus.loading));
        try {
          var response =
              await repository.fetchGetRaces();

          if (response is GetRacesResponse) {

              emit(state.copyWith(
                status: GetRacesStatus.success,
                mGetRacesResponse: response,
              ));

          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: GetRacesStatus.failed,
                webResponseFailed: WebResponseFailed(
                    statusMessage:
                        "Unable to process your request right now")));
          }
        } catch (e) {
          emit(state.copyWith(
              status: GetRacesStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
