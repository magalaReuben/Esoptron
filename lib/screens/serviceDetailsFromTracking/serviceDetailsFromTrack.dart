import 'dart:convert';
import 'package:background_location/background_location.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/providers/contentProvisionProviders.dart';
import 'package:esoptron_salon/services/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
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
  Future<List<dynamic>> getServiceDetails() async {
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
            "http://admin.esoptronsalon.com/api/bookings/${bookedServiceIds[bookedServiceIds.length - 1]['id']}/details"),
        headers: {
          'Authorization': 'Bearer $authorizationToken',
          'Content-Type':
              'application/json', // You may need to adjust the content type based on your API requirements
        },
      );
      // print(LatestbookingDetailsResponse.body);
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor.withOpacity(0.8),
        title: Text("Service Details",
            style: GoogleFonts.nunitoSans(
              fontSize: getProportionateScreenWidth(18),
              color: Colors.white,
              fontWeight: FontWeight.w600,
            )),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getServiceDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data!.isEmpty) {
              return const Center(child: Text("No Service Booked Yet"));
            }
            print(snapshot.data![0]['service'][0]);
            return SingleChildScrollView(
              child: Column(children: [
                SizedBox(height: getProportionateScreenHeight(5)),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Service Provider Details",
                          style: GoogleFonts.nunitoSans(
                            fontSize: getProportionateScreenWidth(18),
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Container(
                        height: getProportionateScreenHeight(110),
                        width: getProportionateScreenWidth(350),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white.withOpacity(0.6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                child: Image(
                                    height: 200,
                                    width: 100,
                                    image: NetworkImage(
                                        "http://admin.esoptronsalon.com/storage/services/${snapshot.data![0]['service'][0]['logo']}"),
                                    fit: BoxFit.cover),
                              ),
                              SizedBox(
                                width: getProportionateScreenWidth(10),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${snapshot.data![0]['service'][0]['name']}',
                                    style: GoogleFonts.nunitoSans(
                                        textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: getProportionateScreenWidth(18),
                                      fontWeight: FontWeight.w500,
                                    )),
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(5),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        "Description",
                        style: GoogleFonts.nunitoSans(
                          fontSize: getProportionateScreenWidth(18),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                          "${snapshot.data![0]['service'][0]['description']}",
                          style: GoogleFonts.nunitoSans(
                            fontSize: getProportionateScreenWidth(15),
                            color: Colors.black.withOpacity(0.9),
                            fontWeight: FontWeight.bold,
                          )),
                      // subtitle: Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Text("${snapshot.data![0]['address']}"),
                      //     Text(
                      //       "${snapshot.data![0]['time']}",
                      //       style: const TextStyle(
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Service Details",
                          style: GoogleFonts.nunitoSans(
                            fontSize: getProportionateScreenWidth(18),
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ],
                ),
                for (int i = 0;
                    i < snapshot.data![0]['sub_categories'].length;
                    i++)
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Container(
                          height: getProportionateScreenHeight(125),
                          width: getProportionateScreenWidth(350),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white.withOpacity(0.6),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  child: Image(
                                      height: 200,
                                      width: 100,
                                      image: NetworkImage(
                                          "http://admin.esoptronsalon.com/storage/sub_categories/${snapshot.data![0]['sub_categories'][i]['image']}"),
                                      fit: BoxFit.cover),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(10),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: getProportionateScreenWidth(200),
                                      child: Text(
                                        '${snapshot.data![0]['sub_categories'][i]['name']} \n UGX ${snapshot.data![0]['sub_categories'][i]['charge'].toString()}',
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize:
                                              getProportionateScreenWidth(18),
                                          fontWeight: FontWeight.w500,
                                        )),
                                      ),
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(5),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ))
              ]),
            );
          } else {
            // You can return a placeholder or loading indicator while the image is loading
            return Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(95)),
                const Center(child: CircularProgressIndicator()),
              ],
            );
          }
        },
      ),
    );
  }
}
