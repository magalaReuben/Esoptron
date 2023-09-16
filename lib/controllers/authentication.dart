import 'dart:developer';

import 'package:esoptron_salon/models/api_request.dart';
import 'package:esoptron_salon/models/api_response.dart';
import 'package:esoptron_salon/repositories/authentication.dart';
import 'package:esoptron_salon/services/authentication.dart';
import 'package:esoptron_salon/states/global_state.dart';
import 'package:esoptron_salon/utils/enums/global_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _authenticationRepositoryProvider =
    Provider<AuthenticationRepository>((ref) {
  return AuthenticationService();
});

final registrationNotifierProvider =
    StateNotifierProvider<RegistrationNotifier, AppState<ApiResponseModel>>(
        (ref) {
  return RegistrationNotifier(ref.watch(_authenticationRepositoryProvider));
});

class RegistrationNotifier extends StateNotifier<AppState<ApiResponseModel>> {
  final AuthenticationRepository _repository;
  RegistrationNotifier(this._repository)
      : super(AppState(status: Status.initial));

  Future<void> register(APIRequestModel apiRequestModel, context) async {
    state = AppState(status: Status.loading);
    var data = await _repository.registration(apiRequestModel.data, context);
    log(data.toString());
    data.fold((l) => state = AppState(status: Status.error, errorMessage: l),
        (r) => state = AppState(status: Status.loaded, data: r));
  }
}

final loginNotifierProvider =
    StateNotifierProvider<LoginNotifier, AppState<ApiResponseModel>>((ref) {
  return LoginNotifier(ref.watch(_authenticationRepositoryProvider));
});

class LoginNotifier extends StateNotifier<AppState<ApiResponseModel>> {
  final AuthenticationRepository _repository;
  LoginNotifier(
    this._repository,
  ) : super(AppState(status: Status.initial));

  Future<void> login(APIRequestModel apiRequestModel) async {
    state = AppState(status: Status.loading);
    var data = await _repository.login(apiRequestModel);
    log(data.toString());
    data.fold((l) => state = AppState(status: Status.error, errorMessage: l),
        (r) => state = AppState(status: Status.loaded, data: r));
  }
}
