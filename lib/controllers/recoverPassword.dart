import 'package:esoptron_salon/models/api_request.dart';
import 'package:esoptron_salon/models/api_response.dart';
import 'package:esoptron_salon/repositories/category.dart';
import 'package:esoptron_salon/repositories/recoverPassword.dart';
import 'package:esoptron_salon/services/recoverPassword.dart';
import 'package:esoptron_salon/states/global_state.dart';
import 'package:esoptron_salon/utils/enums/global_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _recoverPasswordRepositoryProvider =
    Provider<RecoverPasswordRepository>((ref) {
  return RecoverPasswordService();
});

final recoverPasswordProvider =
    StateNotifierProvider<RecoverPasswordNotifier, AppState<ApiResponseModel>>(
        (ref) {
  return RecoverPasswordNotifier(
      ref.watch(_recoverPasswordRepositoryProvider), ref);
});

class RecoverPasswordNotifier
    extends StateNotifier<AppState<ApiResponseModel>> {
  final RecoverPasswordRepository repository;
  StateNotifierProviderRef<RecoverPasswordNotifier, AppState<ApiResponseModel>>
      ref;
  RecoverPasswordNotifier(
    this.repository,
    this.ref,
  ) : super(AppState(status: Status.initial));

  getRecoveryCode(APIRequestModel apiRequestModel) async {
    state = AppState(status: Status.loading);
    final data = await repository.getRecoveryCode(apiRequestModel);
    data.fold((l) => state = AppState(status: Status.error, errorMessage: l),
        (r) => state = AppState(status: Status.loaded, data: r));
  }
}
