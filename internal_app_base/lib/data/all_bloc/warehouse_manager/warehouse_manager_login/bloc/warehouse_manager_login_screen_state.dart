import 'package:equatable/equatable.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_login/repo/warehouse_manager_login_screen_response.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';

enum WarehouseManagerLoginScreenStatus { loading, success, failed }

class WarehouseManagerLoginScreenState extends Equatable {
  const WarehouseManagerLoginScreenState(
      {this.status = WarehouseManagerLoginScreenStatus.loading,
      this.mWarehouseManagerLoginScreenResponse,
      this.webResponseFailed});

  final WarehouseManagerLoginScreenStatus status;
  final WarehouseManagerLoginScreenResponse?
      mWarehouseManagerLoginScreenResponse;
  final WebResponseFailed? webResponseFailed;

  WarehouseManagerLoginScreenState copyWith(
      {WarehouseManagerLoginScreenStatus? status,
      WarehouseManagerLoginScreenResponse? mWarehouseManagerLoginScreenResponse,
      WebResponseFailed? webResponseFailed}) {
    return WarehouseManagerLoginScreenState(
      status: status ?? this.status,
      mWarehouseManagerLoginScreenResponse:
          mWarehouseManagerLoginScreenResponse ??
              this.mWarehouseManagerLoginScreenResponse,
      webResponseFailed: webResponseFailed ?? this.webResponseFailed,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, WarehouseManagerLoginScreenResponse: $mWarehouseManagerLoginScreenResponse }''';
  }

  @override
  List<Object> get props => [
        status,
        mWarehouseManagerLoginScreenResponse ??
            WarehouseManagerLoginScreenResponse(),
        webResponseFailed ?? WebResponseFailed()
      ];
}
