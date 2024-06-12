import 'package:equatable/equatable.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_products_details/repo/get_promoter_products_details_response.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_products_details/repo/store_manager_products_details_response.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';

enum GetStoreManagerProductsDetailsStatus { loading, success, failed }

class GetStoreManagerProductsDetailsState extends Equatable {
  const GetStoreManagerProductsDetailsState(
      {this.status = GetStoreManagerProductsDetailsStatus.loading,
        this.mGetStoreManagerProductsDetailsResponse ,
        this.webResponseFailed});

  final GetStoreManagerProductsDetailsStatus status;
  final GetStoreManagerProductsDetailsResponse? mGetStoreManagerProductsDetailsResponse;
  final WebResponseFailed? webResponseFailed;



  GetStoreManagerProductsDetailsState copyWith({
    GetStoreManagerProductsDetailsStatus? status,
    GetStoreManagerProductsDetailsResponse? mGetStoreManagerProductsDetailsResponse,
    WebResponseFailed? webResponseFailed
  }) {
    return GetStoreManagerProductsDetailsState(
      status: status ?? this.status,
      mGetStoreManagerProductsDetailsResponse:
      mGetStoreManagerProductsDetailsResponse ?? this.mGetStoreManagerProductsDetailsResponse,
      webResponseFailed:  webResponseFailed ?? this.webResponseFailed,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, GetStoreManagerProductsDetailsResponse: $mGetStoreManagerProductsDetailsResponse }''';
  }

  @override
  List<Object> get props => [
    status,
    mGetStoreManagerProductsDetailsResponse??GetStoreManagerProductsDetailsResponse(),
    webResponseFailed ?? WebResponseFailed()
  ];
}
