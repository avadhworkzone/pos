import 'package:equatable/equatable.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_home/repo/get_promoter_home_response.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';

enum GetPromoterHomeStatus { loading, success, failed }

class GetPromoterHomeState extends Equatable {
  const GetPromoterHomeState(
      {this.status = GetPromoterHomeStatus.loading,
        this.mGetPromoterHomeResponse ,
        this.webResponseFailed});

  final GetPromoterHomeStatus status;
  final GetPromoterHomeResponse? mGetPromoterHomeResponse;
  final WebResponseFailed? webResponseFailed;



  GetPromoterHomeState copyWith({
    GetPromoterHomeStatus? status,
    GetPromoterHomeResponse? mGetPromoterHomeResponse,
    WebResponseFailed? webResponseFailed
  }) {
    return GetPromoterHomeState(
      status: status ?? this.status,
      mGetPromoterHomeResponse:
      mGetPromoterHomeResponse ?? this.mGetPromoterHomeResponse,
      webResponseFailed:  webResponseFailed ?? this.webResponseFailed,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, GetPromoterHomeResponse: $mGetPromoterHomeResponse }''';
  }

  @override
  List<Object> get props => [
    status,
    mGetPromoterHomeResponse??GetPromoterHomeResponse(),
    webResponseFailed ?? WebResponseFailed()
  ];
}
