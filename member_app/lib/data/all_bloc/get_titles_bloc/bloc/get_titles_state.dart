import 'package:equatable/equatable.dart';
import 'package:member_app/data/all_bloc/get_titles_bloc/repo/get_titles_response.dart';
import 'package:member_app/data/remote/web_response_failed.dart';

enum GetTitlesStatus { loading, success, failed }

class GetTitlesState extends Equatable {
  const GetTitlesState(
      {this.status = GetTitlesStatus.loading,
        this.mGetTitlesResponse ,
        this.webResponseFailed});

  final GetTitlesStatus status;
  final GetTitlesResponse? mGetTitlesResponse;
  final WebResponseFailed? webResponseFailed;



  GetTitlesState copyWith({
    GetTitlesStatus? status,
    GetTitlesResponse? mGetTitlesResponse,
    WebResponseFailed? webResponseFailed
  }) {
    return GetTitlesState(
      status: status ?? this.status,
      mGetTitlesResponse:
      mGetTitlesResponse ?? this.mGetTitlesResponse,
      webResponseFailed: webResponseFailed ?? this.webResponseFailed,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, GetTitlesResponse: $mGetTitlesResponse }''';
  }

  @override
  List<Object> get props => [
    status,
    mGetTitlesResponse??GetTitlesResponse(),
    webResponseFailed ?? WebResponseFailed()
  ];
}
