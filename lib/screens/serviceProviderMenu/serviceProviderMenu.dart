import 'dart:convert';
import 'dart:developer';

import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/screens/serviceBookedDetails/serviceBookedDetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ServiceProviderMenu extends StatefulWidget {
  const ServiceProviderMenu({super.key});

  @override
  State<ServiceProviderMenu> createState() => _ServiceProviderMenuState();
}

class _ServiceProviderMenuState extends State<ServiceProviderMenu> {
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
    for (var element in responseBody['data']['bookings']) {
      bookedServiceIds.add(element['id']);
    }
    for (var id in bookedServiceIds) {
      final bookingDetailsResponse = await http.get(
        Uri.parse("http://admin.esoptronsalon.com/api/bookings/$id/details"),
        headers: {
          'Authorization': 'Bearer $authorizationToken',
          'Content-Type':
              'application/json', // You may need to adjust the content type based on your API requirements
        },
      );
      if (bookingDetailsResponse.statusCode >= 200 &&
          bookingDetailsResponse.statusCode < 300) {
        final responseBody = json.decode(bookingDetailsResponse.body);
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
  initState() {
    getBookings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Bookings"),
          backgroundColor: kPrimaryColor,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PopupMenuButton<int>(
                child: const Icon(Icons.more_horiz),
                itemBuilder: (context) => [
                  // PopupMenuItem 1
                  const PopupMenuItem(
                    value: 1,
                    // row with 2 children
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text("Schedules")
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder<List<dynamic>>(
                  future: getBookings(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            //log(snapshot.data![index].toString());
                            return GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                  context, ServiceBookedDetails.routeName,
                                  arguments: snapshot.data![index]),
                              child: Card(
                                elevation: 1,
                                child: ListTile(
                                  leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          'http://admin.esoptronsalon.com/${snapshot.data![index]['customer']['avatar']}')),
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(snapshot.data![index]['customer']
                                          ['name']),
                                      Chip(
                                          label: Text(
                                            snapshot.data![index]['status'],
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          backgroundColor: kPrimaryColor),
                                    ],
                                  ),
                                  subtitle: Text(snapshot.data![index]
                                          ['address']
                                      .toString()),
                                ),
                              ),
                            );
                          });
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: getProportionateScreenHeight(30),
                        ),
                        const Center(child: CircularProgressIndicator()),
                      ],
                    );
                  },
                ),
                // Card(
                //   elevation: 1,
                //   child: ListTile(
                //     leading: const CircleAvatar(
                //         backgroundImage: NetworkImage(
                //             'http://admin.esoptronsalon.com/storage/users/user.png')),
                //     title: const Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Text("Miss Seven"),
                //         Padding(
                //           padding: EdgeInsets.only(left: 8.0, right: 8.0),
                //           child: Chip(
                //               label: Text(
                //                 "10:00 AM",
                //                 style: TextStyle(color: Colors.white),
                //               ),
                //               backgroundColor: kPrimaryColor),
                //         ),
                //       ],
                //     ),
                //     subtitle: Column(
                //       children: [
                //         const Row(
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           children: [
                //             Text("ButterFly Braids"),
                //           ],
                //         ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     ElevatedButton(
                //         style: ElevatedButton.styleFrom(
                //             backgroundColor: Colors.green),
                //         onPressed: () => null,
                //         child: const Text("Accept")),
                //     SizedBox(
                //       width: getProportionateScreenWidth(15),
                //     ),
                //     ElevatedButton(
                //         style: ElevatedButton.styleFrom(
                //             backgroundColor: Colors.red),
                //         onPressed: () => null,
                //         child: const Text("Reject"))
                //   ],
                // ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ));
  }
}
