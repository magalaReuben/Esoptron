import 'package:esoptron_salon/models/api_request.dart';
import 'package:esoptron_salon/models/api_response.dart';
import 'package:esoptron_salon/repositories/service.dart';
import 'package:esoptron_salon/repositories/serviceProviders.dart';
import 'package:esoptron_salon/services/getServiceProviders.dart';
import 'package:esoptron_salon/services/services.dart';
import 'package:esoptron_salon/states/global_state.dart';
import 'package:esoptron_salon/utils/enums/global_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _ServiceProvidersRepositoryProvider =
    Provider<ServiceProviderRepository>((ref) {
  return ServiceProvidersService();
});

final serviceProvidersProvider =
    StateNotifierProvider<ServiceProvidersNotifier, AppState<ApiResponseModel>>(
        (ref) {
  return ServiceProvidersNotifier(
      ref.watch(_ServiceProvidersRepositoryProvider), ref);
});

class ServiceProvidersNotifier
    extends StateNotifier<AppState<ApiResponseModel>> {
  final ServiceProviderRepository repository;
  StateNotifierProviderRef<ServiceProvidersNotifier, AppState<ApiResponseModel>>
      ref;
  ServiceProvidersNotifier(
    this.repository,
    this.ref,
  ) : super(AppState(status: Status.initial)) {
    _getServiceProviders();
  }
  _getServiceProviders() async {
    //final countryDevice = ref.watch(countryAndDeviceProvider);
    state = AppState(status: Status.loading);
    final data = await repository.getServiceProviders(APIRequestModel());
    data.fold((l) => state = AppState(status: Status.error, errorMessage: l),
        (r) => state = AppState(status: Status.loaded, data: r));
  }
}
