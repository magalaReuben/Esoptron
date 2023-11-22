import 'package:esoptron_salon/models/api_request.dart';
import 'package:esoptron_salon/models/api_response.dart';
import 'package:esoptron_salon/providers/contentProvisionProviders.dart';
import 'package:esoptron_salon/repositories/category.dart';
import 'package:esoptron_salon/repositories/getSubCategories.dart';
import 'package:esoptron_salon/repositories/seerviceProviderDetails.dart';
import 'package:esoptron_salon/services/category.dart';
import 'package:esoptron_salon/services/getSubCategories.dart';
import 'package:esoptron_salon/services/serviceProviderDetails.dart';
import 'package:esoptron_salon/states/global_state.dart';
import 'package:esoptron_salon/utils/enums/global_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _serviceProviderDetailsRepositoryProvider =
    Provider<ServiceProviderDetailsRepository>((ref) {
  return GetServiceProviderDetails();
});

final serviceProviderDetailsProvider = StateNotifierProvider<
    ServiceProviderDetailsNotifier, AppState<ApiResponseModel>>((ref) {
  return ServiceProviderDetailsNotifier(
      ref.watch(_serviceProviderDetailsRepositoryProvider), ref);
});

class ServiceProviderDetailsNotifier
    extends StateNotifier<AppState<ApiResponseModel>> {
  final ServiceProviderDetailsRepository repository;
  StateNotifierProviderRef<ServiceProviderDetailsNotifier,
      AppState<ApiResponseModel>> ref;
  ServiceProviderDetailsNotifier(
    this.repository,
    this.ref,
  ) : super(AppState(status: Status.initial)) {
    _getserviceProviderDetails();
  }
  _getserviceProviderDetails() async {
    final id = ref.watch(getServiceProviderDetailsIdProvider);
    state = AppState(status: Status.loading);
    final data = await repository
        .getServiceProviderDetails(APIRequestModel(data: {"data": id}));
    data.fold((l) => state = AppState(status: Status.error, errorMessage: l),
        (r) => state = AppState(status: Status.loaded, data: r));
  }
}
