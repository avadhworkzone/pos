import 'package:equatable/equatable.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_sales_returns_list/repo/GetPromoterSalesReturnsListResponse.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';

enum GetPromoterSalesReturnsListStatus { loading, success, failed }

class GetPromoterSalesReturnsListState extends Equatable {
  const GetPromoterSalesReturnsListState(
      {this.status = GetPromoterSalesReturnsListStatus.loading,
      this.mPromoterCommission = const <Sales>[],
      this.mGetPromoterSalesReturnsListResponse,
      this.webResponseFailed,
      this.hasReachedMax = 0});

  final GetPromoterSalesReturnsListStatus status;
  final List<Sales> mPromoterCommission;
  final GetPromoterSalesReturnsListResponse?
      mGetPromoterSalesReturnsListResponse;
  final WebResponseFailed? webResponseFailed;
  final int hasReachedMax;

  GetPromoterSalesReturnsListState copyWith(
      {GetPromoterSalesReturnsListStatus? status,
      List<Sales>? mPromoterCommission,
      GetPromoterSalesReturnsListResponse? mGetPromoterSalesReturnsListResponse,
      WebResponseFailed? webResponseFailed,
      int? hasReachedMax}) {
    return GetPromoterSalesReturnsListState(
      status: status ?? this.status,
      mPromoterCommission: mPromoterCommission ?? this.mPromoterCommission,
      mGetPromoterSalesReturnsListResponse:
          mGetPromoterSalesReturnsListResponse ??
              this.mGetPromoterSalesReturnsListResponse,
      webResponseFailed: webResponseFailed ?? this.webResponseFailed,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, GetPromoterSalesReturnsListResponse: $mPromoterCommission }''';
  }

  @override
  List<Object> get props => [
        status,
        mPromoterCommission,
        mGetPromoterSalesReturnsListResponse ??
            GetPromoterSalesReturnsListResponse(),
        webResponseFailed ?? WebResponseFailed(),
        hasReachedMax
      ];
}
