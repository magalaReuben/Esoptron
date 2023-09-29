import 'dart:async';

import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Body extends ConsumerStatefulWidget {
  const Body({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BodyState createState() => _BodyState();
}

class _BodyState extends ConsumerState<Body> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  bool selected1 = true;
  bool selected2 = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        SizedBox(
          height: getProportionateScreenHeight(250),
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
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
                      Text("Tracking Number",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(17),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'krona')),
                      SizedBox(
                        width: getProportionateScreenWidth(70),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset("assets/images/track/trackIcon.png"),
                      SizedBox(
                        width: getProportionateScreenWidth(13),
                      ),
                      Text("R-7458-4567-4434-5854",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(15),
                              fontWeight: FontWeight.normal,
                              fontFamily: 'krona'))
                    ],
                  )
                ],
              ),
              ElevatedButton(
                  onPressed: () {}, child: const Text("Service Details"))
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
