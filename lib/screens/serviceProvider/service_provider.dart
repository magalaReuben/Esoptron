import 'dart:convert';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/controllers/getServiceProviderDetails.dart';
import 'package:esoptron_salon/providers/contentProvisionProviders.dart';
import 'package:esoptron_salon/screens/servicedetails/service_details.dart';
import 'package:esoptron_salon/utils/enums/global_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      //print(responseBody['data']['review_ratings']);
      //print(responseBody);
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
      print('This is our response: ${responseBody['data']['service']}');
      return responseBody['data']['service'];
    } else {
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    // Future(() {
    //   ref.read(getServiceProviderDetailsIdProvider.notifier).state =
    //       arguments[1];
    // });
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Service Provider",
            style: TextStyle(fontSize: getProportionateScreenWidth(18)),
          ),
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
                        print("Our data: ${serviceProvider}");
                        return Column(children: [
                          Stack(
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: SizedBox(
                                  height: getProportionateScreenHeight(150),
                                  child: Image(
                                      image: NetworkImage(
                                          "http://admin.esoptronsalon.com/${serviceProvider['service']['logo']}"),
                                      width: getProportionateScreenWidth(450),
                                      color: const Color.fromRGBO(255, 255, 255,
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
                                            child: CircleAvatar(
                                              radius: 35,
                                              foregroundImage: NetworkImage(
                                                  'http://admin.esoptronsalon.com/${serviceProvider['avatar']}'),
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
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: getProportionateScreenWidth(17),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'krona'),
                          ),
                          SizedBox(
                            width: getProportionateScreenHeight(20),
                          ),
                          Text(
                            "${serviceProvider['email']}",
                            style: TextStyle(
                                color: kPrimaryColor.withOpacity(0.7),
                                fontSize: getProportionateScreenWidth(15),
                                fontWeight: FontWeight.normal,
                                fontFamily: 'krona'),
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
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: getProportionateScreenWidth(15),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'krona'),
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(5),
                                ),
                                Text(
                                  "${serviceProvider['town']}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: getProportionateScreenWidth(15),
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'krona'),
                                ),
                              ]),
                              Column(children: [
                                Text(
                                  "Availability",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: getProportionateScreenWidth(15),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'krona'),
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(5),
                                ),
                                serviceProvider['service']['is_available']
                                    ? Text(
                                        "Available",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize:
                                                getProportionateScreenWidth(15),
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'krona'),
                                      )
                                    : Text(
                                        "Unavailable",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize:
                                                getProportionateScreenWidth(15),
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'krona'),
                                      ),
                              ]),
                              Column(children: [
                                Text(
                                  "Gender",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: getProportionateScreenWidth(15),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'krona'),
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(5),
                                ),
                                Text(
                                  "${serviceProvider['gender']}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: getProportionateScreenWidth(15),
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'krona'),
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
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(17),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'krona'),
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<dynamic>>(
                future: getReviews(ref.watch(getServiceIdProvider)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    //print(snapshot.data);
                    return Column(
                      children: [
                        for (int i = 0; i < snapshot.data!.length; i++)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: getProportionateScreenHeight(80),
                              width: getProportionateScreenWidth(360),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(
                                    width: 2,
                                    color: kPrimaryColor.withOpacity(0.2),
                                  )),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      radius: 30,
                                      foregroundImage: NetworkImage(
                                          'http://admin.esoptronsalon.com/${snapshot.data![i]['avatar']}'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Text("${snapshot.data![i]['name']}",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        getProportionateScreenWidth(
                                                            18),
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'krona')),
                                            const SizedBox(width: 10),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Row(
                                                children: [
                                                  for (int j = 0;
                                                      j <
                                                          snapshot.data![i]
                                                              ['star_rating'];
                                                      j++)
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.all(4.0),
                                                      child: Icon(
                                                        FontAwesomeIcons
                                                            .solidStar,
                                                        size: 10,
                                                        color:
                                                            Colors.orangeAccent,
                                                      ),
                                                    ),
                                                  for (int j = 0;
                                                      j <
                                                          5 -
                                                              snapshot.data![i][
                                                                  'star_rating'];
                                                      j++)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Icon(
                                                        FontAwesomeIcons
                                                            .solidStar,
                                                        size: 10,
                                                        color: Colors.black
                                                            .withOpacity(0.4),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                                "${snapshot.data![i]['comment']}",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        getProportionateScreenWidth(
                                                            18),
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontFamily: 'krona')),
                                            SizedBox(
                                                width: 800 /
                                                    snapshot.data![i]['comment']
                                                        .length)
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    );
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
                    Text(
                      "Services",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(17),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'krona'),
                    ),
                  ],
                ),
              ),
              FutureBuilder<dynamic>(
                future: getService(ref.watch(getServiceIdProvider)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    print(snapshot.data);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: getProportionateScreenHeight(150),
                        width: getProportionateScreenWidth(360),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                              width: 2,
                              color: kPrimaryColor,
                            )),
                        child: Row(
                          children: [
                            Image(
                                //image: NetImage(image),
                                image: NetworkImage(
                                    "http://admin.esoptronsalon.com/${snapshot.data!['logo']}"),
                                fit: BoxFit.cover),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "${snapshot.data!['name']}",
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize:
                                            getProportionateScreenWidth(18),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'krona'),
                                  ),
                                  FilledButton(
                                      onPressed: () => Navigator.pushNamed(
                                              context, ServiceDetails.routeName,
                                              arguments: [
                                                snapshot.data!['name'],
                                                "http://admin.esoptronsalon.com/${snapshot.data!['logo']}",
                                                snapshot.data!['description'],
                                                snapshot
                                                    .data!['service_provider'],
                                                4,
                                                snapshot.data!['is_available'],
                                                0,
                                                true,
                                                snapshot.data![
                                                    'service_provider']['id'],
                                                snapshot.data!['id']
                                              ]),
                                      child: const Padding(
                                        padding: EdgeInsets.all(13.0),
                                        child: Text("Select"),
                                      ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
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
