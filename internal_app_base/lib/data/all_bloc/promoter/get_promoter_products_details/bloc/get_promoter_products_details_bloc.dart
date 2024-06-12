import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_products_details/bloc/get_promoter_products_details_event.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_products_details/bloc/get_promoter_products_details_state.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_products_details/repo/get_promoter_products_details_repo.dart';
import 'package:internal_base/data/all_bloc/promoter/get_promoter_products_details/repo/get_promoter_products_details_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';


class GetPromoterProductsDetailsBloc extends Bloc<
    GetPromoterProductsDetailsEvent,
    GetPromoterProductsDetailsState> {
  final GetPromoterProductsDetailsRepository repository =
      GetPromoterProductsDetailsRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  GetPromoterProductsDetailsBloc()
      : super( const GetPromoterProductsDetailsState()) {
    on<GetPromoterProductsDetailsClickEvent>(
      (event, emit) async {
        emit(state.copyWith(
            status: GetPromoterProductsDetailsStatus.loading));
        try {
          var response =
              await repository.fetchGetPromoterProductsDetails(event.mGetPromoterProductsDetailsRequest);

          if (response is GetPromoterProductsDetailsResponse) {

              emit(state.copyWith(
                status: GetPromoterProductsDetailsStatus.success,
                mGetPromoterProductsDetailsResponse: response,
              ));

          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: GetPromoterProductsDetailsStatus.failed,
                webResponseFailed: response));
          }
        } catch (e) {
          emit(state.copyWith(
              status: GetPromoterProductsDetailsStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
