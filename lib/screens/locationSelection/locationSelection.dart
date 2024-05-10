import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/utils/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_location_picker/map_location_picker.dart';

class LocationSelection extends ConsumerStatefulWidget {
  static String routeName = 'locationSelection';
  const LocationSelection({super.key});

  @override
  ConsumerState<LocationSelection> createState() => _LocationSelectionState();
}

class _LocationSelectionState extends ConsumerState<LocationSelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: kPrimaryColor.withOpacity(0.8),
            title: Text("Select Location",
                style: GoogleFonts.nunitoSans(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: getProportionateScreenWidth(20),
                    fontWeight: FontWeight.w400,
                  ),
                ))),
        body: MapLocationPicker(
          apiKey: ENV.googleMapsApiKey,
          onNext: (GeocodingResult? result) {
            print(result);
          },
        ));
  }
}
