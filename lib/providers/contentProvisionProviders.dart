import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final categoriesUnderServiceIdProvider = StateProvider<int?>((ref) => null);

final subCategoriesIdProvider = StateProvider<int?>((ref) => null);

final getServiceIdProvider = StateProvider<int?>((ref) => null);

final getServiceProviderDetailsIdProvider = StateProvider<int?>((ref) => null);

final destinationMarkerProvider = StateProvider<Marker?>((ref) => null);
