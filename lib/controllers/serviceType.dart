import 'package:esoptron_salon/models/api_request.dart';
import 'package:esoptron_salon/models/api_response.dart';
import 'package:esoptron_salon/repositories/serviceType.dart';
import 'package:esoptron_salon/services/serviceTypes.dart';
import 'package:esoptron_salon/states/global_state.dart';
import 'package:esoptron_salon/utils/enums/global_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _ServiceTypeRepositoryProvider = Provider<ServiceTypeRepository>((ref) {
  return ServiceTypesService();
});

final serviceTypesProvider =
    StateNotifierProvider<ServiceTypeNotifier, AppState<ApiResponseModel>>(
        (ref) {
  return ServiceTypeNotifier(ref.watch(_ServiceTypeRepositoryProvider), ref);
});

class ServiceTypeNotifier extends StateNotifier<AppState<ApiResponseModel>> {
  final ServiceTypeRepository repository;
  StateNotifierProviderRef<ServiceTypeNotifier, AppState<ApiResponseModel>> ref;
  ServiceTypeNotifier(
    this.repository,
    this.ref,
  ) : super(AppState(status: Status.initial)) {
    _getServiceTypes();
  }
  _getServiceTypes() async {
    //final countryDevice = ref.watch(countryAndDeviceProvider);
    state = AppState(status: Status.loading);
    final data = await repository.getServiceTypes(APIRequestModel());
    data.fold((l) => state = AppState(status: Status.error, errorMessage: l),
        (r) => state = AppState(status: Status.loaded, data: r));
  }
}
