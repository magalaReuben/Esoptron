import 'dart:developer';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/controllers/category.dart';
import 'package:esoptron_salon/controllers/service.dart';
import 'package:esoptron_salon/screens/categories/categories_page.dart';
import 'package:esoptron_salon/screens/serviceProvider/service_provider.dart';
import 'package:esoptron_salon/screens/servicedetails/service_details.dart';
import 'package:esoptron_salon/utils/enums/global_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends ConsumerStatefulWidget {
  const Body({super.key});

  @override
  ConsumerState<Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<Body> {
  String? greeting;
  String? firstName;

  Future getUserNames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    firstName = prefs.getString("firstName");
  }

  @override
  void initState() {
    super.initState();
    getUserNames();
    var now = DateTime.now();
    var hour = now.hour;
    if (hour < 12) {
      greeting = '☀️☕️ Good morning';
    } else if (hour < 17) {
      greeting = '☀️🍹 Good afternoon';
    } else {
      print(hour);
      greeting = '🌙📺 Good evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> _images = [
      "assets/images/home/banner2.png",
      "assets/images/home/Banner1.png",
      "assets/images/home/banner2.png"
    ];

    List topServices = [
      {
        "image": "assets/images/home/toprated1.png",
        "text": "G&B Beauty Services"
      },
      {
        "image": "assets/images/home/toprated2.png",
        "text": "Pearl Hair Clinic"
      },
      {
        "image": "assets/images/home/toprated3.png",
        "text": "Tayer Hair Designers"
      },
      {
        "image": "assets/images/home/toprated4.png",
        "text": "G&B Beauty Services"
      },
    ];

    List newServices = [
      {"image": "assets/images/home/new1.png", "text": "Apex Facial Services"},
      {"image": "assets/images/home/new2.png", "text": "Syrin Nail & Glam"},
      {"image": "assets/images/home/new3.png", "text": "G&B Beauty Services"},
      {"image": "assets/images/home/new4.png", "text": "G&B Beauty Services"},
    ];

    List serviceTypeName = [
      "Pedicure",
      "Hair Styling",
      "Makeup",
      "Manicure",
      "Message",
      "Bridal",
      "Waxing"
    ];

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "$greeting $firstName!",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(22),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'krona'),
                ),
              ],
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(8)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Promotions",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(18),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'krona'),
                ),
              ],
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(8)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < _images.length; i++)
                  Image(image: AssetImage(_images[i]), fit: BoxFit.cover)
              ],
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(8)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Service Types",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(18),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'krona'),
                ),
              ],
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(8)),
          Builder(
            builder: (context) {
              final categoryState = ref.watch(categoriesProvider);
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 1; i < 8; i++)
                      GestureDetector(
                        onTap: () {
                          var categories = [];
                          //log(servicesState.data!.data.toString());
                          for (var element in categoryState
                              .data!.data['all-categories']['data']) {
                            //log(element['service_type_id'].toString());
                            if (element['service_type_id'] == i) {
                              log(element.toString());
                              categories.add(element);
                            }
                          }
                          Navigator.pushNamed(
                              context, CategoriesScreen.routeName,
                              arguments: [serviceTypeName[i - 1], categories]);
                        },
                        child: Image(
                            image: AssetImage(
                                "assets/images/home/service-type-item$i.png"),
                            fit: BoxFit.cover),
                      ),
                    SizedBox(
                      width: getProportionateScreenWidth(5),
                    )
                  ],
                ),
              );
            },
          ),
          SizedBox(height: getProportionateScreenHeight(8)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Top Rated Services",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(18),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'krona'),
                ),
              ],
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(8)),
          Builder(builder: (context) {
            // ref.invalidate(documentsProvider);
            final servicesState = ref.watch(servicesProvider);
            switch (servicesState.status) {
              case Status.initial:
              case Status.loading:
                return const Center(
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                );
              case Status.loaded:
                var services = [];
                //log(servicesState.data!.data.toString());
                for (var element in servicesState.data!.data['all-services']
                    ['data']) {
                  //log(element.toString());
                  services.add(element);
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < services.length; i++)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ratingCard(
                              "http://admin.esoptronsalon.com/${services[i]["logo"]}",
                              services[i]["name"],
                              services[i]["ratings_count"].toString(),
                              services[i]["description"],
                              services[i]["service_provider"]),
                        )
                    ],
                  ),
                );
              case Status.error:
                return const SizedBox();
            }
          }),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       Text(
          //         "New Services",
          //         style: TextStyle(
          //             color: Colors.black,
          //             fontSize: getProportionateScreenWidth(18),
          //             fontWeight: FontWeight.bold,
          //             fontFamily: 'krona'),
          //       ),
          //     ],
          //   ),
          // ),
          // SizedBox(height: getProportionateScreenHeight(8)),
          // Builder(builder: (context) {
          //   // ref.invalidate(documentsProvider);
          //   final servicesState = ref.watch(servicesProvider);
          //   switch (servicesState.status) {
          //     case Status.initial:
          //     case Status.loading:
          //       return const Center(
          //         child: CircularProgressIndicator(
          //           color: kPrimaryColor,
          //         ),
          //       );
          //     case Status.loaded:
          //       var services = [];
          //       //log(servicesState.data!.data.toString());
          //       for (var element in servicesState.data!.data['all-services']
          //           ['data']) {
          //         log(element.toString());
          //         services.add(element);
          //       }
          //       return SingleChildScrollView(
          //         scrollDirection: Axis.horizontal,
          //         child: Row(
          //           children: [
          //             for (int i = 0; i < services.length; i++)
          //               Padding(
          //                 padding: const EdgeInsets.all(8.0),
          //                 child: ratingCard(
          //                     "http://admin.esoptronsalon.com/${services[i]["logo"]}",
          //                     services[i]["name"],
          //                     services[i]["ratings_count"].toString()),
          //               )
          //           ],
          //         ),
          //       );
          //     case Status.error:
          //       return const SizedBox();
          //   }
          // }),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       Text(
          //         "Service Providers",
          //         style: TextStyle(
          //             color: Colors.black,
          //             fontSize: getProportionateScreenWidth(18),
          //             fontWeight: FontWeight.bold,
          //             fontFamily: 'krona'),
          //       ),
          //     ],
          //   ),
          // ),
          // GridView.builder(
          //     shrinkWrap: true,
          //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //       childAspectRatio: 1,
          //       crossAxisCount: 2,
          //     ),
          //     itemCount: 4,
          //     itemBuilder: (BuildContext context, int index) =>
          //         serviceProvider(index))
        ],
      ),
    );
  }

  GestureDetector serviceProvider(int index) {
    index += 1;
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, ServiceProvider.routeName),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: getProportionateScreenWidth(130),
          height: getProportionateScreenHeight(150),
          decoration: BoxDecoration(
              border: Border.all(
                color: kPrimaryColor,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(15))),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 30,
                  foregroundImage:
                      AssetImage('assets/images/home/pic$index.png'),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(5)),
              Text(
                "John Joshua",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(17),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'krona'),
              ),
              SizedBox(height: getProportionateScreenHeight(5)),
              Text(
                "G&B Beauty Services",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(12),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'krona'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector ratingCard(String image, String text, String rating,
      String description, Map<dynamic, dynamic> serviceProvider) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, ServiceDetails.routeName,
          arguments: [text, image, description, serviceProvider]),
      child: Container(
        width: getProportionateScreenWidth(160),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black.withOpacity(0.1),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: Image(
                    image: NetworkImage(image),
                    // height: getProportionateScreenHeight(470),
                    // width: getProportionateScreenWidth(440),
                    fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                text,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(13),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'krona'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    rating,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(10),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'krona'),
                  ),
                  for (int i = 0; i < 4; i++)
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        FontAwesomeIcons.solidStar,
                        size: 13,
                        color: Colors.black.withOpacity(0.4),
                      ),
                    ),
                  // SizedBox(
                  //   width: getProportionateScreenWidth(10),
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
