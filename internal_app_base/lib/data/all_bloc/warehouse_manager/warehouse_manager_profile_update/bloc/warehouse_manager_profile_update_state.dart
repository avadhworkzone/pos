import 'package:equatable/equatable.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_profile_update/repo/warehouse_manager_profile_update_response.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';

enum PostWarehouseManagerProfileUpdateStatus { loading, success, failed }

class PostWarehouseManagerProfileUpdateState extends Equatable {
  const PostWarehouseManagerProfileUpdateState(
      {this.status = PostWarehouseManagerProfileUpdateStatus.loading,
        this.mPostWarehouseManagerProfileUpdateResponse ,
        this.webResponseFailed});

  final PostWarehouseManagerProfileUpdateStatus status;
  final PostWarehouseManagerProfileUpdateResponse? mPostWarehouseManagerProfileUpdateResponse;
  final WebResponseFailed? webResponseFailed;



  PostWarehouseManagerProfileUpdateState copyWith({
    PostWarehouseManagerProfileUpdateStatus? status,
    PostWarehouseManagerProfileUpdateResponse? mPostWarehouseManagerProfileUpdateResponse,
    WebResponseFailed? webResponseFailed
  }) {
    return PostWarehouseManagerProfileUpdateState(
      status: status ?? this.status,
      mPostWarehouseManagerProfileUpdateResponse:
      mPostWarehouseManagerProfileUpdateResponse ?? this.mPostWarehouseManagerProfileUpdateResponse,
      webResponseFailed: webResponseFailed ?? this.webResponseFailed,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, PostWarehouseManagerProfileUpdateResponse: $mPostWarehouseManagerProfileUpdateResponse }''';
  }

  @override
  List<Object> get props => [
    status,
    mPostWarehouseManagerProfileUpdateResponse??PostWarehouseManagerProfileUpdateResponse(),
    webResponseFailed ?? WebResponseFailed()
  ];
}
