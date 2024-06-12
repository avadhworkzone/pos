import 'package:equatable/equatable.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_profile_details/repo/get_promoter_profile_details_response.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';

enum GetPromoteProfileDetailsStatus { loading, success, failed }

class GetPromoteProfileDetailsState extends Equatable {
  const GetPromoteProfileDetailsState(
      {this.status = GetPromoteProfileDetailsStatus.loading,
        this.mGetPromoteProfileDetailsResponse ,
        this.webResponseFailed});

  final GetPromoteProfileDetailsStatus status;
  final GetPromoteProfileDetailsResponse? mGetPromoteProfileDetailsResponse;
  final WebResponseFailed? webResponseFailed;



  GetPromoteProfileDetailsState copyWith({
    GetPromoteProfileDetailsStatus? status,
    GetPromoteProfileDetailsResponse? mGetPromoteProfileDetailsResponse,
    WebResponseFailed? webResponseFailed
  }) {
    return GetPromoteProfileDetailsState(
      status: status ?? this.status,
      mGetPromoteProfileDetailsResponse:
      mGetPromoteProfileDetailsResponse ?? this.mGetPromoteProfileDetailsResponse,
      webResponseFailed:  webResponseFailed ?? this.webResponseFailed,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, GetPromoteProfileDetailsResponse: $mGetPromoteProfileDetailsResponse }''';
  }

  @override
  List<Object> get props => [
    status,
    mGetPromoteProfileDetailsResponse??GetPromoteProfileDetailsResponse(),
    webResponseFailed ?? WebResponseFailed()
  ];
}
