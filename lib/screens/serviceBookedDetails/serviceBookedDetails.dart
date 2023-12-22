import 'dart:convert';

import 'package:background_location/background_location.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/providers/contentProvisionProviders.dart';
import 'package:esoptron_salon/services/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ServiceBookedDetails extends ConsumerStatefulWidget {
  static String routeName = "/serviceBookedDetails";
  const ServiceBookedDetails({super.key});

  @override
  ConsumerState<ServiceBookedDetails> createState() =>
      _ServiceBookedDetailsState();
}

class _ServiceBookedDetailsState extends ConsumerState<ServiceBookedDetails> {
  Future<List<dynamic>> bookingAction(
      action, id, context, latitude, longitude, ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authorizationToken = prefs.getString("auth_token");
    final response = await http.post(
      action == "accept"
          ? Uri.parse("http://admin.esoptronsalon.com/api/bookings/$id/accept")
          : Uri.parse("http://admin.esoptronsalon.com/api/bookings/$id/reject"),
      headers: {
        'Authorization': 'Bearer $authorizationToken',
        'Content-Type':
            'application/json', // You may need to adjust the content type based on your API requirements
      },
    );
    print(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseData = json.decode(response.body);
      if (responseData['success'] == true &&
          responseData['message'] == 'Booking has been accepted') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("${responseData['message']}"),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Your Location will be tracked"),
                ],
              )
            ],
          ),
          backgroundColor: Colors.green,
        ));
        // try {
        //   ref.read(destinationMarkerProvider).state = Marker(
        //     markerId: const MarkerId("destination"),
        //     icon: BitmapDescriptor.defaultMarkerWithHue(
        //         BitmapDescriptor.hueViolet),
        //     position: LatLng(latitude, longitude),
        //     infoWindow: const InfoWindow(title: "Destination"),
        //   );
        // } catch (e) {
        //   print(e.toString());
        //   debugPrint(e.toString());
        // }
        await startLocationTracking();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${responseData['message']}"),
          backgroundColor: Colors.red,
        ));
        BackgroundLocation.stopLocationService();
      }
      return [];
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something went wrong"),
        backgroundColor: Colors.red,
      ));
      return [];
    }
  }

  Future<String> getAddressFromLatLng(latitude, longitude) async {
    String currentAddress = await placemarkFromCoordinates(latitude, longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      String currentAddress =
          '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      return currentAddress;
    }).catchError((e) {
      debugPrint(e);
      return "Something went wrong";
    });
    return currentAddress;
  }

  Future<void> startLocationTracking() async {
    final hasPermission =
        await LocationService.handleLocationPermission(context);
    if (!hasPermission) return;
    BackgroundLocation.setAndroidNotification(
      title: "Location Tracking",
      message: "Notification message",
      icon: "@mipmap/ic_launcher",
    );
    BackgroundLocation.setAndroidConfiguration(10000);
    BackgroundLocation.startLocationService();
    BackgroundLocation.getLocationUpdates((location) async {
      String currentAddress =
          await getAddressFromLatLng(location.latitude, location.longitude);
      updateLocationTracking(
          currentAddress, location.latitude, location.longitude);
    });
  }

  Future<void> updateLocationTracking(
      currentAdress, latitude, longitude) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authorizationToken = prefs.getString("auth_token");
    int? id = prefs.getInt("userId");
    final data = jsonEncode({
      "latitude": latitude,
      "longitude": longitude,
      "address_name": currentAdress
    });
    final response = await http.post(
      Uri.parse(
          "http://admin.esoptronsalon.com/api/users/service_provider/update-location/$id"),
      body: data,
      headers: {
        'Authorization': 'Bearer $authorizationToken',
        'Content-Type':
            'application/json', // You may need to adjust the content type based on your API requirements
      },
    );
    //print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    dynamic data = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Service Booked Details"),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(height: getProportionateScreenHeight(5)),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text("Customer Details",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'http://admin.esoptronsalon.com/${data['customer']['avatar']}')),
                title: Text("${data['customer']['name']}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${data['address']}"),
                    Text(
                      "${data['time']}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Categories Details",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ],
          ),
          for (int i = 0; i < data['sub_categories'].length; i++)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'http://admin.esoptronsalon.com/storage/sub_categories/${data['sub_categories'][i]['image']}')),
                  title: Text("${data['sub_categories'][i]['name']}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${data['sub_categories'][i]['description']}"),
                      Text(
                        "${data['sub_categories'][i]['charge']}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () => bookingAction("accept", data['id'],
                        context, data['latitude'], data['longitude'], ref),
                    child: const Text("Accept")),
                SizedBox(
                  width: getProportionateScreenWidth(15),
                ),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () => bookingAction("reject", data['id'],
                        context, data['latitude'], data['longitude'], ref),
                    child: const Text("Reject"))
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
