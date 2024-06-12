import 'package:equatable/equatable.dart';
import 'package:internal_base/data/all_bloc/promoter/post_promoter_profile_update/repo/post_promoter_profile_update_response.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';

enum PostPromoterProfileUpdateStatus { loading, success, failed }

class PostPromoterProfileUpdateState extends Equatable {
  const PostPromoterProfileUpdateState(
      {this.status = PostPromoterProfileUpdateStatus.loading,
        this.mPostPromoterProfileUpdateResponse ,
        this.webResponseFailed});

  final PostPromoterProfileUpdateStatus status;
  final PostPromoterProfileUpdateResponse? mPostPromoterProfileUpdateResponse;
  final WebResponseFailed? webResponseFailed;



  PostPromoterProfileUpdateState copyWith({
    PostPromoterProfileUpdateStatus? status,
    PostPromoterProfileUpdateResponse? mPostPromoterProfileUpdateResponse,
    WebResponseFailed? webResponseFailed
  }) {
    return PostPromoterProfileUpdateState(
      status: status ?? this.status,
      mPostPromoterProfileUpdateResponse:
      mPostPromoterProfileUpdateResponse ?? this.mPostPromoterProfileUpdateResponse,
      webResponseFailed: webResponseFailed ?? this.webResponseFailed,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, PostPromoterProfileUpdateResponse: $mPostPromoterProfileUpdateResponse }''';
  }

  @override
  List<Object> get props => [
    status,
    mPostPromoterProfileUpdateResponse??PostPromoterProfileUpdateResponse(),
    webResponseFailed ?? WebResponseFailed()
  ];
}
