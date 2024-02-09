import 'package:flutter/material.dart';
import 'package:map_location_picker/map_location_picker.dart';

class LocationSelection extends StatefulWidget {
  static String routeName = 'locationSelection';
  const LocationSelection({super.key});

  @override
  State<LocationSelection> createState() => _LocationSelectionState();
}

class _LocationSelectionState extends State<LocationSelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapLocationPicker(apiKey: apiKey),
    );
  }
}
