import 'package:equatable/equatable.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_products_details/repo/warehouse_manager_products_details_response.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';

enum GetWarehouseManagerProductsDetailsStatus { loading, success, failed }

class GetWarehouseManagerProductsDetailsState extends Equatable {
  const GetWarehouseManagerProductsDetailsState(
      {this.status = GetWarehouseManagerProductsDetailsStatus.loading,
      this.mGetWarehouseManagerProductsDetailsResponse,
      this.webResponseFailed});

  final GetWarehouseManagerProductsDetailsStatus status;
  final GetWarehouseManagerProductsDetailsResponse?
      mGetWarehouseManagerProductsDetailsResponse;
  final WebResponseFailed? webResponseFailed;

  GetWarehouseManagerProductsDetailsState copyWith(
      {GetWarehouseManagerProductsDetailsStatus? status,
      GetWarehouseManagerProductsDetailsResponse?
          mGetWarehouseManagerProductsDetailsResponse,
      WebResponseFailed? webResponseFailed}) {
    return GetWarehouseManagerProductsDetailsState(
      status: status ?? this.status,
      mGetWarehouseManagerProductsDetailsResponse:
          mGetWarehouseManagerProductsDetailsResponse ??
              this.mGetWarehouseManagerProductsDetailsResponse,
      webResponseFailed: webResponseFailed ?? this.webResponseFailed,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, GetWarehouseManagerProductsDetailsResponse: $mGetWarehouseManagerProductsDetailsResponse }''';
  }

  @override
  List<Object> get props => [
        status,
        mGetWarehouseManagerProductsDetailsResponse ??
            GetWarehouseManagerProductsDetailsResponse(),
        webResponseFailed ?? WebResponseFailed()
      ];
}
