import 'package:equatable/equatable.dart';
import 'package:internal_base/data/all_bloc/promoter/add_member/repo/add_member_response.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';

enum AddMemberStatus { loading, success, failed }

class AddMemberState extends Equatable {
  const AddMemberState(
      {this.status = AddMemberStatus.loading,
        this.mAddMemberResponse ,
        this.webResponseFailed});

  final AddMemberStatus status;
  final AddMemberResponse? mAddMemberResponse;
  final WebResponseFailed? webResponseFailed;



  AddMemberState copyWith({
    AddMemberStatus? status,
    AddMemberResponse? mAddMemberResponse,
    WebResponseFailed? webResponseFailed
  }) {
    return AddMemberState(
      status: status ?? this.status,
      mAddMemberResponse:
      mAddMemberResponse ?? this.mAddMemberResponse,
      webResponseFailed:  webResponseFailed ?? this.webResponseFailed,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, AddMemberResponse: $mAddMemberResponse }''';
  }

  @override
  List<Object> get props => [
    status,
    mAddMemberResponse??AddMemberResponse(),
    webResponseFailed ?? WebResponseFailed()
  ];
}
