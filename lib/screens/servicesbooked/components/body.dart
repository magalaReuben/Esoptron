import 'dart:convert';
import 'dart:developer';

import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<dynamic>? finalserviceProviders;
  Future<List<dynamic>> getServiceBookedDetails() async {
    List<dynamic> bookedServiceIds = [];
    List<dynamic> bookingDetails = [];
    List<dynamic> serviceProviders = [];
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
        //print(responseBody);
        bookingDetails.add({
          "status": responseBody['data']['status'],
          'service': responseBody['data']['service'],
          'sub_categories': responseBody['data']['sub_categories']
        });
      } else {
        return [];
      }
    }
    for (int i = 0; i < bookingDetails.length; i++) {
      if (!serviceProviders.contains(bookingDetails[i]['service'][0]['name'])) {
        if (bookingDetails[i]['service'][0]['name'] != null) {
          serviceProviders.add(bookingDetails[i]['service'][0]);
        }
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
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: kPrimaryColor.withOpacity(0.8),
              bottom: TabBar(
                  indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(
                      width: 3.0,
                      color: Colors.white,
                    ),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 3.0,
                  unselectedLabelColor: Colors.black,
                  labelColor: Colors.white,
                  isScrollable: true,
                  indicatorColor: Colors.transparent,
                  physics: const BouncingScrollPhysics(),
                  labelStyle: GoogleFonts.nunitoSans(
                    fontSize: getProportionateScreenWidth(17),
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: const [
                    Tab(text: "Accepted"),
                    Tab(text: 'Pending'),
                    Tab(text: 'Rejected')
                  ]),
            ),
            body: TabBarView(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Accepted Services",
                                style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: getProportionateScreenWidth(18),
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
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
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.isEmpty ||
                                  snapshot.data == null) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("No Accepted Services",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize:
                                              getProportionateScreenWidth(20),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'krona')),
                                );
                              }
                              bool hasAcceptedServices = snapshot.data!.any(
                                (element) => element['status'] == 'accepted',
                              );
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (int i = 0;
                                      i < snapshot.data!.length;
                                      i++)
                                    snapshot.data![i]['status'] == 'accepted'
                                        ? serviceBoooked(
                                            "${snapshot.data![i]['sub_categories'][0]['name']}",
                                            "${snapshot.data![i]['status']}",
                                            "${snapshot.data![i]['sub_categories'][0]['charge']}",
                                            "${snapshot.data![i]['sub_categories'][0]['image']}")
                                        : Container(),
                                  //check snapshot to see if it contains an element with status accepted
                                  hasAcceptedServices
                                      ? Container()
                                      : SizedBox(
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(14.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image(
                                                      width:
                                                          getProportionateScreenWidth(
                                                              100),
                                                      height:
                                                          getProportionateScreenHeight(
                                                              100),
                                                      image: const AssetImage(
                                                          "assets/images/home/nodata.png"),
                                                      fit: BoxFit.cover),
                                                  Text(
                                                    "No Accepted Services",
                                                    style:
                                                        GoogleFonts.nunitoSans(
                                                      textStyle:
                                                          const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(
                                  //       left: 8, right: 8),
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
                                  //             fontSize:
                                  //                 getProportionateScreenWidth(
                                  //                     17),
                                  //             fontWeight: FontWeight.bold,
                                  //             fontFamily: 'krona'),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  // SingleChildScrollView(
                                  //   scrollDirection: Axis.horizontal,
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.start,
                                  //     children: [
                                  //       for (int i = 0;
                                  //           i < snapshot.data!.length;
                                  //           i++)
                                  //         serviceProvider(
                                  //             '${snapshot.data![i]['service'][0]['logo']}',
                                  //             "${snapshot.data![i]['service'][0]['name']}",
                                  //             "Kampala,6th street"),
                                  //     ],
                                  //   ),
                                  // ),
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
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      15),
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
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Pending Services",
                                style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: getProportionateScreenWidth(18),
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
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
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              bool hasPendingServices = snapshot.data!.any(
                                (element) => element['status'] == 'pending',
                              );
                              return Column(
                                children: [
                                  for (int i = 0;
                                      i < snapshot.data!.length;
                                      i++)
                                    snapshot.data![i]['status'] == 'pending'
                                        ? serviceBoooked(
                                            "${snapshot.data![i]['sub_categories'][0]['name']}",
                                            "${snapshot.data![i]['status']}",
                                            "${snapshot.data![i]['sub_categories'][0]['charge']}",
                                            "${snapshot.data![i]['sub_categories'][0]['image']}")
                                        : Container(),
                                  hasPendingServices
                                      ? Container()
                                      : SizedBox(
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(14.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image(
                                                      width:
                                                          getProportionateScreenWidth(
                                                              100),
                                                      height:
                                                          getProportionateScreenHeight(
                                                              100),
                                                      image: const AssetImage(
                                                          "assets/images/home/nodata.png"),
                                                      fit: BoxFit.cover),
                                                  Text("No Pending Services",
                                                      style: GoogleFonts
                                                          .nunitoSans(
                                                        textStyle:
                                                            const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(
                                  //       left: 8, right: 8),
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
                                  //             fontSize:
                                  //                 getProportionateScreenWidth(
                                  //                     17),
                                  //             fontWeight: FontWeight.bold,
                                  //             fontFamily: 'krona'),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  // SingleChildScrollView(
                                  //   scrollDirection: Axis.horizontal,
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.start,
                                  //     children: [
                                  //       for (int i = 0;
                                  //           i < snapshot.data!.length;
                                  //           i++)
                                  //         serviceProvider(
                                  //             '${snapshot.data![i]['service'][0]['logo']}',
                                  //             "${snapshot.data![i]['service'][0]['name']}",
                                  //             "Kampala,6th street"),
                                  //     ],
                                  //   ),
                                  // ),
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
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      15),
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
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Rejected Services",
                                style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: getProportionateScreenWidth(18),
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
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
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              bool hasRejectedServices = snapshot.data!.any(
                                (element) => element['status'] == 'rejected',
                              );
                              return Column(
                                children: [
                                  for (int i = 0;
                                      i < snapshot.data!.length;
                                      i++)
                                    snapshot.data![i]['status'] == 'rejected'
                                        ? serviceBoooked(
                                            "${snapshot.data![i]['sub_categories'][0]['name']}",
                                            "${snapshot.data![i]['status']}",
                                            "${snapshot.data![i]['sub_categories'][0]['charge']}",
                                            "${snapshot.data![i]['sub_categories'][0]['image']}")
                                        : Container(),
                                  hasRejectedServices
                                      ? Container()
                                      : SizedBox(
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(14.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image(
                                                      width:
                                                          getProportionateScreenWidth(
                                                              100),
                                                      height:
                                                          getProportionateScreenHeight(
                                                              100),
                                                      image: const AssetImage(
                                                          "assets/images/home/nodata.png"),
                                                      fit: BoxFit.cover),
                                                  Text(
                                                    "No Rejected Services",
                                                    style:
                                                        GoogleFonts.nunitoSans(
                                                      textStyle:
                                                          const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(
                                  //       left: 8, right: 8),
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
                                  //             fontSize:
                                  //                 getProportionateScreenWidth(
                                  //                     17),
                                  //             fontWeight: FontWeight.bold,
                                  //             fontFamily: 'krona'),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  // SingleChildScrollView(
                                  //   scrollDirection: Axis.horizontal,
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.start,
                                  //     children: [
                                  //       for (int i = 0;
                                  //           i < snapshot.data!.length;
                                  //           i++)
                                  //         serviceProvider(
                                  //             '${snapshot.data![i]['service'][0]['logo']}',
                                  //             "${snapshot.data![i]['service'][0]['name']}",
                                  //             "Kampala,6th street"),
                                  //     ],
                                  //   ),
                                  // ),
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
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      15),
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
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Padding serviceProvider(String image, String name, String location) {
    print(finalserviceProviders);
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
                foregroundImage: NetworkImage(
                    'http://admin.esoptronsalon.com/storage/services/$image'),
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(5)),
            Text(
              name,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionateScreenWidth(14),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'krona'),
            ),
            SizedBox(height: getProportionateScreenHeight(5)),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     const Icon(
            //       Icons.location_pin,
            //       size: 15,
            //       color: kPrimaryColor,
            //     ),
            //     Text(
            //       location,
            //       style: TextStyle(
            //           color: Colors.black,
            //           fontSize: getProportionateScreenWidth(13),
            //           fontWeight: FontWeight.w500,
            //           fontFamily: 'krona'),
            //     ),
            //   ],
            // ),
            // const Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Padding(
            //       padding: EdgeInsets.all(8.0),
            //       child: Icon(
            //         Icons.phone,
            //         size: 15,
            //         color: kPrimaryColor,
            //       ),
            //     ),
            //     Padding(
            //       padding: EdgeInsets.all(8.0),
            //       child: Icon(
            //         Icons.chat,
            //         size: 15,
            //         color: kPrimaryColor,
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Padding serviceBoooked(
      String title, String subTitle, String price, String image) {
    return Padding(
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
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: Image(
                        height: 180,
                        width: 100,
                        image: NetworkImage(
                            'http://admin.esoptronsalon.com/storage/sub_categories/$image'),
                        fit: BoxFit.cover),
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(10),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$title \n UGX $price',
                        style: GoogleFonts.nunitoSans(
                            textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(16),
                          fontWeight: FontWeight.w500,
                        )),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
    // return Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: ListTile(
    //     // trailing:
    //     //     const Icon(Icons.favorite_outline, color: kPrimaryColor, size: 25),
    //     tileColor: Colors.transparent,
    //     subtitle: Row(
    //       children: [
    //         Text(
    //           "\$$price",
    //           style: TextStyle(
    //               color: kPrimaryColor,
    //               fontSize: getProportionateScreenWidth(18),
    //               fontWeight: FontWeight.bold,
    //               fontFamily: 'krona'),
    //         ),
    //         SizedBox(width: getProportionateScreenWidth(5)),
    //         Text(
    //           subTitle,
    //           style: TextStyle(
    //               color: kPrimaryColor,
    //               fontSize: getProportionateScreenWidth(18),
    //               fontWeight: FontWeight.normal,
    //               fontFamily: 'krona'),
    //         ),
    //       ],
    //     ),
    //     title: Padding(
    //       padding: const EdgeInsets.only(bottom: 8.0),
    //       child: Text(
    //         title,
    //         style: TextStyle(
    //             color: Colors.black,
    //             fontSize: getProportionateScreenWidth(18),
    //             fontWeight: FontWeight.bold,
    //             fontFamily: 'krona'),
    //       ),
    //     ),
    //     leading: ClipRRect(
    //       borderRadius: const BorderRadius.all(Radius.circular(8)),
    //       child: Image(
    //           // height: 200,
    //           width: getProportionateScreenWidth(80),
    //           height: getProportionateScreenHeight(120),
    //           image: NetworkImage(
    //               "http://admin.esoptronsalon.com/storage/sub_categories/$image"),
    //           fit: BoxFit.fill),
    //     ),
    //   ),
    // );
  }
}
