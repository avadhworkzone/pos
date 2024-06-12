import 'package:equatable/equatable.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_commission_list/repo/get_promoter_commission_list_response.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';

enum GetPromoterCommissionListStatus { loading, success, failed }

class GetPromoterCommissionListState extends Equatable {
  const GetPromoterCommissionListState(
      {this.status = GetPromoterCommissionListStatus.loading,
      this.mCommissionList = const <CommissionHistory>[],
      this.mGetPromoterCommissionListResponse,
      this.webResponseFailed,
      this.hasReachedMax = 0});

  final GetPromoterCommissionListStatus status;
  final List<CommissionHistory> mCommissionList;
  final GetPromoterCommissionListResponse? mGetPromoterCommissionListResponse;
  final WebResponseFailed? webResponseFailed;
  final int hasReachedMax;

  GetPromoterCommissionListState copyWith(
      {GetPromoterCommissionListStatus? status,
      List<CommissionHistory>? mCommissionList,
      GetPromoterCommissionListResponse? mGetPromoterCommissionListResponse,
      WebResponseFailed? webResponseFailed,
      int? hasReachedMax}) {
    return GetPromoterCommissionListState(
      status: status ?? this.status,
      mCommissionList: mCommissionList ?? this.mCommissionList,
      mGetPromoterCommissionListResponse: mGetPromoterCommissionListResponse ??
          this.mGetPromoterCommissionListResponse,
      webResponseFailed: webResponseFailed ?? this.webResponseFailed,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, GetPromoterCommissionListResponse: $mCommissionList }''';
  }

  @override
  List<Object> get props => [
        status,
        mCommissionList,
        mGetPromoterCommissionListResponse ??
            GetPromoterCommissionListResponse(),
        webResponseFailed ?? WebResponseFailed(),
        hasReachedMax
      ];
}
