import 'package:equatable/equatable.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_promoter_list/repo/store_manager_promoter_list_response.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';

enum GetStoreManagerPromoterListStatus { loading, success, failed }

class GetStoreManagerPromoterListState extends Equatable {
  const GetStoreManagerPromoterListState(
      {this.status = GetStoreManagerPromoterListStatus.loading,
      this.mPromoterListData = const <Promoters>[],
      this.mGetStoreManagerPromoterListResponse,
      this.webResponseFailed,
      this.hasReachedMax = 0});

  final GetStoreManagerPromoterListStatus status;
  final List<Promoters> mPromoterListData;
  final GetStoreManagerPromoterListResponse?
      mGetStoreManagerPromoterListResponse;
  final WebResponseFailed? webResponseFailed;
  final int hasReachedMax;

  GetStoreManagerPromoterListState copyWith(
      {GetStoreManagerPromoterListStatus? status,
      List<Promoters>? mPromoterListData,
      GetStoreManagerPromoterListResponse? mGetStoreManagerPromoterListResponse,
      WebResponseFailed? webResponseFailed,
      int? hasReachedMax}) {
    return GetStoreManagerPromoterListState(
      status: status ?? this.status,
      mPromoterListData: mPromoterListData ?? this.mPromoterListData,
      mGetStoreManagerPromoterListResponse:
          mGetStoreManagerPromoterListResponse ??
              this.mGetStoreManagerPromoterListResponse,
      webResponseFailed: webResponseFailed ?? this.webResponseFailed,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, GetStoreManagerPromoterListStatus: $mPromoterListData }''';
  }

  @override
  List<Object> get props => [
        status,
        mPromoterListData,
        mGetStoreManagerPromoterListResponse ??
            GetStoreManagerPromoterListResponse(),
        webResponseFailed ?? WebResponseFailed(),
        hasReachedMax
      ];
}
