import 'package:equatable/equatable.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_profile_details/repo/warehouse_manager_profile_details_response.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';

enum GetWarehouseManagerProfileDetailsStatus { loading, success, failed }

class GetWarehouseManagerProfileDetailsState extends Equatable {
  const GetWarehouseManagerProfileDetailsState(
      {this.status = GetWarehouseManagerProfileDetailsStatus.loading,
      this.mGetWarehouseManagerProfileDetailsResponse,
      this.webResponseFailed});

  final GetWarehouseManagerProfileDetailsStatus status;
  final GetWarehouseManagerProfileDetailsResponse?
      mGetWarehouseManagerProfileDetailsResponse;
  final WebResponseFailed? webResponseFailed;

  GetWarehouseManagerProfileDetailsState copyWith(
      {GetWarehouseManagerProfileDetailsStatus? status,
      GetWarehouseManagerProfileDetailsResponse?
          mGetWarehouseManagerProfileDetailsResponse,
      WebResponseFailed? webResponseFailed}) {
    return GetWarehouseManagerProfileDetailsState(
      status: status ?? this.status,
      mGetWarehouseManagerProfileDetailsResponse:
          mGetWarehouseManagerProfileDetailsResponse ??
              this.mGetWarehouseManagerProfileDetailsResponse,
      webResponseFailed: webResponseFailed ?? this.webResponseFailed,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, GetWarehouseManagerProfileDetailsResponse: $mGetWarehouseManagerProfileDetailsResponse }''';
  }

  @override
  List<Object> get props => [
        status,
        mGetWarehouseManagerProfileDetailsResponse ??
            GetWarehouseManagerProfileDetailsResponse(),
        webResponseFailed ?? WebResponseFailed()
      ];
}
