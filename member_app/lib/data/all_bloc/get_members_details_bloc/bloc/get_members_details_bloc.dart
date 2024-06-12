import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:member_app/data/all_bloc/get_members_bloc/bloc/get_members_event.dart';
import 'package:member_app/data/all_bloc/get_members_bloc/bloc/get_members_state.dart';
import 'package:member_app/data/all_bloc/get_members_bloc/repo/get_members_repo.dart';
import 'package:member_app/data/all_bloc/get_members_bloc/repo/get_members_response.dart';
import 'package:member_app/data/all_bloc/get_members_details_bloc/bloc/get_members_details_event.dart';
import 'package:member_app/data/all_bloc/get_members_details_bloc/bloc/get_members_details_state.dart';
import 'package:member_app/data/all_bloc/get_members_details_bloc/repo/get_members_details_repo.dart';
import 'package:member_app/data/all_bloc/get_members_details_bloc/repo/get_members_details_response.dart';
import 'package:member_app/data/local/shared_prefs/shared_prefs.dart';
import 'package:member_app/data/remote/web_response_failed.dart';
import 'package:member_app/data/remote/web_service.dart';


class GetMemberDetailsBloc extends Bloc<
    GetMemberDetailsEvent,
    GetMemberDetailsState> {
  final GetMemberDetailsRepository repository =
      GetMemberDetailsRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  GetMemberDetailsBloc()
      : super( const GetMemberDetailsState()) {
    on<GetMemberDetailsClickEvent>(
      (event, emit) async {
        emit(state.copyWith(
            status: GetMemberDetailsStatus.loading));
        try {
          var response =
              await repository.fetchGetMemberDetails();
          if (response is GetMemberDetailsResponse) {

              emit(state.copyWith(
                status: GetMemberDetailsStatus.success,
                mGetMemberDetailsResponse: response!,
              ));

          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: GetMemberDetailsStatus.failed,
                webResponseFailed: WebResponseFailed(
                    statusMessage: response.statusMessage??
                        "Unable to process your request right now")));
          }
        } catch (e) {
          emit(state.copyWith(
              status: GetMemberDetailsStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
