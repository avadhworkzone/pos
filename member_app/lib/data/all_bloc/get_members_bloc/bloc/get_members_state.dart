import 'package:equatable/equatable.dart';
import 'package:member_app/data/all_bloc/get_members_bloc/repo/get_members_response.dart';
import 'package:member_app/data/remote/web_response_failed.dart';

enum GetMemberStatus { loading, success, failed }

class GetMemberState extends Equatable {
  const GetMemberState(
      {this.status = GetMemberStatus.loading,
        this.mGetMemberResponse ,
        this.webResponseFailed});

  final GetMemberStatus status;
  final GetMemberResponse? mGetMemberResponse;
  final WebResponseFailed? webResponseFailed;



  GetMemberState copyWith({
    GetMemberStatus? status,
    GetMemberResponse? mGetMemberResponse,
    WebResponseFailed? webResponseFailed
  }) {
    return GetMemberState(
      status: status ?? this.status,
      mGetMemberResponse:
      mGetMemberResponse ?? this.mGetMemberResponse,
      webResponseFailed: webResponseFailed ?? this.webResponseFailed,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, GetMemberResponse: $mGetMemberResponse }''';
  }

  @override
  List<Object> get props => [
    status,
    mGetMemberResponse??GetMemberResponse(),
    webResponseFailed ?? WebResponseFailed()
  ];
}
