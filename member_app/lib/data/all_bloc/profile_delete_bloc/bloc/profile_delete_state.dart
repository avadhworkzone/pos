import 'package:equatable/equatable.dart';
import 'package:member_app/data/all_bloc/profile_delete_bloc/repo/profile_delete_response.dart';
import 'package:member_app/data/remote/web_response_failed.dart';

enum ProfileDeleteStatus { loading, success, failed }

class ProfileDeleteState extends Equatable {
  const ProfileDeleteState(
      {this.status = ProfileDeleteStatus.loading,
        this.mProfileDeleteResponse ,
        this.webResponseFailed});

  final ProfileDeleteStatus status;
  final ProfileDeleteResponse? mProfileDeleteResponse;
  final WebResponseFailed? webResponseFailed;



  ProfileDeleteState copyWith({
    ProfileDeleteStatus? status,
    ProfileDeleteResponse? mProfileDeleteResponse,
    WebResponseFailed? webResponseFailed
  }) {
    return ProfileDeleteState(
      status: status ?? this.status,
      mProfileDeleteResponse:
      mProfileDeleteResponse ?? this.mProfileDeleteResponse,
      webResponseFailed:  webResponseFailed ?? this.webResponseFailed,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, ProfileDeleteResponse: $mProfileDeleteResponse }''';
  }

  @override
  List<Object> get props => [
    status,
    mProfileDeleteResponse??ProfileDeleteResponse(),
    webResponseFailed ?? WebResponseFailed()
  ];
}
