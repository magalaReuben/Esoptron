import 'dart:convert';
import 'dart:developer';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/controllers/getServiceProviderDetails.dart';
import 'package:esoptron_salon/providers/contentProvisionProviders.dart';
import 'package:esoptron_salon/screens/servicedetails/service_details.dart';
import 'package:esoptron_salon/utils/enums/global_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ServiceProvider extends ConsumerStatefulWidget {
  static String routeName = "service_provider";

  const ServiceProvider({super.key});

  @override
  ConsumerState<ServiceProvider> createState() => _ServiceProviderState();
}

class _ServiceProviderState extends ConsumerState<ServiceProvider> {
  Future<List<dynamic>> getReviews(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authorizationToken = prefs.getString("auth_token");
    final response = await http.get(
      Uri.parse(
          "http://admin.esoptronsalon.com/api/service/$id/user_review_ratings"),
      headers: {
        'Authorization': 'Bearer $authorizationToken',
        'Content-Type':
            'application/json', // You may need to adjust the content type based on your API requirements
      },
    );
    //print(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseBody = json.decode(response.body);
      return responseBody['data']['review_ratings'];
    } else {
      return [];
    }
  }

  Future<dynamic> getService(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authorizationToken = prefs.getString("auth_token");
    final response = await http.get(
      Uri.parse("http://admin.esoptronsalon.com/api/service/$id/details"),
      headers: {
        'Authorization': 'Bearer $authorizationToken',
        'Content-Type':
            'application/json', // You may need to adjust the content type based on your API requirements
      },
    );
    //print('This is our response: ${response.body}');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseBody = json.decode(response.body);
      //print('This is our response: ${responseBody['data']['service']}');
      return responseBody['data']['service'];
    } else {
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    Map<String, dynamic> serviceProvider = {};
    print("Our arguments: $arguments");
    // Future(() {
    //   ref.read(getServiceProviderDetailsIdProvider.notifier).state =
    //       arguments[1];
    // });
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor.withOpacity(0.8),
          title: Text("Service Provider",
              style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: getProportionateScreenWidth(18))),
        ),
        body: Stack(children: [
          SingleChildScrollView(
            child: Column(children: [
              Stack(
                children: [
                  Builder(builder: (context) {
                    final servicesProviderDetailsState =
                        ref.watch(serviceProviderDetailsProvider);
                    switch (servicesProviderDetailsState.status) {
                      case Status.initial:
                      case Status.loading:
                        return const Center(
                          child: Column(
                            children: [
                              SizedBox(height: 100),
                              CircularProgressIndicator(
                                color: kPrimaryColor,
                              ),
                              SizedBox(height: 100),
                            ],
                          ),
                        );
                      case Status.loaded:
                        dynamic serviceProvider = {};
                        serviceProvider =
                            servicesProviderDetailsState.data!.data;
                        Future(() {
                          ref.read(getServiceIdProvider.notifier).state =
                              serviceProvider['service']['id'];
                        });
                        //print("Our data: ${serviceProvider['data']}");
                        return Column(children: [
                          Stack(
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: SizedBox(
                                  height: getProportionateScreenHeight(150),
                                  child: serviceProvider['service'] == null
                                      ? Container()
                                      : Image(
                                          image: NetworkImage(
                                              "http://admin.esoptronsalon.com/${serviceProvider['service']['logo']}"),
                                          width:
                                              getProportionateScreenWidth(450),
                                          color: const Color.fromRGBO(
                                              255,
                                              255,
                                              255,
                                              0.5), // 50% transparent white color filter
                                          colorBlendMode: BlendMode.modulate,
                                          fit: BoxFit.cover),
                                ),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(200),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 10,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: CircleAvatar(
                                                radius: 45,
                                                foregroundImage: NetworkImage(
                                                    'http://admin.esoptronsalon.com/${serviceProvider['avatar']}'),
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(20),
                          ),
                          Text(
                            "${serviceProvider['name']}",
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: getProportionateScreenWidth(20)),
                          ),
                          SizedBox(
                            width: getProportionateScreenHeight(20),
                          ),
                          Text(
                            "${serviceProvider['email']}",
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.normal,
                                color: kPrimaryColor,
                                fontSize: getProportionateScreenWidth(15)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Divider(
                              color: Colors.black.withOpacity(0.9),
                              thickness: 1.5,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(children: [
                                Text(
                                  "Location",
                                  style: GoogleFonts.nunitoSans(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize:
                                          getProportionateScreenWidth(15)),
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(5),
                                ),
                                Text(
                                  "${serviceProvider['town']}",
                                  style: GoogleFonts.nunitoSans(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                      fontSize:
                                          getProportionateScreenWidth(15)),
                                ),
                              ]),
                              Column(children: [
                                Text("Availability",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            getProportionateScreenWidth(15),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'krona')),
                                SizedBox(
                                  height: getProportionateScreenHeight(5),
                                ),
                                serviceProvider['service'] == null
                                    ? Text(
                                        "Unavailable",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize:
                                                getProportionateScreenWidth(15),
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'krona'),
                                      )
                                    : serviceProvider['service']['is_available']
                                        ? Text(
                                            "Available",
                                            style: GoogleFonts.nunitoSans(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        15)),
                                          )
                                        : Text(
                                            "Unavailable",
                                            style: GoogleFonts.nunitoSans(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        15)),
                                          ),
                              ]),
                              Column(children: [
                                Text("Gender",
                                    style: GoogleFonts.nunitoSans(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize:
                                            getProportionateScreenWidth(15))),
                                SizedBox(
                                  height: getProportionateScreenHeight(5),
                                ),
                                Text(
                                  "${serviceProvider['gender']}",
                                  style: GoogleFonts.nunitoSans(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                      fontSize:
                                          getProportionateScreenWidth(15)),
                                ),
                              ]),
                            ],
                          )
                        ]);
                      case Status.error:
                        return const SizedBox();
                    }
                  })
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Divider(
                  color: Colors.black.withOpacity(0.9),
                  thickness: 1.5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Customer Reviews",
                      style: GoogleFonts.nunitoSans(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(17)),
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<dynamic>>(
                future: getReviews(ref.watch(getServiceIdProvider)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data!.isNotEmpty) {
                      return Column(
                        children: [
                          for (int i = 0; i < snapshot.data!.length; i++)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  height: getProportionateScreenHeight(100),
                                  width: getProportionateScreenWidth(360),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      border: Border.all(
                                        width: 2,
                                        color: kPrimaryColor.withOpacity(0.2),
                                      )),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 20,
                                      foregroundImage: NetworkImage(
                                          'http://admin.esoptronsalon.com/${snapshot.data![i]['avatar']}'),
                                    ),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text("${snapshot.data![i]['name']}",
                                            style: GoogleFonts.nunitoSans(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        16))),
                                        const SizedBox(width: 5),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Row(
                                            children: [
                                              for (int j = 0;
                                                  j <
                                                      snapshot.data![i]
                                                          ['star_rating'];
                                                  j++)
                                                const Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: Icon(
                                                    FontAwesomeIcons.solidStar,
                                                    size: 8,
                                                    color: Colors.orangeAccent,
                                                  ),
                                                ),
                                              for (int j = 0;
                                                  j <
                                                      5 -
                                                          snapshot.data![i]
                                                              ['star_rating'];
                                                  j++)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Icon(
                                                    FontAwesomeIcons.solidStar,
                                                    size: 8,
                                                    color: Colors.black
                                                        .withOpacity(0.4),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    subtitle: Text(
                                        "${snapshot.data![i]['comment']}",
                                        style: GoogleFonts.nunitoSans(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                            fontSize:
                                                getProportionateScreenWidth(
                                                    15))),
                                  )
                                  // Row(
                                  //   children: [
                                  //     Padding(
                                  //       padding: const EdgeInsets.all(4.0),
                                  //       child: CircleAvatar(
                                  //         radius: 20,
                                  //         foregroundImage: NetworkImage(
                                  //             'http://admin.esoptronsalon.com/${snapshot.data![i]['avatar']}'),
                                  //       ),
                                  //     ),
                                  //     Padding(
                                  //       padding: const EdgeInsets.all(8.0),
                                  //       child: Column(
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.center,
                                  //         children: [
                                  //           Row(
                                  //             mainAxisAlignment:
                                  //                 MainAxisAlignment.start,
                                  //             children: [
                                  //               Text(
                                  //                   "${snapshot.data![i]['name']}",
                                  //                   style: TextStyle(
                                  //                       color: Colors.black,
                                  //                       fontSize:
                                  //                           getProportionateScreenWidth(
                                  //                               16),
                                  //                       fontWeight:
                                  //                           FontWeight.bold,
                                  //                       fontFamily: 'krona')),
                                  //               const SizedBox(width: 5),
                                  //               Padding(
                                  //                 padding: const EdgeInsets.only(
                                  //                     left: 8.0),
                                  //                 child: Row(
                                  //                   children: [
                                  //                     for (int j = 0;
                                  //                         j <
                                  //                             snapshot.data![i]
                                  //                                 ['star_rating'];
                                  //                         j++)
                                  //                       const Padding(
                                  //                         padding:
                                  //                             EdgeInsets.all(4.0),
                                  //                         child: Icon(
                                  //                           FontAwesomeIcons
                                  //                               .solidStar,
                                  //                           size: 6,
                                  //                           color: Colors
                                  //                               .orangeAccent,
                                  //                         ),
                                  //                       ),
                                  //                     for (int j = 0;
                                  //                         j <
                                  //                             5 -
                                  //                                 snapshot.data![
                                  //                                         i][
                                  //                                     'star_rating'];
                                  //                         j++)
                                  //                       Padding(
                                  //                         padding:
                                  //                             const EdgeInsets
                                  //                                 .all(4.0),
                                  //                         child: Icon(
                                  //                           FontAwesomeIcons
                                  //                               .solidStar,
                                  //                           size: 6,
                                  //                           color: Colors.black
                                  //                               .withOpacity(0.4),
                                  //                         ),
                                  //                       ),
                                  //                   ],
                                  //                 ),
                                  //               )
                                  //             ],
                                  //           ),
                                  //           Row(
                                  //             children: [
                                  //               Text(
                                  //                   "${snapshot.data![i]['comment']}",
                                  //                   style: TextStyle(
                                  //                       color: Colors.black,
                                  //                       fontSize:
                                  //                           getProportionateScreenWidth(
                                  //                               15),
                                  //                       fontWeight:
                                  //                           FontWeight.normal,
                                  //                       fontFamily: 'krona')),
                                  //               SizedBox(
                                  //                   width: 800 /
                                  //                       snapshot
                                  //                           .data![i]['comment']
                                  //                           .length)
                                  //             ],
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  ),
                            ),
                        ],
                      );
                    } else {
                      return Center(
                        child: Text("No comments yet",
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: getProportionateScreenWidth(17))),
                      );
                    }
                  } else {
                    // You can return a placeholder or loading indicator while the image is loading
                    return const CircularProgressIndicator();
                  }
                },
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       Text(
              //         "View More",
              //         style: TextStyle(
              //             decoration: TextDecoration.underline,
              //             color: kPrimaryColor,
              //             fontSize: getProportionateScreenWidth(15),
              //             fontWeight: FontWeight.bold,
              //             fontFamily: 'krona'),
              //       ),
              //     ],
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Service",
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(17))),
                  ],
                ),
              ),
              FutureBuilder<dynamic>(
                future: getService(ref.watch(getServiceIdProvider)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    print(snapshot.data!);
                    if (snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          "No services yet",
                          style: GoogleFonts.nunitoSans(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(17)),
                        ),
                      );
                    } else {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Container(
                              height: getProportionateScreenHeight(195),
                              width: getProportionateScreenWidth(360),
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
                                          width: 140,
                                          image: NetworkImage(
                                              "http://admin.esoptronsalon.com/${snapshot.data!['logo']}"),
                                          fit: BoxFit.cover),
                                    ),
                                    SizedBox(
                                      width: getProportionateScreenWidth(10),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data!['name'],
                                          style: GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize:
                                                getProportionateScreenWidth(16),
                                            fontWeight: FontWeight.w500,
                                          )),
                                        ),
                                        SizedBox(
                                          height:
                                              getProportionateScreenHeight(5),
                                        ),
                                        SizedBox(
                                          width:
                                              getProportionateScreenWidth(200),
                                          child: Text(
                                            snapshot.data!["description"],
                                            style: GoogleFonts.nunitoSans(
                                                textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      12),
                                              fontWeight: FontWeight.w400,
                                            )),
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                              getProportionateScreenHeight(5),
                                        ),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                foregroundColor: kPrimaryColor,
                                                backgroundColor: kPrimaryColor),
                                            onPressed: () async {
                                              //print(arguments[0]);
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              String? authorizationToken =
                                                  prefs.getString("auth_token");
                                              final response = await http.get(
                                                Uri.parse(
                                                    "http://admin.esoptronsalon.com/api/service/${snapshot.data!["id"]}/details"),
                                                headers: {
                                                  'Authorization':
                                                      'Bearer $authorizationToken',
                                                  'Content-Type':
                                                      'application/json', // You may need to adjust the content type based on your API requirements
                                                },
                                              );
                                              if (response.statusCode >= 200 &&
                                                  response.statusCode < 300) {
                                                final responseData =
                                                    json.decode(response.body);
                                                //log(responseData['data']);
                                                setState(() {
                                                  serviceProvider =
                                                      responseData['data']
                                                              ['service']
                                                          ['service_provider'];
                                                });
                                              } else {
                                                setState(() {
                                                  serviceProvider = {
                                                    'name': '',
                                                    'email': '',
                                                    'avatar': '',
                                                    'phone': ''
                                                  };
                                                });
                                              }
                                              // ignore: use_build_context_synchronously
                                              Navigator.pushNamed(context,
                                                  ServiceDetails.routeName,
                                                  arguments: [
                                                    snapshot.data!["name"],
                                                    "http://admin.esoptronsalon.com/${snapshot.data!["logo"]}",
                                                    snapshot
                                                        .data!["description"],
                                                    serviceProvider,
                                                    // snapshot
                                                    //     .data!["ratings_count"],
                                                    0,
                                                    snapshot.data![
                                                                "is_available"] ==
                                                            0
                                                        ? false
                                                        : true,
                                                    // snapshot
                                                    //     .data!["ratings_count"],
                                                    0,
                                                    true,
                                                    snapshot.data!["id"],
                                                    arguments[1]
                                                  ]);
                                            },
                                            child: Text(
                                              "View Service",
                                              style: GoogleFonts.nunitoSans(
                                                  textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          getProportionateScreenWidth(
                                                              12),
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ));
                      // return Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Container(
                      //     height: getProportionateScreenHeight(150),
                      //     width: getProportionateScreenWidth(360),
                      //     decoration: BoxDecoration(
                      //         borderRadius:
                      //             const BorderRadius.all(Radius.circular(10)),
                      //         border: Border.all(
                      //           width: 2,
                      //           color: kPrimaryColor,
                      //         )),
                      //     child: Row(
                      //       children: [
                      //         Image(
                      //             image: NetworkImage(
                      //                 "http://admin.esoptronsalon.com/${snapshot.data!['logo']}"),
                      //             fit: BoxFit.cover),
                      //         Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Column(
                      //             mainAxisAlignment:
                      //                 MainAxisAlignment.spaceEvenly,
                      //             children: [
                      //               Text(
                      //                 "${snapshot.data!['name']}",
                      //                 style: TextStyle(
                      //                     color: kPrimaryColor,
                      //                     fontSize:
                      //                         getProportionateScreenWidth(18),
                      //                     fontWeight: FontWeight.bold,
                      //                     fontFamily: 'krona'),
                      //               ),
                      //               Row(
                      //                 mainAxisAlignment:
                      //                     MainAxisAlignment.start,
                      //                 children: [
                      //                   FilledButton(
                      //                       onPressed: () =>
                      //                           Navigator.pushNamed(context,
                      //                               ServiceDetails.routeName,
                      //                               arguments: [
                      //                                 snapshot.data!['name'],
                      //                                 "http://admin.esoptronsalon.com/${snapshot.data!['logo']}",
                      //                                 snapshot
                      //                                     .data!['description'],
                      //                                 snapshot.data![
                      //                                     'service_provider'],
                      //                                 4,
                      //                                 snapshot.data![
                      //                                     'is_available'],
                      //                                 0,
                      //                                 true,
                      //                                 snapshot.data![
                      //                                         'service_provider']
                      //                                     ['id'],
                      //                                 snapshot.data!['id']
                      //                               ]),
                      //                       child: const Padding(
                      //                         padding: EdgeInsets.only(
                      //                             left: 20.0,
                      //                             right: 20,
                      //                             top: 10,
                      //                             bottom: 10),
                      //                         child: Text("View"),
                      //                       )),
                      //                   const SizedBox(
                      //                     width: 35,
                      //                   )
                      //                 ],
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // );
                    }
                  } else {
                    // You can return a placeholder or loading indicator while the image is loading
                    return const CircularProgressIndicator();
                  }
                },
              )
            ]),
          ),
        ]));
  }
}
