import 'package:esoptron_salon/models/api_request.dart';
import 'package:esoptron_salon/models/api_response.dart';
import 'package:esoptron_salon/providers/contentProvisionProviders.dart';
import 'package:esoptron_salon/repositories/getCategoriesUnderService.dart';
import 'package:esoptron_salon/services/getCategoriesUnderService.dart';
import 'package:esoptron_salon/states/global_state.dart';
import 'package:esoptron_salon/utils/enums/global_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _getCategoriesUnderServiceProvider =
    Provider<GetCategoriesUnderServiceRepository>((ref) {
  return GetCategoriesUnderService();
});

final getCategoriesUnderServiceProvider = StateNotifierProvider<
    GetCategoriesUnderServiceNotifier, AppState<ApiResponseModel>>((ref) {
  return GetCategoriesUnderServiceNotifier(
      ref.watch(_getCategoriesUnderServiceProvider), ref);
});

class GetCategoriesUnderServiceNotifier
    extends StateNotifier<AppState<ApiResponseModel>> {
  final GetCategoriesUnderServiceRepository repository;
  StateNotifierProviderRef<GetCategoriesUnderServiceNotifier,
      AppState<ApiResponseModel>> ref;

  GetCategoriesUnderServiceNotifier(this.repository, this.ref)
      : super(AppState(status: Status.initial)) {
    getCategoriesUnderService();
  }

  getCategoriesUnderService() async {
    final id = ref.watch(categoriesUnderServiceIdProvider);
    state = AppState(status: Status.loading);
    final data = await repository
        .getCategoriesUnderService(APIRequestModel(data: {"data": id}));
    data.fold((l) => state = AppState(status: Status.error, errorMessage: l),
        (r) => state = AppState(status: Status.loaded, data: r));
  }
}
