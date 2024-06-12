import 'package:equatable/equatable.dart';
import 'package:member_app/data/all_bloc/get_members_details_bloc/repo/get_members_details_response.dart';
import 'package:member_app/data/remote/web_response_failed.dart';

enum GetMemberDetailsStatus { loading, success, failed }

class GetMemberDetailsState extends Equatable {
  const GetMemberDetailsState(
      {this.status = GetMemberDetailsStatus.loading,
        this.mGetMemberDetailsResponse ,
        this.webResponseFailed});

  final GetMemberDetailsStatus status;
  final GetMemberDetailsResponse? mGetMemberDetailsResponse;
  final WebResponseFailed? webResponseFailed;



  GetMemberDetailsState copyWith({
    GetMemberDetailsStatus? status,
    GetMemberDetailsResponse? mGetMemberDetailsResponse,
    WebResponseFailed? webResponseFailed
  }) {
    return GetMemberDetailsState(
      status: status ?? this.status,
      mGetMemberDetailsResponse:
      mGetMemberDetailsResponse ?? this.mGetMemberDetailsResponse,
      webResponseFailed: webResponseFailed ??this.webResponseFailed,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, GetMemberDetailsResponse: $mGetMemberDetailsResponse }''';
  }

  @override
  List<Object> get props => [
    status,
    mGetMemberDetailsResponse??GetMemberDetailsResponse(),
    webResponseFailed ?? WebResponseFailed()
  ];
}
