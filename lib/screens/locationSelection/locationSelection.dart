import 'package:esoptron_salon/utils/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationSelection extends ConsumerStatefulWidget {
  static String routeName = 'locationSelection';
  const LocationSelection({super.key});

  @override
  ConsumerState<LocationSelection> createState() => _LocationSelectionState();
}

class _LocationSelectionState extends ConsumerState<LocationSelection> {
  @override
  Widget build(BuildContext context) {
    return Container();
    // return PlacePicker(
    //   hintText: 'Search Location',
    //   apiKey: ENV.googleMapsApiKey,
    //   onPlacePicked: (result) {
    //     Navigator.of(context).pop();
    //   },
    //   initialPosition: const LatLng(0.347596, 32.582520),
    //   useCurrentLocation: true,
    //   resizeToAvoidBottomInset:
    //       false, // only works in page mode, less flickery, remove if wrong offsets
    // );
  }
}
