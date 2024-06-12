import 'package:equatable/equatable.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_products_list/repo/warehouse_manager_products_list_response.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';

enum GetWarehouseManagerProductsListStatus { loading, success, failed }

class GetWarehouseManagerProductsListState extends Equatable {
  const GetWarehouseManagerProductsListState(
      {this.status = GetWarehouseManagerProductsListStatus.loading,
      this.mProductsList = const <Products>[],
      this.mGetWarehouseManagerProductsListResponse,
      this.webResponseFailed,
      this.hasReachedMax = 0});

  final GetWarehouseManagerProductsListStatus status;
  final List<Products> mProductsList;
  final GetWarehouseManagerProductsListResponse?
      mGetWarehouseManagerProductsListResponse;
  final WebResponseFailed? webResponseFailed;
  final int hasReachedMax;

  GetWarehouseManagerProductsListState copyWith(
      {GetWarehouseManagerProductsListStatus? status,
      List<Products>? mProductsList,
      GetWarehouseManagerProductsListResponse?
          mGetWarehouseManagerProductsListResponse,
      WebResponseFailed? webResponseFailed,
      int? hasReachedMax}) {
    return GetWarehouseManagerProductsListState(
      status: status ?? this.status,
      mProductsList: mProductsList ?? this.mProductsList,
      mGetWarehouseManagerProductsListResponse:
          mGetWarehouseManagerProductsListResponse ??
              this.mGetWarehouseManagerProductsListResponse,
      webResponseFailed: webResponseFailed ?? this.webResponseFailed,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, GetWarehouseManagerProductsListResponse: $mProductsList }''';
  }

  @override
  List<Object> get props => [
        status,
        mProductsList,
        mGetWarehouseManagerProductsListResponse ??
            GetWarehouseManagerProductsListResponse(),
        webResponseFailed ?? WebResponseFailed(),
        hasReachedMax
      ];
}
