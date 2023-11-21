import 'package:esoptron_salon/models/api_request.dart';
import 'package:esoptron_salon/models/api_response.dart';
import 'package:esoptron_salon/providers/contentProvisionProviders.dart';
import 'package:esoptron_salon/repositories/category.dart';
import 'package:esoptron_salon/repositories/getSubCategories.dart';
import 'package:esoptron_salon/services/category.dart';
import 'package:esoptron_salon/services/getSubCategories.dart';
import 'package:esoptron_salon/states/global_state.dart';
import 'package:esoptron_salon/utils/enums/global_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _subCategoryRepositoryProvider =
    Provider<GetSubCategoriesRepository>((ref) {
  return GetSubCategoryService();
});

final subCategoriesProvider =
    StateNotifierProvider<SubCategoryNotifier, AppState<ApiResponseModel>>(
        (ref) {
  return SubCategoryNotifier(ref.watch(_subCategoryRepositoryProvider), ref);
});

class SubCategoryNotifier extends StateNotifier<AppState<ApiResponseModel>> {
  final GetSubCategoriesRepository repository;
  StateNotifierProviderRef<SubCategoryNotifier, AppState<ApiResponseModel>> ref;
  SubCategoryNotifier(
    this.repository,
    this.ref,
  ) : super(AppState(status: Status.initial)) {
    _getsubCategories();
  }
  _getsubCategories() async {
    final id = ref.watch(subCategoriesIdProvider);
    state = AppState(status: Status.loading);
    final data =
        await repository.getSubCategories(APIRequestModel(data: {"data": id}));
    data.fold((l) => state = AppState(status: Status.error, errorMessage: l),
        (r) => state = AppState(status: Status.loaded, data: r));
  }
}
