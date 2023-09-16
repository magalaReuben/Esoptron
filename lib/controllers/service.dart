import 'package:esoptron_salon/models/api_request.dart';
import 'package:esoptron_salon/models/api_response.dart';
import 'package:esoptron_salon/repositories/service.dart';
import 'package:esoptron_salon/services/services.dart';
import 'package:esoptron_salon/states/global_state.dart';
import 'package:esoptron_salon/utils/enums/global_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _ServiceRepositoryProvider = Provider<ServiceRepository>((ref) {
  return ServicesService();
});

final servicesProvider =
    StateNotifierProvider<ServiceNotifier, AppState<ApiResponseModel>>((ref) {
  return ServiceNotifier(ref.watch(_ServiceRepositoryProvider), ref);
});

class ServiceNotifier extends StateNotifier<AppState<ApiResponseModel>> {
  final ServiceRepository repository;
  StateNotifierProviderRef<ServiceNotifier, AppState<ApiResponseModel>> ref;
  ServiceNotifier(
    this.repository,
    this.ref,
  ) : super(AppState(status: Status.initial)) {
    _getServices();
  }
  _getServices() async {
    //final countryDevice = ref.watch(countryAndDeviceProvider);
    state = AppState(status: Status.loading);
    final data = await repository.getServices(APIRequestModel());
    data.fold((l) => state = AppState(status: Status.error, errorMessage: l),
        (r) => state = AppState(status: Status.loaded, data: r));
  }
}
