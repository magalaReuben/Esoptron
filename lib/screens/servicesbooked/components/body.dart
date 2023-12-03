import 'dart:convert';

import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future<List<dynamic>> getServiceBookedDetails() async {
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
          "status": responseBody['data']['status'],
          'service': responseBody['data']['service'],
          'sub_categories': responseBody['data']['sub_categories']
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
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Services Booked",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(20),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'krona'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Divider(
              color: Colors.black.withOpacity(0.9),
              thickness: 1.5,
            ),
          ),
          FutureBuilder<List<dynamic>>(
            future: getServiceBookedDetails(),
            builder: (context, snapshot) {
              print(snapshot);
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Add More",
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: getProportionateScreenWidth(15),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'krona'),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.add_circle_outline,
                                  size: 20, color: kPrimaryColor),
                            )
                          ],
                        ),
                      ),
                      for (int i = 0; i < snapshot.data!.length; i++)
                        serviceBoooked(
                            "${snapshot.data![i]['sub_categories']['name']}",
                            "${snapshot.data![i]['status']}",
                            "${snapshot.data![i]['sub_categories']['charge']}",
                            "${snapshot.data![i]['sub_categories']['logo']}")
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Add More",
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: getProportionateScreenWidth(15),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'krona'),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.add_circle_outline,
                                  size: 20, color: kPrimaryColor),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                }
              } else {
                // You can return a placeholder or loading indicator while the image is loading
                return const CircularProgressIndicator();
              }
            },
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 8, right: 8),
          //   child: Divider(
          //     color: Colors.black.withOpacity(0.9),
          //     thickness: 1.5,
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     children: [
          //       Text(
          //         "Service Provider",
          //         style: TextStyle(
          //             color: Colors.black,
          //             fontSize: getProportionateScreenWidth(17),
          //             fontWeight: FontWeight.bold,
          //             fontFamily: 'krona'),
          //       ),
          //     ],
          //   ),
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     serviceProvider('assets/images/servicesBooked/chinoso.png',
          //         "Chinoso", "Kampala,6th street"),
          //     serviceProvider('assets/images/servicesBooked/wonder.png',
          //         "Wonder", "Masindi,6th street"),
          //   ],
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     Text(
          //       "Change Specialist",
          //       style: TextStyle(
          //           decoration: TextDecoration.underline,
          //           color: kPrimaryColor,
          //           fontSize: getProportionateScreenWidth(17),
          //           fontWeight: FontWeight.bold,
          //           fontFamily: 'krona'),
          //     ),
          //   ],
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 8, right: 8),
          //   child: Divider(
          //     color: Colors.black.withOpacity(0.9),
          //     thickness: 1.5,
          //   ),
          // ),
        ],
      ),
    );
  }

  Padding serviceProvider(String image, String name, String location) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      child: SizedBox(
        width: getProportionateScreenWidth(130),
        height: getProportionateScreenHeight(210),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 30,
                foregroundImage: AssetImage(image),
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(5)),
            Text(
              name,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionateScreenWidth(17),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'krona'),
            ),
            SizedBox(height: getProportionateScreenHeight(5)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_pin,
                  size: 15,
                  color: kPrimaryColor,
                ),
                Text(
                  location,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(13),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'krona'),
                ),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.phone,
                    size: 15,
                    color: kPrimaryColor,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.chat,
                    size: 15,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Padding serviceBoooked(
      String title, String subTitle, String price, String image) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        trailing:
            const Icon(Icons.favorite_outline, color: kPrimaryColor, size: 25),
        tileColor: Colors.transparent,
        subtitle: Row(
          children: [
            Text(
              "\$$price",
              style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: getProportionateScreenWidth(18),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'krona'),
            ),
            Text(
              subTitle,
              style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: getProportionateScreenWidth(18),
                  fontWeight: FontWeight.normal,
                  fontFamily: 'krona'),
            ),
          ],
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            title,
            style: TextStyle(
                color: Colors.black,
                fontSize: getProportionateScreenWidth(15),
                fontWeight: FontWeight.bold,
                fontFamily: 'krona'),
          ),
        ),
        leading: Image(
            height: 120,
            width: 120,
            image:
                NetworkImage("http://admin.esoptronsalon.com/storage/$image"),
            fit: BoxFit.cover),
      ),
    );
  }
}
