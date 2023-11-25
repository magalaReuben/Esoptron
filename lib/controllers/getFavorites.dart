import 'package:esoptron_salon/models/api_request.dart';
import 'package:esoptron_salon/models/api_response.dart';
import 'package:esoptron_salon/repositories/category.dart';
import 'package:esoptron_salon/repositories/favorites.dart';
import 'package:esoptron_salon/services/category.dart';
import 'package:esoptron_salon/services/getFavorites.dart';
import 'package:esoptron_salon/states/global_state.dart';
import 'package:esoptron_salon/utils/enums/global_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesService();
});

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, AppState<ApiResponseModel>>((ref) {
  return FavoritesNotifier(ref.watch(_favoritesRepositoryProvider), ref);
});

class FavoritesNotifier extends StateNotifier<AppState<ApiResponseModel>> {
  final FavoritesRepository repository;
  StateNotifierProviderRef<FavoritesNotifier, AppState<ApiResponseModel>> ref;
  FavoritesNotifier(
    this.repository,
    this.ref,
  ) : super(AppState(status: Status.initial)) {
    _getFavorites();
  }
  _getFavorites() async {
    //final countryDevice = ref.watch(countryAndDeviceProvider);
    state = AppState(status: Status.loading);
    final data = await repository.getFavorites(APIRequestModel());
    data.fold((l) => state = AppState(status: Status.error, errorMessage: l),
        (r) => state = AppState(status: Status.loaded, data: r));
  }
}
