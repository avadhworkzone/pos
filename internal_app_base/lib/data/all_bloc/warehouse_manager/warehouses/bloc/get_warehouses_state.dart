import 'package:equatable/equatable.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouses/repo/get_warehouses_response.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';

enum GetWarehousesStatus { loading, success, failed }

class GetWarehousesState extends Equatable {
  const GetWarehousesState(
      {this.status = GetWarehousesStatus.loading,
      this.mGetWarehousesResponse,
      this.webResponseFailed});

  final GetWarehousesStatus status;
  final GetWarehousesResponse? mGetWarehousesResponse;
  final WebResponseFailed? webResponseFailed;

  GetWarehousesState copyWith(
      {GetWarehousesStatus? status,
      GetWarehousesResponse? mGetWarehousesResponse,
      WebResponseFailed? webResponseFailed}) {
    return GetWarehousesState(
      status: status ?? this.status,
      mGetWarehousesResponse:
          mGetWarehousesResponse ?? this.mGetWarehousesResponse,
      webResponseFailed: webResponseFailed ?? this.webResponseFailed,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, GetWarehousesResponse: $mGetWarehousesResponse }''';
  }

  @override
  List<Object> get props => [
        status,
        mGetWarehousesResponse ?? GetWarehousesResponse(),
        webResponseFailed ?? WebResponseFailed()
      ];
}
