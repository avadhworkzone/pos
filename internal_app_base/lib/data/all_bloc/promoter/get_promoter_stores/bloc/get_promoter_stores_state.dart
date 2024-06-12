import 'package:equatable/equatable.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_stores/repo/get_promoter_stores_response.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';

enum GetPromoterStoresStatus { loading, success, failed }

class GetPromoterStoresState extends Equatable {
  const GetPromoterStoresState(
      {this.status = GetPromoterStoresStatus.loading,
        this.mGetPromoterStoresResponse ,
        this.webResponseFailed});

  final GetPromoterStoresStatus status;
  final GetPromoterStoresResponse? mGetPromoterStoresResponse;
  final WebResponseFailed? webResponseFailed;



  GetPromoterStoresState copyWith({
    GetPromoterStoresStatus? status,
    GetPromoterStoresResponse? mGetPromoterStoresResponse,
    WebResponseFailed? webResponseFailed
  }) {
    return GetPromoterStoresState(
      status: status ?? this.status,
      mGetPromoterStoresResponse:
      mGetPromoterStoresResponse ?? this.mGetPromoterStoresResponse,
      webResponseFailed:  webResponseFailed ?? this.webResponseFailed,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, GetPromoterStoresResponse: $mGetPromoterStoresResponse }''';
  }

  @override
  List<Object> get props => [
    status,
    mGetPromoterStoresResponse??GetPromoterStoresResponse(),
    webResponseFailed ?? WebResponseFailed()
  ];
}
