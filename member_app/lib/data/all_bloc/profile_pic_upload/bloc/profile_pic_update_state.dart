import 'package:equatable/equatable.dart';
import 'package:member_app/data/all_bloc/profile_pic_upload/repo/profile_pic_update_response.dart';
import 'package:member_app/data/remote/web_response_failed.dart';

enum ProfilePicUpdateStatus { loading, success, failed }

class ProfilePicUpdateState extends Equatable {
  const ProfilePicUpdateState(
      {this.status = ProfilePicUpdateStatus.loading,
        this.mProfilePicUpdateResponse ,
        this.webResponseFailed});

  final ProfilePicUpdateStatus status;
  final ProfilePicUpdateResponse? mProfilePicUpdateResponse;
  final WebResponseFailed? webResponseFailed;



  ProfilePicUpdateState copyWith({
    ProfilePicUpdateStatus? status,
    ProfilePicUpdateResponse? mProfilePicUpdateResponse,
    WebResponseFailed? webResponseFailed
  }) {
    return ProfilePicUpdateState(
      status: status ?? this.status,
      mProfilePicUpdateResponse:
      mProfilePicUpdateResponse ?? this.mProfilePicUpdateResponse,
      webResponseFailed:  webResponseFailed ?? this.webResponseFailed,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, ProfilePicUpdateResponse: $mProfilePicUpdateResponse }''';
  }

  @override
  List<Object> get props => [
    status,
    mProfilePicUpdateResponse??ProfilePicUpdateResponse(),
    webResponseFailed ?? WebResponseFailed()
  ];
}
