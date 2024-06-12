import 'package:equatable/equatable.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_products_list/repo/store_manager_products_list_response.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';

enum GetStoreManagerProductsListStatus { loading, success, failed }

class GetStoreManagerProductsListState extends Equatable {
  const GetStoreManagerProductsListState(
      {this.status = GetStoreManagerProductsListStatus.loading,
        this.mProductsList = const <Products>[],
        this.mGetStoreManagerProductsListResponse,
        this.webResponseFailed,
      this.hasReachedMax= 0});

  final GetStoreManagerProductsListStatus status;
  final List<Products> mProductsList;
  final GetStoreManagerProductsListResponse? mGetStoreManagerProductsListResponse;
  final WebResponseFailed? webResponseFailed;
  final int hasReachedMax;


  GetStoreManagerProductsListState copyWith({
    GetStoreManagerProductsListStatus? status,
    List<Products>? mProductsList,
    GetStoreManagerProductsListResponse? mGetStoreManagerProductsListResponse,
    WebResponseFailed? webResponseFailed,
    int? hasReachedMax
  }) {
    return GetStoreManagerProductsListState(
      status: status ?? this.status,
      mProductsList:
      mProductsList ?? this.mProductsList,
      mGetStoreManagerProductsListResponse:
      mGetStoreManagerProductsListResponse ?? this.mGetStoreManagerProductsListResponse,
      webResponseFailed: webResponseFailed ?? this.webResponseFailed,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, GetStoreManagerProductsListResponse: $mProductsList }''';
  }

  @override
  List<Object> get props => [
    status,
    mProductsList,
    mGetStoreManagerProductsListResponse??GetStoreManagerProductsListResponse(),
    webResponseFailed ?? WebResponseFailed(),
    hasReachedMax
  ];
}
