import 'package:equatable/equatable.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_login/repo/store_manager_login_screen_response.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';

enum StoreManagerLoginScreenStatus { loading, success, failed }

class StoreManagerLoginScreenState extends Equatable {
  const StoreManagerLoginScreenState(
      {this.status = StoreManagerLoginScreenStatus.loading,
        this.mStoreManagerLoginScreenResponse ,
        this.webResponseFailed});

  final StoreManagerLoginScreenStatus status;
  final StoreManagerLoginScreenResponse? mStoreManagerLoginScreenResponse;
  final WebResponseFailed? webResponseFailed;



  StoreManagerLoginScreenState copyWith({
    StoreManagerLoginScreenStatus? status,
    StoreManagerLoginScreenResponse? mStoreManagerLoginScreenResponse,
    WebResponseFailed? webResponseFailed
  }) {
    return StoreManagerLoginScreenState(
      status: status ?? this.status,
      mStoreManagerLoginScreenResponse:
      mStoreManagerLoginScreenResponse ?? this.mStoreManagerLoginScreenResponse,
      webResponseFailed: webResponseFailed ?? this.webResponseFailed,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, StoreManagerLoginScreenResponse: $mStoreManagerLoginScreenResponse }''';
  }

  @override
  List<Object> get props => [
    status,
    mStoreManagerLoginScreenResponse??StoreManagerLoginScreenResponse(),
    webResponseFailed ?? WebResponseFailed()
  ];
}
