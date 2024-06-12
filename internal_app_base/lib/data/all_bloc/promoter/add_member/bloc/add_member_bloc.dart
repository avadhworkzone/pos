import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/add_member/bloc/add_member_event.dart';
import 'package:internal_base/data/all_bloc/promoter/add_member/bloc/add_member_state.dart';
import 'package:internal_base/data/all_bloc/promoter/add_member/repo/add_member_repo.dart';
import 'package:internal_base/data/all_bloc/promoter/add_member/repo/add_member_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_service.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';

class AddMemberBloc extends Bloc<AddMemberEvent, AddMemberState> {
  final AddMemberRepository repository =
      AddMemberRepository(sharedPrefs: SharedPrefs(), webservice: Webservice());

  AddMemberBloc() : super(const AddMemberState()) {
    on<AddMemberClickEvent>(
      (event, emit) async {
        emit(state.copyWith(status: AddMemberStatus.loading));
        try {
          var response =
              await repository.fetchAddMember(event.mAddMemberListRequest, event.mStoreID);

          if (response is AddMemberResponse) {
            emit(state.copyWith(
              status: AddMemberStatus.success,
              mAddMemberResponse: response,
            ));
          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: AddMemberStatus.failed, webResponseFailed: response));
          }
        } catch (e) {
          emit(state.copyWith(
              status: AddMemberStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
