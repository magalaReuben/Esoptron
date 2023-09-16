import 'package:esoptron_salon/models/api_request.dart';
import 'package:esoptron_salon/models/api_response.dart';
import 'package:esoptron_salon/repositories/category.dart';
import 'package:esoptron_salon/services/category.dart';
import 'package:esoptron_salon/states/global_state.dart';
import 'package:esoptron_salon/utils/enums/global_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryService();
});

final categoriesProvider =
    StateNotifierProvider<CategoryNotifier, AppState<ApiResponseModel>>((ref) {
  return CategoryNotifier(ref.watch(_categoryRepositoryProvider), ref);
});

class CategoryNotifier extends StateNotifier<AppState<ApiResponseModel>> {
  final CategoryRepository repository;
  StateNotifierProviderRef<CategoryNotifier, AppState<ApiResponseModel>> ref;
  CategoryNotifier(
    this.repository,
    this.ref,
  ) : super(AppState(status: Status.initial)) {
    _getCategories();
  }
  _getCategories() async {
    //final countryDevice = ref.watch(countryAndDeviceProvider);
    state = AppState(status: Status.loading);
    final data = await repository.getCategories(APIRequestModel());
    data.fold((l) => state = AppState(status: Status.error, errorMessage: l),
        (r) => state = AppState(status: Status.loaded, data: r));
  }
}
