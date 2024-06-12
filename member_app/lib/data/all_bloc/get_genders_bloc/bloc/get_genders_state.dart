import 'package:equatable/equatable.dart';
import 'package:member_app/data/all_bloc/get_genders_bloc/repo/get_genders_response.dart';
import 'package:member_app/data/remote/web_response_failed.dart';

enum GetGendersStatus { loading, success, failed }

class GetGendersState extends Equatable {
  const GetGendersState(
      {this.status = GetGendersStatus.loading,
        this.mGetGendersResponse ,
        this.webResponseFailed});

  final GetGendersStatus status;
  final GetGendersResponse? mGetGendersResponse;
  final WebResponseFailed? webResponseFailed;



  GetGendersState copyWith({
    GetGendersStatus? status,
    GetGendersResponse? mGetGendersResponse,
    WebResponseFailed? webResponseFailed
  }) {
    return GetGendersState(
      status: status ?? this.status,
      mGetGendersResponse:
      mGetGendersResponse ?? this.mGetGendersResponse,
      webResponseFailed:  webResponseFailed ?? this.webResponseFailed,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, GetGendersResponse: $mGetGendersResponse }''';
  }

  @override
  List<Object> get props => [
    status,
    mGetGendersResponse??GetGendersResponse(),
    webResponseFailed ?? WebResponseFailed()
  ];
}
