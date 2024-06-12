import 'package:equatable/equatable.dart';
import 'package:member_app/data/all_bloc/profile_update_bloc/repo/profile_update_response.dart';
import 'package:member_app/data/remote/web_response_failed.dart';

enum ProfileUpdateStatus { loading, success, failed }

class ProfileUpdateState extends Equatable {
  const ProfileUpdateState(
      {this.status = ProfileUpdateStatus.loading,
        this.mProfileUpdateResponse ,
        this.webResponseFailed});

  final ProfileUpdateStatus status;
  final ProfileUpdateResponse? mProfileUpdateResponse;
  final WebResponseFailed? webResponseFailed;



  ProfileUpdateState copyWith({
    ProfileUpdateStatus? status,
    ProfileUpdateResponse? mProfileUpdateResponse,
    WebResponseFailed? webResponseFailed
  }) {
    return ProfileUpdateState(
      status: status ?? this.status,
      mProfileUpdateResponse:
      mProfileUpdateResponse ?? this.mProfileUpdateResponse,
      webResponseFailed:  webResponseFailed ?? this.webResponseFailed,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, ProfileUpdateResponse: $mProfileUpdateResponse }''';
  }

  @override
  List<Object> get props => [
    status,
    mProfileUpdateResponse??ProfileUpdateResponse(),
    webResponseFailed ?? WebResponseFailed()
  ];
}
