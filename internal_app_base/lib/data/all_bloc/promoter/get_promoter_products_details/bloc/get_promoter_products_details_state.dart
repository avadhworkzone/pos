import 'package:equatable/equatable.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_products_details/repo/get_promoter_products_details_response.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';

enum GetPromoterProductsDetailsStatus { loading, success, failed }

class GetPromoterProductsDetailsState extends Equatable {
  const GetPromoterProductsDetailsState(
      {this.status = GetPromoterProductsDetailsStatus.loading,
        this.mGetPromoterProductsDetailsResponse ,
        this.webResponseFailed});

  final GetPromoterProductsDetailsStatus status;
  final GetPromoterProductsDetailsResponse? mGetPromoterProductsDetailsResponse;
  final WebResponseFailed? webResponseFailed;



  GetPromoterProductsDetailsState copyWith({
    GetPromoterProductsDetailsStatus? status,
    GetPromoterProductsDetailsResponse? mGetPromoterProductsDetailsResponse,
    WebResponseFailed? webResponseFailed
  }) {
    return GetPromoterProductsDetailsState(
      status: status ?? this.status,
      mGetPromoterProductsDetailsResponse:
      mGetPromoterProductsDetailsResponse ?? this.mGetPromoterProductsDetailsResponse,
      webResponseFailed:  webResponseFailed ?? this.webResponseFailed,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, GetPromoterProductsDetailsResponse: $mGetPromoterProductsDetailsResponse }''';
  }

  @override
  List<Object> get props => [
    status,
    mGetPromoterProductsDetailsResponse??GetPromoterProductsDetailsResponse(),
    webResponseFailed ?? WebResponseFailed()
  ];
}
