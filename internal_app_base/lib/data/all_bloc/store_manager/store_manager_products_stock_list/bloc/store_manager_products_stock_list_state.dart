import 'package:equatable/equatable.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_products_stock_list/repo/store_manager_products_stock_list_response.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';

enum GetStoreManagerProductsStockListStatus { loading, success, failed }

class GetStoreManagerProductsStockListState extends Equatable {
  const GetStoreManagerProductsStockListState(
      {this.status = GetStoreManagerProductsStockListStatus.loading,
        this.mStoreStock = const <StoreStock>[],
        this.mGetStoreManagerProductsStockListResponse,
        this.webResponseFailed,
      this.hasReachedMax= 0});

  final GetStoreManagerProductsStockListStatus status;
  final List<StoreStock> mStoreStock;
  final GetStoreManagerProductsStockListResponse? mGetStoreManagerProductsStockListResponse;
  final WebResponseFailed? webResponseFailed;
  final int hasReachedMax;


  GetStoreManagerProductsStockListState copyWith({
    GetStoreManagerProductsStockListStatus? status,
    List<StoreStock>? mStoreStock,
    GetStoreManagerProductsStockListResponse? mGetStoreManagerProductsStockListResponse,
    WebResponseFailed? webResponseFailed,
    int? hasReachedMax
  }) {
    return GetStoreManagerProductsStockListState(
      status: status ?? this.status,
      mStoreStock:
      mStoreStock ?? this.mStoreStock,
      mGetStoreManagerProductsStockListResponse:
      mGetStoreManagerProductsStockListResponse ?? this.mGetStoreManagerProductsStockListResponse,
      webResponseFailed: webResponseFailed ?? this.webResponseFailed,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, GetStoreManagerProductsStockListResponse: $mStoreStock }''';
  }

  @override
  List<Object> get props => [
    status,
    mStoreStock,
    mGetStoreManagerProductsStockListResponse??GetStoreManagerProductsStockListResponse(),
    webResponseFailed ?? WebResponseFailed(),
    hasReachedMax
  ];
}
