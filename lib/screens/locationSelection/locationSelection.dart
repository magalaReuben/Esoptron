import 'package:esoptron_salon/utils/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';

class LocationSelection extends ConsumerStatefulWidget {
  static String routeName = 'locationSelection';
  const LocationSelection({super.key});

  @override
  ConsumerState<LocationSelection> createState() => _LocationSelectionState();
}

class _LocationSelectionState extends ConsumerState<LocationSelection> {
  @override
  Widget build(BuildContext context) {
    return PlacePicker(
      hintText: 'Search Location',
      apiKey: ENV.googleMapsApiKey,
      onPlacePicked: (result) {
        print(result);
        Navigator.of(context).pop();
      },
      initialPosition: LatLng(37.77483, -122.41942),
      useCurrentLocation: true,
      resizeToAvoidBottomInset:
          false, // only works in page mode, less flickery, remove if wrong offsets
    );
  }
}
