import 'package:equatable/equatable.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_commission_details/repo/get_promoter_commission_details_response.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';

enum GetPromoterCommissionDetailsStatus { loading, success, failed }

class GetPromoterCommissionDetailsState extends Equatable {
  const GetPromoterCommissionDetailsState(
      {this.status = GetPromoterCommissionDetailsStatus.loading,
      this.mGetPromoterCommissionDetailsResponse,
      this.webResponseFailed});

  final GetPromoterCommissionDetailsStatus status;
  final GetPromoterCommissionDetailsResponse?
      mGetPromoterCommissionDetailsResponse;
  final WebResponseFailed? webResponseFailed;

  GetPromoterCommissionDetailsState copyWith(
      {GetPromoterCommissionDetailsStatus? status,
      GetPromoterCommissionDetailsResponse?
          mGetPromoterCommissionDetailsResponse,
      WebResponseFailed? webResponseFailed}) {
    return GetPromoterCommissionDetailsState(
      status: status ?? this.status,
      mGetPromoterCommissionDetailsResponse:
          mGetPromoterCommissionDetailsResponse ??
              this.mGetPromoterCommissionDetailsResponse,
      webResponseFailed: webResponseFailed ?? this.webResponseFailed,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, GetPromoterCommissionDetailsResponse: $mGetPromoterCommissionDetailsResponse }''';
  }

  @override
  List<Object> get props => [
        status,
        mGetPromoterCommissionDetailsResponse ??
            GetPromoterCommissionDetailsResponse(),
        webResponseFailed ?? WebResponseFailed()
      ];
}
