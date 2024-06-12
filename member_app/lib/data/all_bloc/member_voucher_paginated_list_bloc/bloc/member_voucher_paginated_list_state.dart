import 'package:equatable/equatable.dart';
import 'package:member_app/data/all_bloc/member_voucher_paginated_list_bloc/repo/member_voucher_paginated_list_response.dart';
import 'package:member_app/data/remote/web_response_failed.dart';




enum MemberVoucherPaginatedListStatus { loading, success, failed }

class MemberVoucherPaginatedListState extends Equatable {
  const MemberVoucherPaginatedListState(
      {this.status = MemberVoucherPaginatedListStatus.loading,
        this.vouchersList = const <Vouchers>[],
        this.mMemberVoucherPaginatedListResponse,
        this.webResponseFailed,
      this.hasReachedMax= false});

  final MemberVoucherPaginatedListStatus status;
  final List<Vouchers> vouchersList;
  final MemberVoucherPaginatedListResponse? mMemberVoucherPaginatedListResponse;
  final WebResponseFailed? webResponseFailed;
  final bool hasReachedMax;


  MemberVoucherPaginatedListState copyWith({
    MemberVoucherPaginatedListStatus? status,
    List<Vouchers>? vouchersList,
    MemberVoucherPaginatedListResponse? mMemberVoucherPaginatedListResponse,
    WebResponseFailed? webResponseFailed,
    bool? hasReachedMax
  }) {
    return MemberVoucherPaginatedListState(
      status: status ?? this.status,
      vouchersList:
      vouchersList ?? this.vouchersList,
      mMemberVoucherPaginatedListResponse:
      mMemberVoucherPaginatedListResponse ?? this.mMemberVoucherPaginatedListResponse,
      webResponseFailed:  webResponseFailed ?? this.webResponseFailed,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, MemberVoucherPaginatedListResponse: $vouchersList }''';
  }

  @override
  List<Object> get props => [
    status,
    vouchersList,
    mMemberVoucherPaginatedListResponse??MemberVoucherPaginatedListResponse(),
    webResponseFailed ?? WebResponseFailed(),
    hasReachedMax
  ];
}
