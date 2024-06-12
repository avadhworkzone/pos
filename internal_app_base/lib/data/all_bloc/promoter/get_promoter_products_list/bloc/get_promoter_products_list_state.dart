import 'package:equatable/equatable.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_products_list/repo/get_promoter_products_list_response.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';




enum GetPromoterProductsListStatus { loading, success, failed }

class GetPromoterProductsListState extends Equatable {
  const GetPromoterProductsListState(
      {this.status = GetPromoterProductsListStatus.loading,
        this.mProductsList = const <Products>[],
        this.mGetPromoterProductsListResponse,
        this.webResponseFailed,
      this.hasReachedMax= 0});

  final GetPromoterProductsListStatus status;
  final List<Products> mProductsList;
  final GetPromoterProductsListResponse? mGetPromoterProductsListResponse;
  final WebResponseFailed? webResponseFailed;
  final int hasReachedMax;


  GetPromoterProductsListState copyWith({
    GetPromoterProductsListStatus? status,
    List<Products>? mProductsList,
    GetPromoterProductsListResponse? mGetPromoterProductsListResponse,
    WebResponseFailed? webResponseFailed,
    int? hasReachedMax
  }) {
    return GetPromoterProductsListState(
      status: status ?? this.status,
      mProductsList:
      mProductsList ?? this.mProductsList,
      mGetPromoterProductsListResponse:
      mGetPromoterProductsListResponse ?? this.mGetPromoterProductsListResponse,
      webResponseFailed: webResponseFailed ?? this.webResponseFailed,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, GetPromoterProductsListResponse: $mProductsList }''';
  }

  @override
  List<Object> get props => [
    status,
    mProductsList,
    mGetPromoterProductsListResponse??GetPromoterProductsListResponse(),
    webResponseFailed ?? WebResponseFailed(),
    hasReachedMax
  ];
}
