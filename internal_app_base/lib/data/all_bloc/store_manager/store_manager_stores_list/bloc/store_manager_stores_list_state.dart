import 'package:equatable/equatable.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_stores_list/repo/store_manager_stores_list_response.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';

enum GetStoreManagerStoresListStatus { loading, success, failed }

class GetStoreManagerStoresListState extends Equatable {
  const GetStoreManagerStoresListState(
      {this.status = GetStoreManagerStoresListStatus.loading,
        this.mGetStoreManagerStoresListResponse ,
        this.webResponseFailed});

  final GetStoreManagerStoresListStatus status;
  final GetStoreManagerStoresListResponse? mGetStoreManagerStoresListResponse;
  final WebResponseFailed? webResponseFailed;



  GetStoreManagerStoresListState copyWith({
    GetStoreManagerStoresListStatus? status,
    GetStoreManagerStoresListResponse? mGetStoreManagerStoresListResponse,
    WebResponseFailed? webResponseFailed
  }) {
    return GetStoreManagerStoresListState(
      status: status ?? this.status,
      mGetStoreManagerStoresListResponse:
      mGetStoreManagerStoresListResponse ?? this.mGetStoreManagerStoresListResponse,
      webResponseFailed:  webResponseFailed ?? this.webResponseFailed,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, GetStoreManagerStoresListResponse: $mGetStoreManagerStoresListResponse }''';
  }

  @override
  List<Object> get props => [
    status,
    mGetStoreManagerStoresListResponse??GetStoreManagerStoresListResponse(),
    webResponseFailed ?? WebResponseFailed()
  ];
}
