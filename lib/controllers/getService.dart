import 'package:esoptron_salon/models/api_request.dart';
import 'package:esoptron_salon/models/api_response.dart';
import 'package:esoptron_salon/providers/contentProvisionProviders.dart';
import 'package:esoptron_salon/repositories/category.dart';
import 'package:esoptron_salon/repositories/getService.dart';
import 'package:esoptron_salon/repositories/getSubCategories.dart';
import 'package:esoptron_salon/services/category.dart';
import 'package:esoptron_salon/services/getServices.dart';
import 'package:esoptron_salon/services/getSubCategories.dart';
import 'package:esoptron_salon/states/global_state.dart';
import 'package:esoptron_salon/utils/enums/global_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ServicesRepositoryProvider = Provider<GetServicesRepository>((ref) {
  return GetServices();
});

final servicesProvider =
    StateNotifierProvider<ServicesNotifier, AppState<ApiResponseModel>>((ref) {
  return ServicesNotifier(ref.watch(ServicesRepositoryProvider), ref);
});

class ServicesNotifier extends StateNotifier<AppState<ApiResponseModel>> {
  final GetServicesRepository repository;
  StateNotifierProviderRef<ServicesNotifier, AppState<ApiResponseModel>> ref;
  ServicesNotifier(
    this.repository,
    this.ref,
  ) : super(AppState(status: Status.initial)) {
    _getServices();
  }
  _getServices() async {
    final id = ref.watch(getServiceIdProvider);
    state = AppState(status: Status.loading);
    final data =
        await repository.getServices(APIRequestModel(data: {"data": id}));
    data.fold((l) => state = AppState(status: Status.error, errorMessage: l),
        (r) => state = AppState(status: Status.loaded, data: r));
  }
}
