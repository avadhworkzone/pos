import 'package:equatable/equatable.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_products_stock_list/repo/get_promoter_products_stock_list_response.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';




enum GetPromoterProductsStockListStatus { loading, success, failed }

class GetPromoterProductsStockListState extends Equatable {
  const GetPromoterProductsStockListState(
      {this.status = GetPromoterProductsStockListStatus.loading,
        this.mStoreStock = const <StoreStock>[],
        this.mGetPromoterProductsStockListResponse,
        this.webResponseFailed,
      this.hasReachedMax= 0});

  final GetPromoterProductsStockListStatus status;
  final List<StoreStock> mStoreStock;
  final GetPromoterProductsStockListResponse? mGetPromoterProductsStockListResponse;
  final WebResponseFailed? webResponseFailed;
  final int hasReachedMax;


  GetPromoterProductsStockListState copyWith({
    GetPromoterProductsStockListStatus? status,
    List<StoreStock>? mStoreStock,
    GetPromoterProductsStockListResponse? mGetPromoterProductsStockListResponse,
    WebResponseFailed? webResponseFailed,
    int? hasReachedMax
  }) {
    return GetPromoterProductsStockListState(
      status: status ?? this.status,
      mStoreStock:
      mStoreStock ?? this.mStoreStock,
      mGetPromoterProductsStockListResponse:
      mGetPromoterProductsStockListResponse ?? this.mGetPromoterProductsStockListResponse,
      webResponseFailed: webResponseFailed ?? this.webResponseFailed,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, GetPromoterProductsStockListResponse: $mStoreStock }''';
  }

  @override
  List<Object> get props => [
    status,
    mStoreStock,
    mGetPromoterProductsStockListResponse??GetPromoterProductsStockListResponse(),
    webResponseFailed ?? WebResponseFailed(),
    hasReachedMax
  ];
}
