import 'package:equatable/equatable.dart';
import 'package:member_app/data/all_bloc/get_races_bloc/repo/get_races_response.dart';
import 'package:member_app/data/remote/web_response_failed.dart';

enum GetRacesStatus { loading, success, failed }

class GetRacesState extends Equatable {
  const GetRacesState(
      {this.status = GetRacesStatus.loading,
        this.mGetRacesResponse ,
        this.webResponseFailed});

  final GetRacesStatus status;
  final GetRacesResponse? mGetRacesResponse;
  final WebResponseFailed? webResponseFailed;



  GetRacesState copyWith({
    GetRacesStatus? status,
    GetRacesResponse? mGetRacesResponse,
    WebResponseFailed? webResponseFailed
  }) {
    return GetRacesState(
      status: status ?? this.status,
      mGetRacesResponse:
      mGetRacesResponse ?? this.mGetRacesResponse,
      webResponseFailed: webResponseFailed ?? this.webResponseFailed,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, GetRacesResponse: $mGetRacesResponse }''';
  }

  @override
  List<Object> get props => [
    status,
    mGetRacesResponse??GetRacesResponse(),
    webResponseFailed ?? WebResponseFailed()
  ];
}
