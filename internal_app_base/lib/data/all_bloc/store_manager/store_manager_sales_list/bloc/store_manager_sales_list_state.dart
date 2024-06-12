import 'package:equatable/equatable.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_sales_list/repo/store_manager_sales_list_response.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';

enum GetStoreManagerSalesListStatus { loading, success, failed }

class GetStoreManagerSalesListState extends Equatable {
  const GetStoreManagerSalesListState(
      {this.status = GetStoreManagerSalesListStatus.loading,
        this.mSalesListData = const <SalesListData>[],
        this.mGetStoreManagerSalesListResponse,
        this.webResponseFailed,
      this.hasReachedMax= 0});

  final GetStoreManagerSalesListStatus status;
  final List<SalesListData> mSalesListData;
  final GetStoreManagerSalesListResponse? mGetStoreManagerSalesListResponse;
  final WebResponseFailed? webResponseFailed;
  final int hasReachedMax;


  GetStoreManagerSalesListState copyWith({
    GetStoreManagerSalesListStatus? status,
    List<SalesListData>? mSalesListData,
    GetStoreManagerSalesListResponse? mGetStoreManagerSalesListResponse,
    WebResponseFailed? webResponseFailed,
    int? hasReachedMax
  }) {
    return GetStoreManagerSalesListState(
      status: status ?? this.status,
      mSalesListData:
      mSalesListData ?? this.mSalesListData,
      mGetStoreManagerSalesListResponse:
      mGetStoreManagerSalesListResponse ?? this.mGetStoreManagerSalesListResponse,
      webResponseFailed: webResponseFailed ?? this.webResponseFailed,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, GetStoreManagerSalesListResponse: $mSalesListData }''';
  }

  @override
  List<Object> get props => [
    status,
    mSalesListData,
    mGetStoreManagerSalesListResponse??GetStoreManagerSalesListResponse(),
    webResponseFailed ?? WebResponseFailed(),
    hasReachedMax
  ];
}
