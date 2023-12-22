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

class ServiceDetailsFromTracking extends ConsumerStatefulWidget {
  static String routeName = "/ServiceDetailsFromTracking";
  const ServiceDetailsFromTracking({super.key});

  @override
  ConsumerState<ServiceDetailsFromTracking> createState() =>
      _ServiceDetailsFromTrackingState();
}

class _ServiceDetailsFromTrackingState
    extends ConsumerState<ServiceDetailsFromTracking> {
  Future<List<dynamic>> getBookings() async {
    List<dynamic> bookedServiceIds = [];
    List<dynamic> bookingDetails = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authorizationToken = prefs.getString("auth_token");
    final response = await http.get(
      Uri.parse("http://admin.esoptronsalon.com/api/bookings/all"),
      headers: {
        'Authorization': 'Bearer $authorizationToken',
        'Content-Type':
            'application/json', // You may need to adjust the content type based on your API requirements
      },
    );
    final responseBody = json.decode(response.body);
    if (responseBody['success'] == true) {
      for (var element in responseBody['data']['bookings']) {
        bookedServiceIds.add({
          "id": element['id'],
          "latitude": element['latitude'],
          "longitude": element['longitude']
        });
      }
      final LatestbookingDetailsResponse = await http.get(
        Uri.parse(
            "http://admin.esoptronsalon.com/api/bookings/${bookedServiceIds[bookedServiceIds.length - 1]}/details"),
        headers: {
          'Authorization': 'Bearer $authorizationToken',
          'Content-Type':
              'application/json', // You may need to adjust the content type based on your API requirements
        },
      );
      if (LatestbookingDetailsResponse.statusCode >= 200 &&
          LatestbookingDetailsResponse.statusCode < 300) {
        final responseBody = json.decode(LatestbookingDetailsResponse.body);
        bookingDetails.add({
          "id": responseBody['data']['id'],
          "status": responseBody['data']['status'],
          'service': responseBody['data']['service'],
          'sub_categories': responseBody['data']['sub_categories'],
          'customer': responseBody['data']['customer'],
          'address': responseBody['data']['address'],
          'time': responseBody['data']['time'],
        });
      } else {
        return [];
      }
    }
    if (bookingDetails.isNotEmpty) {
      return bookingDetails;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic data = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Service Details"),
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
        ]),
      ),
    );
  }
}
