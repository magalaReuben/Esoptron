import 'dart:async';

import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/providers/contentProvisionProviders.dart';
import 'package:esoptron_salon/screens/serviceDetailsFromTracking/serviceDetailsFromTrack.dart';
import 'package:esoptron_salon/services/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Body extends ConsumerStatefulWidget {
  const Body({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BodyState createState() => _BodyState();
}

class _BodyState extends ConsumerState<Body> {
  String? _currentAddress;
  Position? _currentPosition;
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    getCurrentPosition();
  }

  Future<void> getCurrentPosition() async {
    final hasPermission =
        await LocationService.handleLocationPermission(context);
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      setState(() {
        _latitude = _currentPosition!.latitude;
        _longitude = _currentPosition!.longitude;
      });
      getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
      print(_currentAddress);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Marker? _origin;

  bool selected1 = true;
  bool selected2 = false;

  @override
  void dispose() {
    _controller.future.then((value) => value.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _destination = ref.watch(destinationMarkerProvider);
    Marker _origin = Marker(
      markerId: const MarkerId("origin"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: LatLng(_latitude!, _longitude!),
      infoWindow: const InfoWindow(title: "Origin"),
    );
    return SingleChildScrollView(
      child: Column(children: [
        SizedBox(
          height: getProportionateScreenHeight(350),
          child: _latitude == null || _longitude == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(_latitude!, _longitude!),
                    zoom: 14.4746,
                  ),
                  markers: {
                    _origin,
                  },
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Text("Tracking Number",
                      //     style: TextStyle(
                      //         color: Colors.black,
                      //         fontSize: getProportionateScreenWidth(17),
                      //         fontWeight: FontWeight.bold,
                      //         fontFamily: 'krona')),
                      SizedBox(
                        width: getProportionateScreenWidth(70),
                      )
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Image.asset("assets/images/track/trackIcon.png"),
                  //     SizedBox(
                  //       width: getProportionateScreenWidth(13),
                  //     ),
                  //     Text("R-7458-4567-4434-5854",
                  //         style: TextStyle(
                  //             color: Colors.black,
                  //             fontSize: getProportionateScreenWidth(15),
                  //             fontWeight: FontWeight.normal,
                  //             fontFamily: 'krona'))
                  //   ],
                  // )
                ],
              ),
              ElevatedButton(
                  onPressed: () => Navigator.pushNamed(
                      context, ServiceDetailsFromTracking.routeName),
                  child: const Text("Service Details"))
            ],
          ),
        ),
        //SizedBox(height: getProportionateScreenHeight(10)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Package Status",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(17),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'krona')),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                    value: selected1,
                    onChanged: (bool? value) {
                      setState(() {
                        selected1 = value!;
                      });
                    }),
                Image.asset(
                  "assets/images/serviceBooking/Line.png",
                  height: getProportionateScreenHeight(30),
                ),
                Checkbox(
                    value: selected1,
                    onChanged: (bool? value) {
                      setState(() {
                        selected1 = value!;
                      });
                    }),
                Image.asset(
                  "assets/images/serviceBooking/Line.png",
                  height: getProportionateScreenHeight(30),
                ),
                Checkbox(
                    value: selected2,
                    onChanged: (bool? value) {
                      setState(() {
                        selected2 = value!;
                      });
                    }),
                Image.asset(
                  "assets/images/serviceBooking/Line.png",
                  height: getProportionateScreenHeight(30),
                ),
                Checkbox(
                    value: selected2,
                    onChanged: (bool? value) {
                      setState(() {
                        selected2 = value!;
                      });
                    }),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Service requested",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: getProportionateScreenWidth(17)),
                  ),
                ),
                Text(
                  "July 7 2022 08:00am",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: getProportionateScreenWidth(16)),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Service read by",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: getProportionateScreenWidth(17)),
                  ),
                ),
                Text(
                  "July 7 2022 08:30am",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: getProportionateScreenWidth(16)),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Service on the way",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: getProportionateScreenWidth(17)),
                  ),
                ),
                Text(
                  "July 7 2022 10:30am",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: getProportionateScreenWidth(16)),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Service Arrives",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: getProportionateScreenWidth(17)),
                  ),
                ),
                Text(
                  "July 7 2022 10:35am",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: getProportionateScreenWidth(16)),
                ),
              ],
            )
          ],
        )
      ]),
    );
  }
}
