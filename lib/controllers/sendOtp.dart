import 'package:esoptron_salon/models/api_request.dart';
import 'package:esoptron_salon/models/api_response.dart';
import 'package:esoptron_salon/repositories/sendOtp.dart';
import 'package:esoptron_salon/services/sendOtp.dart';
import 'package:esoptron_salon/states/global_state.dart';
import 'package:esoptron_salon/utils/enums/global_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _otpRepositoryProvider = Provider<OtpRepository>((ref) {
  return OtpService();
});

final otpProvider =
    StateNotifierProvider<OtpNotifier, AppState<ApiResponseModel>>((ref) {
  return OtpNotifier(ref.watch(_otpRepositoryProvider), ref);
});

class OtpNotifier extends StateNotifier<AppState<ApiResponseModel>> {
  final OtpRepository repository;
  StateNotifierProviderRef<OtpNotifier, AppState<ApiResponseModel>> ref;
  OtpNotifier(
    this.repository,
    this.ref,
  ) : super(AppState(status: Status.initial));

  getOtpCode(APIRequestModel apiRequestModel) async {
    state = AppState(status: Status.loading);
    final data = await repository.getOtp(apiRequestModel);
    print("hello this is our ${data}");
    data.fold((l) => state = AppState(status: Status.error, errorMessage: l),
        (r) => state = AppState(status: Status.loaded, data: r));
  }
}
