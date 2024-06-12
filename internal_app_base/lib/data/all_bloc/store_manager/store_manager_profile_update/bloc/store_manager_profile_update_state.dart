import 'package:equatable/equatable.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_profile_update/repo/store_manager_profile_update_response.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';

enum PostStoreManagerProfileUpdateStatus { loading, success, failed }

class PostStoreManagerProfileUpdateState extends Equatable {
  const PostStoreManagerProfileUpdateState(
      {this.status = PostStoreManagerProfileUpdateStatus.loading,
        this.mPostStoreManagerProfileUpdateResponse ,
        this.webResponseFailed});

  final PostStoreManagerProfileUpdateStatus status;
  final PostStoreManagerProfileUpdateResponse? mPostStoreManagerProfileUpdateResponse;
  final WebResponseFailed? webResponseFailed;



  PostStoreManagerProfileUpdateState copyWith({
    PostStoreManagerProfileUpdateStatus? status,
    PostStoreManagerProfileUpdateResponse? mPostStoreManagerProfileUpdateResponse,
    WebResponseFailed? webResponseFailed
  }) {
    return PostStoreManagerProfileUpdateState(
      status: status ?? this.status,
      mPostStoreManagerProfileUpdateResponse:
      mPostStoreManagerProfileUpdateResponse ?? this.mPostStoreManagerProfileUpdateResponse,
      webResponseFailed: webResponseFailed ?? this.webResponseFailed,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, PostStoreManagerProfileUpdateResponse: $mPostStoreManagerProfileUpdateResponse }''';
  }

  @override
  List<Object> get props => [
    status,
    mPostStoreManagerProfileUpdateResponse??PostStoreManagerProfileUpdateResponse(),
    webResponseFailed ?? WebResponseFailed()
  ];
}
