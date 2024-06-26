import 'dart:convert';

import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/controllers/getService.dart';
import 'package:esoptron_salon/providers/contentProvisionProviders.dart';
import 'package:esoptron_salon/screens/servicedetails/service_details.dart';
import 'package:esoptron_salon/utils/enums/global_state.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServicesUnderSubCategory extends ConsumerStatefulWidget {
  static String routeName = "/servicesUnderSubCategory";
  const ServicesUnderSubCategory({super.key});

  @override
  ConsumerState<ServicesUnderSubCategory> createState() =>
      _ServicesUnderSubCategoryState();
}

class _ServicesUnderSubCategoryState
    extends ConsumerState<ServicesUnderSubCategory> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    Map<dynamic, dynamic> serviceProvider = {};
    print("my id is : ${arguments[0]}");
    Future(() {
      ref.read(getServiceIdProvider.notifier).state = arguments[0];
    });
    final services = ref.watch(servicesProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor.withOpacity(0.8),
        title: Text(arguments[2],
            style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: getProportionateScreenWidth(18))),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Builder(builder: (context) {
              switch (services.status) {
                case Status.initial:
                case Status.loading:
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 50),
                      Center(
                        child: CircularProgressIndicator(
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  );
                case Status.loaded:
                  var servicesList = [];
                  for (var element in services.data!.data['services']['data']) {
                    servicesList.add(element);
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Results(${servicesList.length})",
                                  style: GoogleFonts.nunitoSans(
                                      textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: getProportionateScreenWidth(17),
                                    fontWeight: FontWeight.w400,
                                  ))),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: getProportionateScreenWidth(5),
                        ),
                        for (int i = 0; i < servicesList.length; i++)
                          Padding(
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
                                                  "http://admin.esoptronsalon.com/${servicesList[i]["logo"]}"),
                                              fit: BoxFit.cover),
                                        ),
                                        SizedBox(
                                          width:
                                              getProportionateScreenWidth(10),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              servicesList[i]["name"],
                                              style: GoogleFonts.nunitoSans(
                                                  textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        16),
                                                fontWeight: FontWeight.w500,
                                              )),
                                            ),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      5),
                                            ),
                                            SizedBox(
                                              width:
                                                  getProportionateScreenWidth(
                                                      200),
                                              child: Text(
                                                servicesList[i]["description"],
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
                                                  getProportionateScreenHeight(
                                                      5),
                                            ),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    foregroundColor:
                                                        kPrimaryColor,
                                                    backgroundColor:
                                                        kPrimaryColor),
                                                onPressed: () async {
                                                  //print(arguments[0]);
                                                  // SharedPreferences prefs =
                                                  //     await SharedPreferences
                                                  //         .getInstance();
                                                  // String? authorizationToken =
                                                  //     prefs.getString(
                                                  //         "auth_token");
                                                  // final response =
                                                  //     await http.get(
                                                  //   Uri.parse(
                                                  //       "http://admin.esoptronsalon.com/api/service/${servicesList[i]["id"]}/details"),
                                                  //   headers: {
                                                  //     'Authorization':
                                                  //         'Bearer $authorizationToken',
                                                  //     'Content-Type':
                                                  //         'application/json', // You may need to adjust the content type based on your API requirements
                                                  //   },
                                                  // );
                                                  // if (response.statusCode >=
                                                  //         200 &&
                                                  //     response.statusCode <
                                                  //         300) {
                                                  //   final responseData = json
                                                  //       .decode(response.body);
                                                  //   setState(() {
                                                  //     serviceProvider =
                                                  //         responseData['data']
                                                  //                 ['service'][
                                                  //             'service_provider'];
                                                  //   });
                                                  // } else {
                                                  //   setState(() {
                                                  //     serviceProvider = {
                                                  //       'name': '',
                                                  //       'email': '',
                                                  //       'avatar': '',
                                                  //       'phone': ''
                                                  //     };
                                                  //   });
                                                  // }
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.pushNamed(context,
                                                      ServiceDetails.routeName,
                                                      arguments: [
                                                        servicesList[i]["name"],
                                                        "http://admin.esoptronsalon.com/${servicesList[i]["logo"]}",
                                                        servicesList[i]
                                                            ["description"],
                                                        {},
                                                        servicesList[i]
                                                            ["ratings_count"],
                                                        servicesList[i][
                                                                    "is_available"] ==
                                                                0
                                                            ? false
                                                            : true,
                                                        servicesList[i]
                                                            ["ratings_count"],
                                                        false,
                                                        arguments[1],
                                                        arguments[2],
                                                        servicesList[i]["id"],
                                                        arguments[0],
                                                        arguments[3]
                                                      ]);

                                                  //  [
                                                  //   servicesList[i]["name"],
                                                  //   "http://admin.esoptronsalon.com/${servicesList[i]["logo"]}",
                                                  //   servicesList[i]
                                                  //       ["description"],
                                                  //   serviceProvider,
                                                  //   servicesList[i]
                                                  //       ["ratings_count"],
                                                  //   servicesList[i][
                                                  //               "is_available"] ==
                                                  //           0
                                                  //       ? false
                                                  //       : true,
                                                  //   servicesList[i]
                                                  //       ["ratings_count"],
                                                  //   true,
                                                  //   servicesList[i]["id"],
                                                  //   arguments[0]
                                                  // ]);
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
                              )),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Container(
                        //     height: getProportionateScreenHeight(150),
                        //     width: getProportionateScreenWidth(360),
                        //     decoration: BoxDecoration(
                        //         borderRadius: const BorderRadius.all(
                        //             Radius.circular(10)),
                        //         border: Border.all(
                        //           width: 2,
                        //           color: kPrimaryColor,
                        //         )),
                        //     child: Row(
                        //       children: [
                        //         Padding(
                        //           padding: const EdgeInsets.all(4.0),
                        //           child: ClipRRect(
                        //             borderRadius: BorderRadius.circular(10),
                        //             child: Image(
                        //                 //image: NetImage(image),
                        //                 image: NetworkImage(
                        //                     "http://admin.esoptronsalon.com/${servicesList[i]["logo"]}"),
                        //                 fit: BoxFit.cover),
                        //           ),
                        //         ),
                        //         Padding(
                        //           padding: const EdgeInsets.all(8.0),
                        //           child: Column(
                        //             mainAxisAlignment:
                        //                 MainAxisAlignment.spaceEvenly,
                        //             children: [
                        //               Text(
                        //                 "${servicesList[i]["name"]}",
                        //                 style: TextStyle(
                        //                     color: kPrimaryColor,
                        //                     fontSize:
                        //                         getProportionateScreenWidth(
                        //                             18),
                        //                     fontWeight: FontWeight.bold,
                        //                     fontFamily: 'krona'),
                        //               ),
                        //               Row(
                        //                 mainAxisAlignment:
                        //                     MainAxisAlignment.start,
                        //                 children: [
                        //                   FilledButton(
                        //                       onPressed: () =>
                        //                           Navigator.pushNamed(
                        //                               context,
                        //                               ServiceDetails
                        //                                   .routeName,
                        //                               arguments: [
                        //                                 servicesList[i]
                        //                                     ["name"],
                        //                                 "http://admin.esoptronsalon.com/${servicesList[i]["logo"]}",
                        //                                 servicesList[i]
                        //                                     ["description"],
                        //                                 {},
                        //                                 servicesList[i]
                        //                                     ["ratings_count"],
                        //                                 servicesList[i][
                        //                                             "is_available"] ==
                        //                                         0
                        //                                     ? false
                        //                                     : true,
                        //                                 servicesList[i]
                        //                                     ["ratings_count"],
                        //                                 false,
                        //                                 arguments[1],
                        //                                 arguments[2],
                        //                                 servicesList[i]["id"],
                        //                                 arguments[0]
                        //                               ]),
                        //                       child: const Padding(
                        //                         padding: EdgeInsets.all(13.0),
                        //                         child: Text("Select"),
                        //                       )),
                        //                   SizedBox(
                        //                     width:
                        //                         getProportionateScreenWidth(
                        //                             40),
                        //                   )
                        //                 ],
                        //               )
                        //             ],
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          width: getProportionateScreenWidth(15),
                        )
                      ],
                    ),
                  );
                case Status.error:
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: getProportionateScreenHeight(50)),
                    ],
                  );
              }
            }),
          ],
        ),
      ),
    );
  }
}
