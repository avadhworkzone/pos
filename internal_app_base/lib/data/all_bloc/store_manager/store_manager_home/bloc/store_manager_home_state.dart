import 'package:equatable/equatable.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_home/repo/store_manager_home_response.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';

enum GetStoreManagerHomeStatus { loading, success, failed }

class GetStoreManagerHomeState extends Equatable {
  const GetStoreManagerHomeState(
      {this.status = GetStoreManagerHomeStatus.loading,
      this.mGetStoreManagerHomeResponse,
      this.webResponseFailed});

  final GetStoreManagerHomeStatus status;
  final GetStoreManagerHomeResponse? mGetStoreManagerHomeResponse;
  final WebResponseFailed? webResponseFailed;

  GetStoreManagerHomeState copyWith(
      {GetStoreManagerHomeStatus? status,
      GetStoreManagerHomeResponse? mGetStoreManagerHomeResponse,
      WebResponseFailed? webResponseFailed}) {
    return GetStoreManagerHomeState(
      status: status ?? this.status,
      mGetStoreManagerHomeResponse:
          mGetStoreManagerHomeResponse ?? this.mGetStoreManagerHomeResponse,
      webResponseFailed: webResponseFailed ?? this.webResponseFailed,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, GetStoreManagerHomeResponse: $mGetStoreManagerHomeResponse }''';
  }

  @override
  List<Object> get props => [
        status,
        mGetStoreManagerHomeResponse ?? GetStoreManagerHomeResponse(),
        webResponseFailed ?? WebResponseFailed()
      ];
}
