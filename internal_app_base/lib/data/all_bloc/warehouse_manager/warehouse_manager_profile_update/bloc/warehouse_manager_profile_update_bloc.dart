import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_profile_update/bloc/warehouse_manager_profile_update_event.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_profile_update/bloc/warehouse_manager_profile_update_state.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_profile_update/repo/warehouse_manager_profile_update_repo.dart';
import 'package:internal_base/data/all_bloc/warehouse_manager/warehouse_manager_profile_update/repo/warehouse_manager_profile_update_response.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';
import 'package:internal_base/data/remote/web_service.dart';
import 'package:internal_base/data/remote/web_response_failed.dart';

class PostWarehouseManagerProfileUpdateBloc extends Bloc<
    PostWarehouseManagerProfileUpdateEvent,
    PostWarehouseManagerProfileUpdateState> {
  final PostWarehouseManagerProfileUpdateRepository repository =
      PostWarehouseManagerProfileUpdateRepository(
          sharedPrefs: SharedPrefs(), webservice: Webservice());

  PostWarehouseManagerProfileUpdateBloc()
      : super(const PostWarehouseManagerProfileUpdateState()) {
    on<PostWarehouseManagerProfileUpdateClickEvent>(
      (event, emit) async {
        emit(state.copyWith(
            status: PostWarehouseManagerProfileUpdateStatus.loading));
        try {
          var response =
              await repository.fetchPostWarehouseManagerProfileUpdate(
                  event.mPostWarehouseManagerProfileUpdateListRequest);

          if (response is PostWarehouseManagerProfileUpdateResponse) {
            emit(state.copyWith(
              status: PostWarehouseManagerProfileUpdateStatus.success,
              mPostWarehouseManagerProfileUpdateResponse: response,
            ));
          } else if (response is WebResponseFailed) {
            emit(state.copyWith(
                status: PostWarehouseManagerProfileUpdateStatus.failed,
                webResponseFailed: response));
          }
        } catch (e) {
          emit(state.copyWith(
              status: PostWarehouseManagerProfileUpdateStatus.failed,
              webResponseFailed: WebResponseFailed(
                  statusMessage: "Unable to process your request right now")));
        }
      },
    );
  }
}
