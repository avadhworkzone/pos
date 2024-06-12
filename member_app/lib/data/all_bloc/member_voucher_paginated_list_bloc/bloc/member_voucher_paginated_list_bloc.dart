import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:member_app/data/all_bloc/member_voucher_paginated_list_bloc/bloc/member_voucher_paginated_list_event.dart';
import 'package:member_app/data/all_bloc/member_voucher_paginated_list_bloc/bloc/member_voucher_paginated_list_state.dart';
import 'package:member_app/data/all_bloc/member_voucher_paginated_list_bloc/repo/member_voucher_paginated_list_repo.dart';
import 'package:member_app/data/all_bloc/member_voucher_paginated_list_bloc/repo/member_voucher_paginated_list_response.dart';
import 'package:member_app/data/local/shared_prefs/shared_prefs.dart';
import 'package:member_app/data/remote/web_response_failed.dart';
import 'package:member_app/data/remote/web_service.dart';

class MemberVoucherPaginatedListBloc extends Bloc<
    MemberVoucherPaginatedListEvent, MemberVoucherPaginatedListState> {
  final MemberVoucherPaginatedListRepository repository =
      MemberVoucherPaginatedListRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  MemberVoucherPaginatedListBloc()
      : super(const MemberVoucherPaginatedListState()) {
    on<MemberVoucherPaginatedListClickEvent>(
      (event, emit) async {
        try {
          if (event.eventStatus ==
              MemberVoucherPaginatedListEventStatus.initial) {
            if (state.vouchersList.isNotEmpty) {
              state.vouchersList.clear();
            }
            emit(state.copyWith(
                status: MemberVoucherPaginatedListStatus.loading));
          } else if (event.eventStatus ==
              MemberVoucherPaginatedListEventStatus.refresh) {
            if (state.vouchersList.isNotEmpty) {
              state.vouchersList.clear();
            }
          }else{
          }
          var response = await repository.fetchMemberVoucherPaginatedList(
              event.mMemberVoucherPaginatedListRequest);

          if (response is MemberVoucherPaginatedListResponse) {
            if (response.vouchers != null ) {
              if (response.vouchers!.isNotEmpty) {
                emit(state.copyWith(
                  mMemberVoucherPaginatedListResponse: response,
                    status: MemberVoucherPaginatedListStatus.success,
                    vouchersList: List.of(state.vouchersList)
                      ..addAll(
                        response.vouchers!,
                      ),
                    hasReachedMax: response.vouchers!.length==10));
              } else {
                emit(state.copyWith(
                    status: MemberVoucherPaginatedListStatus.success,
                    mMemberVoucherPaginatedListResponse: response,
                    vouchersList: state.vouchersList,
                    hasReachedMax: false));
              }
            } else {
              emit(state.copyWith(
                  status: MemberVoucherPaginatedListStatus.failed,
                  webResponseFailed: WebResponseFailed(
                      statusMessage:
                          "Unable to process your request right now")));
            }
          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: MemberVoucherPaginatedListStatus.failed,
                webResponseFailed: WebResponseFailed(
                    statusMessage:
                        "Unable to process your request right now")));
          }
        } catch (e) {
          emit(state.copyWith(
              status: MemberVoucherPaginatedListStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
