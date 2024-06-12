import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:member_app/data/all_bloc/get_genders_bloc/bloc/get_genders_event.dart';
import 'package:member_app/data/all_bloc/get_genders_bloc/bloc/get_genders_state.dart';
import 'package:member_app/data/all_bloc/get_genders_bloc/repo/get_genders_repo.dart';
import 'package:member_app/data/all_bloc/get_genders_bloc/repo/get_genders_response.dart';
import 'package:member_app/data/local/shared_prefs/shared_prefs.dart';
import 'package:member_app/data/remote/web_response_failed.dart';
import 'package:member_app/data/remote/web_service.dart';

class GetGendersBloc extends Bloc<GetGendersEvent, GetGendersState> {
  final GetGendersRepository repository = GetGendersRepository(
      sharedPrefs: SharedPrefs(), webservice: Webservice());

  GetGendersBloc() : super(const GetGendersState()) {
    on<GetGendersClickEvent>(
      (event, emit) async {
        emit(state.copyWith(status: GetGendersStatus.loading));
        try {
          var response = await repository.fetchGetGenders();

          if (response is GetGendersResponse) {
            emit(state.copyWith(
              status: GetGendersStatus.success,
              mGetGendersResponse: response,
            ));
          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: GetGendersStatus.failed,
                webResponseFailed: WebResponseFailed(
                    statusMessage:
                        "Unable to process your request right now")));
          }
        } catch (e) {
          emit(state.copyWith(
              status: GetGendersStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
