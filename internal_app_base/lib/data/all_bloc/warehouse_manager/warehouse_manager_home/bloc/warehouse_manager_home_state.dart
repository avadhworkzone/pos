import 'package:equatable/equatable.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_home/repo/warehouse_manager_home_response.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';

enum GetWarehouseManagerHomeStatus { loading, success, failed }

class GetWarehouseManagerHomeState extends Equatable {
  const GetWarehouseManagerHomeState(
      {this.status = GetWarehouseManagerHomeStatus.loading,
      this.mGetWarehouseManagerHomeResponse,
      this.webResponseFailed});

  final GetWarehouseManagerHomeStatus status;
  final GetWarehouseManagerHomeResponse? mGetWarehouseManagerHomeResponse;
  final WebResponseFailed? webResponseFailed;

  GetWarehouseManagerHomeState copyWith(
      {GetWarehouseManagerHomeStatus? status,
      GetWarehouseManagerHomeResponse? mGetWarehouseManagerHomeResponse,
      WebResponseFailed? webResponseFailed}) {
    return GetWarehouseManagerHomeState(
      status: status ?? this.status,
      mGetWarehouseManagerHomeResponse: mGetWarehouseManagerHomeResponse ??
          this.mGetWarehouseManagerHomeResponse,
      webResponseFailed: webResponseFailed ?? this.webResponseFailed,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, GetWarehouseManagerHomeResponse: $mGetWarehouseManagerHomeResponse }''';
  }

  @override
  List<Object> get props => [
        status,
        mGetWarehouseManagerHomeResponse ?? GetWarehouseManagerHomeResponse(),
        webResponseFailed ?? WebResponseFailed()
      ];
}
