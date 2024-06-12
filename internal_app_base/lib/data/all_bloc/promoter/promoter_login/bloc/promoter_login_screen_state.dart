import 'package:equatable/equatable.dart';
import 'package:internal_base/data/all_bloc/promoter/promoter_login/repo/promoter_login_screen_response.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';

enum PromoterLoginScreenStatus { loading, success, failed }

class PromoterLoginScreenState extends Equatable {
  const PromoterLoginScreenState(
      {this.status = PromoterLoginScreenStatus.loading,
        this.mPromoterLoginScreenResponse ,
        this.webResponseFailed});

  final PromoterLoginScreenStatus status;
  final PromoterLoginScreenResponse? mPromoterLoginScreenResponse;
  final WebResponseFailed? webResponseFailed;



  PromoterLoginScreenState copyWith({
    PromoterLoginScreenStatus? status,
    PromoterLoginScreenResponse? mPromoterLoginScreenResponse,
    WebResponseFailed? webResponseFailed
  }) {
    return PromoterLoginScreenState(
      status: status ?? this.status,
      mPromoterLoginScreenResponse:
      mPromoterLoginScreenResponse ?? this.mPromoterLoginScreenResponse,
      webResponseFailed: webResponseFailed ?? this.webResponseFailed,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, PromoterLoginScreenResponse: $mPromoterLoginScreenResponse }''';
  }

  @override
  List<Object> get props => [
    status,
    mPromoterLoginScreenResponse??PromoterLoginScreenResponse(),
    webResponseFailed ?? WebResponseFailed()
  ];
}
