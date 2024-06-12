import 'package:equatable/equatable.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_profile_details/repo/store_manager_profile_details_response.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';

enum GetStoreManagerProfileDetailsStatus { loading, success, failed }

class GetStoreManagerProfileDetailsState extends Equatable {
  const GetStoreManagerProfileDetailsState(
      {this.status = GetStoreManagerProfileDetailsStatus.loading,
        this.mGetStoreManagerProfileDetailsResponse ,
        this.webResponseFailed});

  final GetStoreManagerProfileDetailsStatus status;
  final GetStoreManagerProfileDetailsResponse? mGetStoreManagerProfileDetailsResponse;
  final WebResponseFailed? webResponseFailed;



  GetStoreManagerProfileDetailsState copyWith({
    GetStoreManagerProfileDetailsStatus? status,
    GetStoreManagerProfileDetailsResponse? mGetStoreManagerProfileDetailsResponse,
    WebResponseFailed? webResponseFailed
  }) {
    return GetStoreManagerProfileDetailsState(
      status: status ?? this.status,
      mGetStoreManagerProfileDetailsResponse:
      mGetStoreManagerProfileDetailsResponse ?? this.mGetStoreManagerProfileDetailsResponse,
      webResponseFailed:  webResponseFailed ?? this.webResponseFailed,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, GetStoreManagerProfileDetailsResponse: $mGetStoreManagerProfileDetailsResponse }''';
  }

  @override
  List<Object> get props => [
    status,
    mGetStoreManagerProfileDetailsResponse??GetStoreManagerProfileDetailsResponse(),
    webResponseFailed ?? WebResponseFailed()
  ];
}
