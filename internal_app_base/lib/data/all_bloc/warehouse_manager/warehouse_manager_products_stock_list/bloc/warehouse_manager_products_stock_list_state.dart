import 'package:equatable/equatable.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_products_stock_list/repo/warehouse_manager_products_stock_list_response.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';

enum GetWarehouseManagerProductsStockListStatus { loading, success, failed }

class GetWarehouseManagerProductsStockListState extends Equatable {
  const GetWarehouseManagerProductsStockListState(
      {this.status = GetWarehouseManagerProductsStockListStatus.loading,
        this.mWarehouseStock = const <WarehouseStock>[],
        this.mGetWarehouseManagerProductsStockListResponse,
        this.webResponseFailed,
      this.hasReachedMax= 0});

  final GetWarehouseManagerProductsStockListStatus status;
  final List<WarehouseStock> mWarehouseStock;
  final GetWarehouseManagerProductsStockListResponse? mGetWarehouseManagerProductsStockListResponse;
  final WebResponseFailed? webResponseFailed;
  final int hasReachedMax;


  GetWarehouseManagerProductsStockListState copyWith({
    GetWarehouseManagerProductsStockListStatus? status,
    List<WarehouseStock>? mWarehouseStock,
    GetWarehouseManagerProductsStockListResponse? mGetWarehouseManagerProductsStockListResponse,
    WebResponseFailed? webResponseFailed,
    int? hasReachedMax
  }) {
    return GetWarehouseManagerProductsStockListState(
      status: status ?? this.status,
      mWarehouseStock:
      mWarehouseStock ?? this.mWarehouseStock,
      mGetWarehouseManagerProductsStockListResponse:
      mGetWarehouseManagerProductsStockListResponse ?? this.mGetWarehouseManagerProductsStockListResponse,
      webResponseFailed: webResponseFailed ?? this.webResponseFailed,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, GetWarehouseManagerProductsStockListResponse: $mWarehouseStock }''';
  }

  @override
  List<Object> get props => [
    status,
    mWarehouseStock,
    mGetWarehouseManagerProductsStockListResponse??GetWarehouseManagerProductsStockListResponse(),
    webResponseFailed ?? WebResponseFailed(),
    hasReachedMax
  ];
}
