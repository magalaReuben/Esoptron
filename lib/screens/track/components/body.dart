import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/providers/contentProvisionProviders.dart';
import 'package:esoptron_salon/screens/serviceDetailsFromTracking/serviceDetailsFromTrack.dart';
import 'package:esoptron_salon/services/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String? type;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Marker? _origin;

  bool serviceRequested = false;
  bool serviceRead = false;
  bool serviceOnTheWay = false;
  bool serviceArrived = false;
  bool serviceRejected = false;

  bool noServiceRequested = false;

  @override
  void initState() {
    super.initState();
    getUserType().then((value) => type = value);
    type == "ServiceProvider" ? null : getPackageStatus();
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

  Future<String> getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? type = prefs.getString("type");
    return type!;
  }

  Future<void> getPackageStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authorizationToken = prefs.getString("auth_token");
    final bookingResponse = await http.get(
      Uri.parse("http://admin.esoptronsalon.com/api/bookings/all"),
      headers: {
        'Authorization': 'Bearer $authorizationToken',
        'Content-Type':
            'application/json', // You may need to adjust the content type based on your API requirements
      },
    );
    final bookingsResponseBody = json.decode(bookingResponse.body);
    if (bookingsResponseBody['success']) {
      final response = await http.post(
        Uri.parse(
            "http://admin.esoptronsalon.com/api/users/service_provider/track_booking/${bookingsResponseBody['data']['bookings'][bookingsResponseBody['data']['bookings'].length - 1]['id']}"),
        headers: {
          'Authorization': 'Bearer $authorizationToken',
          'Content-Type':
              'application/json', // You may need to adjust the content type based on your API requirements
        },
      );
      final responseBody = json.decode(response.body);
      if (true) {
        if (responseBody['message'].endsWith("pending")) {
          setState(() {
            serviceRequested = true;
          });
        } else if (responseBody['message'].endsWith("read")) {
          setState(() {
            serviceRequested = true;
            serviceRead = true;
          });
        } else if (responseBody['message'].endsWith("progress")) {
          setState(() {
            serviceRequested = true;
            serviceRead = true;
            serviceOnTheWay = true;
          });
        } else if (responseBody['message'].endsWith("arrived")) {
          setState(() {
            serviceRequested = true;
            serviceRead = true;
            serviceOnTheWay = true;
            serviceArrived = true;
          });
        } else if (responseBody['message'] == "The booking was rejected") {
          setState(() {
            serviceRejected = true;
          });
        }
      }
    } else {
      setState(() {
        noServiceRequested = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.future.then((value) => value.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _destinationProvider = ref.watch(destinationMarkerProvider);
    Marker _destination = _destinationProvider ??
        const Marker(markerId: MarkerId("destination-holder"));
    log("destination: $_destinationProvider");
    Marker _origin = _latitude == null || _longitude == null
        ? const Marker(markerId: MarkerId("origin"))
        : Marker(
            markerId: const MarkerId("origin"),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            position: LatLng(_latitude!, _longitude!),
            infoWindow: const InfoWindow(title: "Origin"),
          );
    return SingleChildScrollView(
      child: Column(children: [
        type == "ServiceProvider"
            ? SizedBox(
                height: getProportionateScreenHeight(500),
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
                          _destination,
                        },
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      ),
              )
            : Container(),
        noServiceRequested
            ? Container()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Column(
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     // Text("Tracking Number",
                        //     //     style: TextStyle(
                        //     //         color: Colors.black,
                        //     //         fontSize: getProportionateScreenWidth(17),
                        //     //         fontWeight: FontWeight.bold,
                        //     //         fontFamily: 'krona')),
                        //     SizedBox(
                        //       width: getProportionateScreenWidth(70),
                        //     )
                        //   ],
                        // ),
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
        type == "ServiceProvider"
            ? Container()
            : Padding(
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
        type == "ServiceProvider"
            ? Container()
            : serviceRejected
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Checkbox(
                              value: serviceRejected,
                              onChanged: (bool? value) {
                                // setState(() {
                                //    = value!;
                                // });
                              }),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Service Rejected",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: getProportionateScreenWidth(17)),
                            ),
                          ),
                          // Text(
                          //   "July 7 2022 08:00am",
                          //   style: TextStyle(
                          //       fontWeight: FontWeight.normal,
                          //       fontSize: getProportionateScreenWidth(16)),
                          // ),
                        ],
                      )
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                  activeColor: kPrimaryColor,
                                  value: serviceRequested,
                                  onChanged: (bool? value) {
                                    // setState(() {
                                    //    = value!;
                                    // });
                                  }),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Service requested",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          getProportionateScreenWidth(17)),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                "assets/images/serviceBooking/Line.png",
                                height: getProportionateScreenHeight(30),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                  activeColor: kPrimaryColor,
                                  value: serviceRead,
                                  onChanged: (bool? value) {
                                    // setState(() {
                                    //   selected1 = value!;
                                    // });
                                  }),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Service read",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          getProportionateScreenWidth(17)),
                                ),
                              ),
                              SizedBox(
                                width: getProportionateScreenWidth(45),
                              ),
                            ],
                          ),
                          Image.asset(
                            "assets/images/serviceBooking/Line.png",
                            height: getProportionateScreenHeight(30),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                  activeColor: kPrimaryColor,
                                  value: serviceOnTheWay,
                                  onChanged: (bool? value) {
                                    // setState(() {
                                    //   selected2 = value!;
                                    // });
                                  }),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Service on the way",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          getProportionateScreenWidth(17)),
                                ),
                              ),
                            ],
                          ),
                          Image.asset(
                            "assets/images/serviceBooking/Line.png",
                            height: getProportionateScreenHeight(30),
                          ),
                          Row(
                            children: [
                              Checkbox(
                                  activeColor: kPrimaryColor,
                                  value: serviceArrived,
                                  onChanged: (bool? value) {
                                    // setState(() {
                                    //   selected2 = value!;
                                    // });
                                  }),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Service Arrives",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          getProportionateScreenWidth(17)),
                                ),
                              ),
                              SizedBox(
                                width: getProportionateScreenWidth(15),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Column(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     // Padding(
                      //     //   padding: const EdgeInsets.all(8.0),
                      //     //   child: Text(
                      //     //     "Service requested",
                      //     //     style: TextStyle(
                      //     //         fontWeight: FontWeight.bold,
                      //     //         fontSize: getProportionateScreenWidth(17)),
                      //     //   ),
                      //     // ),
                      //     // Text(
                      //     //   "July 7 2022 08:00am",
                      //     //   style: TextStyle(
                      //     //       fontWeight: FontWeight.normal,
                      //     //       fontSize: getProportionateScreenWidth(16)),
                      //     // ),
                      //     SizedBox(
                      //       height: getProportionateScreenHeight(20),
                      //     ),
                      //     Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Text(
                      //         "Service read by",
                      //         style: TextStyle(
                      //             fontWeight: FontWeight.bold,
                      //             fontSize: getProportionateScreenWidth(17)),
                      //       ),
                      //     ),
                      //     // Text(
                      //     //   "July 7 2022 08:30am",
                      //     //   style: TextStyle(
                      //     //       fontWeight: FontWeight.normal,
                      //     //       fontSize: getProportionateScreenWidth(16)),
                      //     // ),
                      //     SizedBox(
                      //       height: getProportionateScreenHeight(20),
                      //     ),
                      //     // Padding(
                      //     //   padding: const EdgeInsets.all(8.0),
                      //     //   child: Text(
                      //     //     "Service on the way",
                      //     //     style: TextStyle(
                      //     //         fontWeight: FontWeight.bold,
                      //     //         fontSize: getProportionateScreenWidth(17)),
                      //     //   ),
                      //     // ),
                      //     // Text(
                      //     //   "July 7 2022 10:30am",
                      //     //   style: TextStyle(
                      //     //       fontWeight: FontWeight.normal,
                      //     //       fontSize: getProportionateScreenWidth(16)),
                      //     // ),
                      //     SizedBox(
                      //       height: getProportionateScreenHeight(20),
                      //     ),
                      //     Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Text(
                      //         "Service Arrives",
                      //         style: TextStyle(
                      //             fontWeight: FontWeight.bold,
                      //             fontSize: getProportionateScreenWidth(17)),
                      //       ),
                      //     ),
                      //     // Text(
                      //     //   "July 7 2022 10:35am",
                      //     //   style: TextStyle(
                      //     //       fontWeight: FontWeight.normal,
                      //     //       fontSize: getProportionateScreenWidth(16)),
                      //     // ),
                      //   ],
                      // )
                    ],
                  )
      ]),
    );
  }
}
