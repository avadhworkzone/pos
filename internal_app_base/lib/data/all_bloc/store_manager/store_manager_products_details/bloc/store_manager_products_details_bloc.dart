import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_products_details/bloc/store_manager_products_details_event.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_products_details/bloc/store_manager_products_details_state.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_products_details/repo/store_manager_products_details_repo.dart';
import 'package:internal_base/data/all_bloc/store_manager/store_manager_products_details/repo/store_manager_products_details_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';
import 'package:internal_base/data/remote/web_service.dart';


class GetStoreManagerProductsDetailsBloc extends Bloc<
    GetStoreManagerProductsDetailsEvent,
    GetStoreManagerProductsDetailsState> {
  final GetStoreManagerProductsDetailsRepository repository =
      GetStoreManagerProductsDetailsRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  GetStoreManagerProductsDetailsBloc()
      : super( const GetStoreManagerProductsDetailsState()) {
    on<GetStoreManagerProductsDetailsClickEvent>(
      (event, emit) async {
        emit(state.copyWith(
            status: GetStoreManagerProductsDetailsStatus.loading));
        try {
          var response =
              await repository.fetchGetStoreManagerProductsDetails(event.mGetStoreManagerProductsDetailsRequest);

          if (response is GetStoreManagerProductsDetailsResponse) {

              emit(state.copyWith(
                status: GetStoreManagerProductsDetailsStatus.success,
                mGetStoreManagerProductsDetailsResponse: response,
              ));

          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: GetStoreManagerProductsDetailsStatus.failed,
                webResponseFailed: response));
          }
        } catch (e) {
          emit(state.copyWith(
              status: GetStoreManagerProductsDetailsStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
