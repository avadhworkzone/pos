import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_commission_details/bloc/get_promoter_products_details_event.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_commission_details/bloc/get_promoter_products_details_state.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_commission_details/repo/get_promoter_commission_details_repo.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_commission_details/repo/get_promoter_commission_details_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';

class GetPromoterCommissionDetailsBloc extends Bloc<
    GetPromoterCommissionDetailsEvent, GetPromoterCommissionDetailsState> {
  final GetPromoterCommissionDetailsRepository repository =
      GetPromoterCommissionDetailsRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  GetPromoterCommissionDetailsBloc()
      : super(const GetPromoterCommissionDetailsState()) {
    on<GetPromoterCommissionDetailsClickEvent>(
      (event, emit) async {
        emit(
            state.copyWith(status: GetPromoterCommissionDetailsStatus.loading));
        try {
          var response = await repository.fetchGetPromoterCommissionDetails(
              event.mGetPromoterCommissionDetailsRequest);

          if (response is GetPromoterCommissionDetailsResponse) {
            emit(state.copyWith(
              status: GetPromoterCommissionDetailsStatus.success,
              mGetPromoterCommissionDetailsResponse: response,
            ));
          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: GetPromoterCommissionDetailsStatus.failed,
                webResponseFailed: response));
          }
        } catch (e) {
          emit(state.copyWith(
              status: GetPromoterCommissionDetailsStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
