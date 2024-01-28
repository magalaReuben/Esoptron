import 'dart:convert';
import 'dart:developer';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/controllers/category.dart';
import 'package:esoptron_salon/controllers/service.dart';
import 'package:esoptron_salon/controllers/serviceType.dart';
import 'package:esoptron_salon/providers/profileProviders.dart';
import 'package:esoptron_salon/screens/categories/categories_page.dart';
import 'package:esoptron_salon/screens/serviceProvider/service_provider.dart';
import 'package:esoptron_salon/screens/servicedetails/service_details.dart';
import 'package:esoptron_salon/screens/subcategories/searched_subcategory.dart';
import 'package:esoptron_salon/widgets/text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:esoptron_salon/screens/subcategories/subcategories.dart';
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
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  Future getUserNames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    firstName = prefs.getString("firstName");
    ref.read(firstNameProvider.notifier).state = firstName;
  }

  Future<List<dynamic>> search(String query) async {
    final response = await http.get(Uri.parse(
        "http://admin.esoptronsalon.com/api/sub_category/search?keyword=$query"));
    if (response.statusCode == 200 && response.statusCode < 300) {
      var data = json.decode(response.body);
      return data['search-results'];
    } else {
      return [];
    }
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
      "pedicure",
      "hairstyling",
      "makeup",
      "manicure",
      "massage",
      "bridal",
      "waxing"
    ];

    List topRated = [
      'assets/images/home/pic1.jpg',
      'assets/images/home/nail.jpg',
      'assets/images/home/makeup.jpg',
      'assets/images/home/massage.jpg',
    ];

    List names = [
      "Dreadlines",
      "Nails",
      "Makeup",
      "Massage",
    ];

    final firstName = ref.watch(firstNameProvider);

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "$greeting $firstName!",
                  style: GoogleFonts.nunitoSans(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // style: TextStyle(
                  //     color: Colors.black,
                  //     fontSize: getProportionateScreenWidth(22),
                  //     fontWeight: FontWeight.bold,
                  //     fontFamily: 'krona'),
                ),
              ],
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(12)),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFieldWidget(
              controller: searchController,
              radiusBottomLeft: 30,
              radiusBottomRight: 30,
              radiusTopLeft: 30,
              radiusTopRight: 30,
              hintText: "Search",
              suffixWidget: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    height: getProportionateScreenHeight(39),
                    width: getProportionateScreenWidth(32),
                    decoration: const BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(60))),
                    child: GestureDetector(
                      onTap: () async {
                        if (searchController.text.isEmpty) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Please enter a search query"),
                            backgroundColor: kPrimaryColor,
                            padding: EdgeInsets.all(25),
                          ));
                          return;
                        }
                        setState(() {
                          isSearching = true;
                        });
                        final result = await search(searchController.text);
                        setState(() {
                          isSearching = false;
                        });
                        if (result.isEmpty) {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("No results found"),
                            backgroundColor: kPrimaryColor,
                            padding: EdgeInsets.all(25),
                          ));
                          return;
                        } else {
                          //print(result);
                          // ignore: use_build_context_synchronously
                          Navigator.pushNamed(
                              context, SearchedSubCategories.routeName,
                              arguments: result);
                        }
                      },
                      child: isSearching
                          ? SizedBox(
                              height: getProportionateScreenHeight(8),
                              width: getProportionateScreenWidth(8),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : Icon(
                              size: getProportionateScreenWidth(20),
                              FontAwesomeIcons.search,
                              color: Colors.white,
                            ),
                    )),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       Text(
          //         "Promotions",
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
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: Row(
          //     children: [
          //       for (int i = 0; i < _images.length; i++)
          //         Image(image: AssetImage(_images[i]), fit: BoxFit.cover)
          //     ],
          //   ),
          // ),
          SizedBox(height: getProportionateScreenHeight(8)),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Service Types",
                  style: GoogleFonts.nunitoSans(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(8)),
          Builder(builder: (context) {
            // ref.invalidate(documentsProvider);
            final serviceTypesState = ref.watch(serviceTypesProvider);
            switch (serviceTypesState.status) {
              case Status.initial:
              case Status.loading:
                return const Center(
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                );
              case Status.loaded:
                var serviceTypes = [];
                log(serviceTypesState.data!.data.toString());
                for (var element
                    in serviceTypesState.data!.data['all-serviceTypes']) {
                  serviceTypes.add(element);
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 1; i < serviceTypes.length; i++)
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, CategoriesScreen.routeName,
                                arguments: [
                                  serviceTypes[i]['name'],
                                  serviceTypes[i]['id']
                                ]);
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  child: Image(
                                      height: 120,
                                      width: 120,
                                      image: NetworkImage(
                                          "http://admin.esoptronsalon.com/${serviceTypes[i]['image']}"),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              // Text(
                              //   serviceTypes[i]['name'],
                              //   style: TextStyle(
                              //       color: Colors.black,
                              //       fontSize: getProportionateScreenWidth(15),
                              //       fontWeight: FontWeight.w500,
                              //       fontFamily: 'krona'),
                              // ),
                            ],
                          ),
                        ),
                      SizedBox(
                        width: getProportionateScreenWidth(15),
                      )
                    ],
                  ),
                );
              case Status.error:
                return SizedBox(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                              width: getProportionateScreenWidth(100),
                              height: getProportionateScreenHeight(100),
                              image: const AssetImage(
                                  "assets/images/home/nodata.png"),
                              fit: BoxFit.cover),
                          const Text(
                            "Service Types not available",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
            }
          }),
          SizedBox(height: getProportionateScreenHeight(8)),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Featured Categories",
                  style: GoogleFonts.nunitoSans(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          //SizedBox(height: getProportionateScreenHeight(8)),
          Builder(builder: (context) {
            // ref.invalidate(documentsProvider);
            final categoriesState = ref.watch(categoriesProvider);
            switch (categoriesState.status) {
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
                for (var element in categoriesState.data!.data['all-categories']
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
                          child: ratingCard(services[i]['image'],
                              services[i]['name'], services[i]['id']),
                          // names[i]
                          //),
                        )
                    ],
                  ),
                );
              case Status.error:
                return SizedBox(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                              width: getProportionateScreenWidth(100),
                              height: getProportionateScreenHeight(100),
                              image: const AssetImage(
                                  "assets/images/home/nodata.png"),
                              fit: BoxFit.cover),
                          const Text(
                            "Categories not available",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
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

  GestureDetector ratingCard(String image, String text, int id) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, SubCategories.routeName,
            arguments: [id, image, text]);
      },
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
                    //image: NetImage(image),
                    image:
                        NetworkImage("http://admin.esoptronsalon.com/$image"),
                    height: getProportionateScreenHeight(200),
                    //width: getProportionateScreenWidth(440),
                    fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                text,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(14),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'krona'),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       Text(
            //         rating,
            //         style: TextStyle(
            //             color: Colors.black,
            //             fontSize: getProportionateScreenWidth(10),
            //             fontWeight: FontWeight.bold,
            //             fontFamily: 'krona'),
            //       ),
            //       for (int i = 0; i < 4; i++)
            //         Padding(
            //           padding: const EdgeInsets.all(4.0),
            //           child: Icon(
            //             FontAwesomeIcons.solidStar,
            //             size: 13,
            //             color: Colors.black.withOpacity(0.4),
            //           ),
            //         ),
            //       // SizedBox(
            //       //   width: getProportionateScreenWidth(10),
            //       // )
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
