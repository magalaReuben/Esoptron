import 'dart:convert';
import 'dart:developer';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/screens/serviceBooking/service_booking.dart';
import 'package:esoptron_salon/widgets/default_button.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ServiceDetails extends StatefulWidget {
  static String routeName = "/service_details";
  const ServiceDetails({super.key});

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  int currentPage = 0;
  bool chip1tapped = true;
  bool chip2tapped = false;
  bool chip3tapped = false;
  bool selected1 = false;
  List favorites = [];
  bool isLoading = false;
  List<dynamic> favoritesServiceId = [];
  Map<int, int> favouritesServiceIdMapper = {};
  PageController? pageController = PageController();
  double sheetHeight = 0.33;
  bool isServiceTypeScreen = true;
  bool isServiceCategoryScreen = false;
  bool isServiceSubCategoryScreen = false;
  String serviceTypeId = "";
  List<bool> checkboxvalues = [];
  String categoryId = "";
  List<int> selectedSubCategories = [];
  List<String> selectedSubCategoriesNames = [];
  List<String> selectedSubCategoriesImages = [];
  int currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    getFavorites();
  }

  Future<NetworkImage> getImage(profileUrl) async {
    final response = await http
        .head(Uri.parse("http://admin.esoptronsalon.com/$profileUrl"));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return NetworkImage("http://admin.esoptronsalon.com/$profileUrl");
    } else {
      return const NetworkImage(
          "http://admin.esoptronsalon.com/storage/users/user.png");
    }
  }

  Future<List<dynamic>> getServiceTypes(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authorizationToken = prefs.getString("auth_token");
    final response = await http.get(
      Uri.parse(
          "http://admin.esoptronsalon.com/api/service/${id[9]}/service_types"),
      headers: {
        'Authorization': 'Bearer $authorizationToken',
        'Content-Type':
            'application/json', // You may need to adjust the content type based on your API requirements
      },
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseData = json.decode(response.body);
      //print(responseData['data']['service_types']);
      return responseData['data']['service_types'];
    } else {
      return [];
    }
  }

  Future<List<dynamic>> getServiceCategories(serviceId, serviceTypeId) async {
    print(
        "Am I here? and this is our service id:${serviceId[9]}and this is our service type id: $serviceTypeId");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authorizationToken = prefs.getString("auth_token");
    final response = await http.get(
      Uri.parse(
          "http://admin.esoptronsalon.com/api/service/${serviceId[9]}/service_type/$serviceTypeId/categories"),
      headers: {
        'Authorization': 'Bearer $authorizationToken',
        'Content-Type':
            'application/json', // You may need to adjust the content type based on your API requirements
      },
    );
    print(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseData = json.decode(response.body);
      //print(responseData['data']['service_types']);
      return responseData['data']['service_type_categories'];
    } else {
      return [];
    }
  }

  Future<List<dynamic>> getServiceSubCategories(serviceId, categoryId) async {
    print(
        "Am I here? and this is our service id:${serviceId[9]}and this is our category id: $categoryId");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authorizationToken = prefs.getString("auth_token");
    final response = await http.get(
      // Uri.parse(
      //     "http://admin.esoptronsalon.com/api/service/${serviceId[9]}/category/$categoryId/sub_categories"),
      Uri.parse(
          "http://admin.esoptronsalon.com/api/service/${serviceId[9]}/sub_categories"),
      headers: {
        'Authorization': 'Bearer $authorizationToken',
        'Content-Type':
            'application/json', // You may need to adjust the content type based on your API requirements
      },
    );
    print(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseData = json.decode(response.body);
      //print(responseData['data']['service_types']);
      return responseData['data']['sub_categories'];
    } else {
      return [];
    }
  }

  Future<List<dynamic>> getServiceImages(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authorizationToken = prefs.getString("auth_token");
    final response = await http.get(
      Uri.parse("http://admin.esoptronsalon.com/api/service/$id/images"),
      headers: {
        'Authorization': 'Bearer $authorizationToken',
        'Content-Type':
            'application/json', // You may need to adjust the content type based on your API requirements
      },
    );
    print(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseData = json.decode(response.body);
      return responseData['data']['images'];
    } else {
      return [];
    }
  }

  Future<List<dynamic>> getFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authorizationToken = prefs.getString("auth_token");
    final response = await http.get(
      Uri.parse("http://admin.esoptronsalon.com/api/user/favourites/services"),
      headers: {
        'Authorization': 'Bearer $authorizationToken',
        'Content-Type':
            'application/json', // You may need to adjust the content type based on your API requirements
      },
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseData = json.decode(response.body);
      setState(() {
        favorites = responseData['data']['favourite_services'];
      });
      for (var element in favorites) {
        if (!favoritesServiceId.contains(element["service_id"])) {
          favoritesServiceId.add(element["service_id"]);
          favouritesServiceIdMapper[element["service_id"]] =
              element["favourite_service_id"];
        }
      }
      // print("This is our favorite data: $favoritesServiceId");
      // print("These are our favorite dics: $favouritesServiceIdMapper");
      return responseData['data']['favourite_services'];
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    return Scaffold(
        body: Stack(children: [
      SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: FutureBuilder<List<dynamic>>(
                  future: getServiceImages(
                      // initially 9
                      arguments[7] ? arguments[8] : arguments[10]),
                  builder: (context, snapshot) {
                    //print('This is our data: ${snapshot.data}');
                    if (snapshot.connectionState == ConnectionState.done) {
                      //print(snapshot.data);
                      return Column(
                        children: [
                          SizedBox(
                              height: getProportionateScreenHeight(350),
                              width: getProportionateScreenWidth(450),
                              child: Image(
                                  image: NetworkImage(
                                      "http://admin.esoptronsalon.com/${snapshot.data![0]['url']}"),
                                  //height: getProportionateScreenHeight(300),
                                  width: getProportionateScreenWidth(450),
                                  fit: BoxFit.cover)),
                        ],
                      );
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: getProportionateScreenHeight(30),
                          ),
                          const CircularProgressIndicator(),
                        ],
                      );
                    }
                  },
                ),
              ),
              Positioned(
                  top: 30,
                  left: 10,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.white,
                    ),
                  )),
              Positioned(
                  top: 30,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: const BorderRadius.all(Radius.circular(23)),
                    ),
                    child: Center(
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, ServiceBooking.routeName,
                                arguments: arguments);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: favoritesServiceId.contains(
                                    arguments[7] ? arguments[8] : arguments[10])
                                ? GestureDetector(
                                    onTap: () async {
                                      await getFavorites();
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      String? authorizationToken =
                                          prefs.getString("auth_token");
                                      final ApiResponse = await http.get(
                                        Uri.parse(
                                            "http://admin.esoptronsalon.com/api/user/favourites/services"),
                                        headers: {
                                          'Authorization':
                                              'Bearer $authorizationToken',
                                          'Content-Type':
                                              'application/json', // You may need to adjust the content type based on your API requirements
                                        },
                                      );
                                      if (ApiResponse.statusCode >= 200 &&
                                          ApiResponse.statusCode < 300) {
                                        final responseData =
                                            json.decode(ApiResponse.body);
                                        setState(() {
                                          favorites = responseData['data']
                                              ['favourite_services'];
                                        });
                                        for (var element in favorites) {
                                          if (!favoritesServiceId.contains(
                                              element["service_id"])) {
                                            favoritesServiceId
                                                .add(element["service_id"]);
                                          }
                                          favouritesServiceIdMapper[
                                                  element["service_id"]] =
                                              element["favourite_service_id"];
                                        }
                                      } else {}
                                      final response = await http.delete(
                                        Uri.parse(
                                            "http://admin.esoptronsalon.com/api/user/favourite_service/${arguments[7] ? favouritesServiceIdMapper[arguments[8]] : favouritesServiceIdMapper[arguments[10]]}/remove"),
                                        headers: {
                                          'Authorization':
                                              'Bearer $authorizationToken',
                                          'Content-Type':
                                              'application/json', // You may need to adjust the content type based on your API requirements
                                        },
                                      );
                                      var test = arguments[7]
                                          ? favouritesServiceIdMapper[
                                              arguments[8]]
                                          : favouritesServiceIdMapper[
                                              arguments[10]];
                                      // print(favouritesServiceIdMapper);
                                      // print(test);
                                      // print(response.body);
                                      if (response.statusCode >= 200 &&
                                          response.statusCode < 300) {
                                        // ignore: use_build_context_synchronously
                                        setState(() {
                                          favoritesServiceId.remove(arguments[7]
                                              ? arguments[8]
                                              : arguments[10]);
                                        });
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                              "Service removed from favorites"),
                                          backgroundColor: kPrimaryColor,
                                          padding: EdgeInsets.all(25),
                                        ));
                                      } else {
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content:
                                              Text("Something wrong happened"),
                                          backgroundColor: kPrimaryColor,
                                          padding: EdgeInsets.all(25),
                                        ));
                                      }
                                    },
                                    child: const Icon(Icons.favorite,
                                        color: Colors.red, size: 30),
                                  )
                                : GestureDetector(
                                    onTap: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      String? authorizationToken =
                                          prefs.getString("auth_token");
                                      await getFavorites();
                                      final response = await http.post(
                                        Uri.parse(
                                            "http://admin.esoptronsalon.com/api/user/service/${arguments[7] ? arguments[8] : arguments[10]}/add_favourites"),
                                        headers: {
                                          'Authorization':
                                              'Bearer $authorizationToken',
                                          'Content-Type':
                                              'application/json', // You may need to adjust the content type based on your API requirements
                                        },
                                      );
                                      print(response.body);
                                      if (response.statusCode >= 200 &&
                                          response.statusCode < 300) {
                                        // ignore: use_build_context_synchronously
                                        setState(() {
                                          favoritesServiceId.add(arguments[7]
                                              ? arguments[8]
                                              : arguments[10]);
                                        });
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                              "Service Added to favorites"),
                                          backgroundColor: kPrimaryColor,
                                          padding: EdgeInsets.all(25),
                                        ));
                                      } else {
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content:
                                              Text("Something wrong happened"),
                                          backgroundColor: kPrimaryColor,
                                          padding: EdgeInsets.all(25),
                                        ));
                                      }
                                    },
                                    child: const Icon(Icons.favorite,
                                        color: Colors.black, size: 30)),
                          )),
                    ),
                  )),
              Positioned(
                  bottom: 0,
                  left: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      arguments[0],
                      style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: getProportionateScreenWidth(18),
                        fontWeight: FontWeight.w500,
                      )),
                    ),
                  )),
              Positioned(
                bottom: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        for (int i = 0; i < arguments[6]; i++)
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              FontAwesomeIcons.solidStar,
                              size: 16,
                              color: Colors.orangeAccent,
                            ),
                          ),
                        for (int i = 0; i < 5 - arguments[6]; i++)
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              FontAwesomeIcons.solidStar,
                              size: 16,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: getProportionateScreenHeight(25),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                          alignment: Alignment.topLeft,
                          //padding: const EdgeInsets.only(top: 8.0),
                          child: Text("Description",
                              softWrap: true,
                              maxLines: 3,
                              style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: getProportionateScreenWidth(15),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'krona')))),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        //padding: const EdgeInsets.only(top: 8.0),
                        child: Text(arguments[2],
                            softWrap: true,
                            maxLines: 3,
                            style: GoogleFonts.nunitoSans(
                                textStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.8),
                                    fontSize: getProportionateScreenWidth(13),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'krona'))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          arguments[7]
              ? Container()
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text("Service",
                          softWrap: true,
                          maxLines: 3,
                          style: GoogleFonts.nunitoSans(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: getProportionateScreenWidth(15),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'krona'))),
                    ],
                  ),
                ),
          arguments[7]
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                                alignment: Alignment.topLeft,
                                //padding: const EdgeInsets.only(top: 8.0),
                                child: Text("Contact",
                                    softWrap: true,
                                    maxLines: 3,
                                    style: GoogleFonts.nunitoSans(
                                        textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize:
                                                getProportionateScreenWidth(15),
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'krona')))),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              //padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.person,
                                      size: 25,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(arguments[3]["name"].toString(),
                                      softWrap: true,
                                      maxLines: 3,
                                      style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      13),
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'krona'))),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              //padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.email,
                                      size: 25,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(arguments[3]["email"].toString(),
                                      softWrap: true,
                                      maxLines: 3,
                                      style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      13),
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'krona'))),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              //padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.phone,
                                      size: 25,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(arguments[3]["phone"].toString(),
                                      softWrap: true,
                                      maxLines: 3,
                                      style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      13),
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'krona'))),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Container(
                      height: getProportionateScreenHeight(170),
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
                                  image: NetworkImage(arguments[8]),
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
                                    '${arguments[9]} \n UGX ${arguments[12]}',
                                    style: GoogleFonts.nunitoSans(
                                        textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: getProportionateScreenWidth(18),
                                      fontWeight: FontWeight.w500,
                                    )),
                                  ),
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(5),
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        foregroundColor: kPrimaryColor,
                                        backgroundColor: kPrimaryColor),
                                    onPressed: () => Navigator.pushNamed(
                                            context, ServiceBooking.routeName,
                                            arguments: [
                                              arguments[0],
                                              [arguments[8]],
                                              [arguments[9]],
                                              arguments[10],
                                              [arguments[11]]
                                            ]),
                                    child: Text(
                                      "Proceed to Booking",
                                      style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      12),
                                              fontWeight: FontWeight.w500)),
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
          const SizedBox(height: 10),
          arguments[7]
              ? SizedBox(
                  height: getProportionateScreenHeight(200),
                )
              : SizedBox(
                  height: getProportionateScreenHeight(80),
                )
        ]),
      ),
      arguments[7]
          ? Container()
          // ? Align(
          //     alignment: Alignment.bottomCenter,
          //     child: DraggableScrollableSheet(
          //         key: const Key("sheet"),
          //         initialChildSize: sheetHeight,
          //         minChildSize: 0.2,
          //         maxChildSize: 0.85,
          //         builder: (_, ScrollController scrollController) => Scaffold(
          //               body: isServiceTypeScreen
          //                   ? SingleChildScrollView(
          //                       controller: scrollController,
          //                       child: Padding(
          //                         padding: const EdgeInsets.all(8.0),
          //                         child: Column(children: [
          //                           FutureBuilder<List<dynamic>>(
          //                             future: getServiceTypes(arguments),
          //                             builder: (context, snapshot) {
          //                               //print(arguments);
          //                               if (snapshot.connectionState ==
          //                                   ConnectionState.done) {
          //                                 return Column(
          //                                   children: [
          //                                     Row(
          //                                       mainAxisAlignment:
          //                                           MainAxisAlignment.start,
          //                                       children: [
          //                                         Text(" Select Type",
          //                                             style: TextStyle(
          //                                                 color: Colors.black,
          //                                                 fontSize:
          //                                                     getProportionateScreenWidth(
          //                                                         18),
          //                                                 fontWeight:
          //                                                     FontWeight.bold,
          //                                                 fontFamily: 'krona')),
          //                                       ],
          //                                     ),
          //                                     for (var element
          //                                         in snapshot.data!)
          //                                       Padding(
          //                                         padding:
          //                                             const EdgeInsets.only(
          //                                                 top: 10.0),
          //                                         child: GestureDetector(
          //                                           onTap: () {
          //                                             setState(() {
          //                                               isServiceTypeScreen =
          //                                                   false;
          //                                               isServiceCategoryScreen =
          //                                                   true;
          //                                               serviceTypeId =
          //                                                   element["id"]
          //                                                       .toString();
          //                                             });
          //                                           },
          //                                           child: Container(
          //                                             height:
          //                                                 getProportionateScreenHeight(
          //                                                     100),
          //                                             decoration: BoxDecoration(
          //                                                 borderRadius:
          //                                                     BorderRadius
          //                                                         .circular(10),
          //                                                 color: Colors.white
          //                                                     .withOpacity(0.5),
          //                                                 border: Border.all(
          //                                                     color: kPrimaryColor
          //                                                         .withOpacity(
          //                                                             0.5))),
          //                                             child: ListTile(
          //                                               leading: Image(
          //                                                 image: NetworkImage(
          //                                                     "http://admin.esoptronsalon.com/${element["image"]}"),
          //                                               ),
          //                                               title: Text(
          //                                                   "${element["name"]}",
          //                                                   style:
          //                                                       const TextStyle(
          //                                                           color: Colors
          //                                                               .black)),

          //                                               // subtitle: Padding(
          //                                               //   padding:
          //                                               //       const EdgeInsets.only(
          //                                               //           top: 8.0),
          //                                               //   child: Text(
          //                                               //       "${element["charge"]}",
          //                                               //       style: const TextStyle(
          //                                               //           color:
          //                                               //               Colors.black,
          //                                               //           fontWeight:
          //                                               //               FontWeight
          //                                               //                   .bold)),
          //                                               // ),
          //                                               // trailing: Checkbox(
          //                                               //     value: selected1,
          //                                               //     onChanged:
          //                                               //         (bool? value) {
          //                                               //       setState(() {
          //                                               //         selected1 = value!;
          //                                               //       });
          //                                               //     }),
          //                                             ),
          //                                           ),
          //                                         ),
          //                                       )
          //                                   ],
          //                                 );
          //                               } else {
          //                                 // You can return a placeholder or loading indicator while the image is loading
          //                                 return const CircularProgressIndicator();
          //                               }
          //                             },
          //                           ),
          //                         ]),
          //                       ))
          //                   : isServiceCategoryScreen
          //                       ? SingleChildScrollView(
          //                           controller: scrollController,
          //                           child: Padding(
          //                             padding: const EdgeInsets.all(8.0),
          //                             child: Column(children: [
          //                               FutureBuilder<List<dynamic>>(
          //                                 future: getServiceCategories(
          //                                     arguments, serviceTypeId),
          //                                 builder: (context, snapshot) {
          //                                   //print(arguments);
          //                                   if (snapshot.connectionState ==
          //                                       ConnectionState.done) {
          //                                     //print(snapshot.data);
          //                                     return Column(
          //                                       children: [
          //                                         Row(
          //                                           mainAxisAlignment:
          //                                               MainAxisAlignment.start,
          //                                           children: [
          //                                             Text(" Select Category",
          //                                                 style: TextStyle(
          //                                                     color:
          //                                                         Colors.black,
          //                                                     fontSize:
          //                                                         getProportionateScreenWidth(
          //                                                             18),
          //                                                     fontWeight:
          //                                                         FontWeight
          //                                                             .bold,
          //                                                     fontFamily:
          //                                                         'krona')),
          //                                           ],
          //                                         ),
          //                                         for (var element
          //                                             in snapshot.data!)
          //                                           Padding(
          //                                             padding:
          //                                                 const EdgeInsets.only(
          //                                                     top: 10.0),
          //                                             child: GestureDetector(
          //                                               onTap: () {
          //                                                 setState(() {
          //                                                   isServiceCategoryScreen =
          //                                                       false;
          //                                                   isServiceSubCategoryScreen =
          //                                                       true;
          //                                                   categoryId =
          //                                                       element["id"]
          //                                                           .toString();
          //                                                 });
          //                                               },
          //                                               child: Container(
          //                                                 height:
          //                                                     getProportionateScreenHeight(
          //                                                         100),
          //                                                 decoration: BoxDecoration(
          //                                                     borderRadius:
          //                                                         BorderRadius.circular(
          //                                                             10),
          //                                                     color: Colors
          //                                                         .white
          //                                                         .withOpacity(
          //                                                             0.5),
          //                                                     border: Border.all(
          //                                                         color: kPrimaryColor
          //                                                             .withOpacity(
          //                                                                 0.5))),
          //                                                 child: ListTile(
          //                                                   leading: Image(
          //                                                     image: NetworkImage(
          //                                                         "http://admin.esoptronsalon.com/storage/sub_categories/${element["image"]}"),
          //                                                   ),
          //                                                   title: Text(
          //                                                       "${element["name"]}",
          //                                                       style: const TextStyle(
          //                                                           color: Colors
          //                                                               .black)),

          //                                                   // subtitle: Padding(
          //                                                   //   padding:
          //                                                   //       const EdgeInsets.only(
          //                                                   //           top: 8.0),
          //                                                   //   child: Text(
          //                                                   //       "${element["charge"]}",
          //                                                   //       style: const TextStyle(
          //                                                   //           color:
          //                                                   //               Colors.black,
          //                                                   //           fontWeight:
          //                                                   //               FontWeight
          //                                                   //                   .bold)),
          //                                                   // ),
          //                                                   // trailing: Checkbox(
          //                                                   //     value: selected1,
          //                                                   //     onChanged:
          //                                                   //         (bool? value) {
          //                                                   //       setState(() {
          //                                                   //         selected1 = value!;
          //                                                   //       });
          //                                                   //     }),
          //                                                 ),
          //                                               ),
          //                                             ),
          //                                           )
          //                                       ],
          //                                     );
          //                                   } else {
          //                                     // You can return a placeholder or loading indicator while the image is loading
          //                                     return const CircularProgressIndicator();
          //                                   }
          //                                 },
          //                               ),
          //                             ]),
          //                           ))
          //                       : isServiceSubCategoryScreen
          //                           ? SingleChildScrollView(
          //                               controller: scrollController,
          //                               child: Padding(
          //                                 padding: const EdgeInsets.all(8.0),
          //                                 child: Column(children: [
          //                                   FutureBuilder<List<dynamic>>(
          //                                     future: getServiceSubCategories(
          //                                         arguments, categoryId),
          //                                     builder: (context, snapshot) {
          //                                       //print(arguments);
          //                                       if (snapshot.connectionState ==
          //                                           ConnectionState.done) {
          //                                         for (int i = 0;
          //                                             i < snapshot.data!.length;
          //                                             i++) {
          //                                           checkboxvalues.add(false);
          //                                         }
          //                                         return Column(
          //                                           children: [
          //                                             Row(
          //                                               mainAxisAlignment:
          //                                                   MainAxisAlignment
          //                                                       .start,
          //                                               children: [
          //                                                 Text(
          //                                                     " Select Sub Category",
          //                                                     style: TextStyle(
          //                                                         color: Colors
          //                                                             .black,
          //                                                         fontSize:
          //                                                             getProportionateScreenWidth(
          //                                                                 18),
          //                                                         fontWeight:
          //                                                             FontWeight
          //                                                                 .bold,
          //                                                         fontFamily:
          //                                                             'krona')),
          //                                               ],
          //                                             ),
          //                                             for (int i = 0;
          //                                                 i <
          //                                                     snapshot
          //                                                         .data!.length;
          //                                                 i++)
          //                                               Padding(
          //                                                 padding:
          //                                                     const EdgeInsets
          //                                                         .only(
          //                                                         top: 10.0),
          //                                                 child: Container(
          //                                                   height:
          //                                                       getProportionateScreenHeight(
          //                                                           120),
          //                                                   decoration: BoxDecoration(
          //                                                       borderRadius:
          //                                                           BorderRadius
          //                                                               .circular(
          //                                                                   10),
          //                                                       color: Colors
          //                                                           .white
          //                                                           .withOpacity(
          //                                                               0.5),
          //                                                       border: Border.all(
          //                                                           color: kPrimaryColor
          //                                                               .withOpacity(
          //                                                                   0.5))),
          //                                                   child: ListTile(
          //                                                     leading:
          //                                                         ClipRRect(
          //                                                       borderRadius:
          //                                                           BorderRadius
          //                                                               .circular(
          //                                                                   15),
          //                                                       child: Image(
          //                                                         image: NetworkImage(
          //                                                             "http://admin.esoptronsalon.com/${snapshot.data![i]["image"]}"),
          //                                                       ),
          //                                                     ),
          //                                                     title: Text(
          //                                                         "${snapshot.data![i]["name"]}",
          //                                                         style: const TextStyle(
          //                                                             color: Colors
          //                                                                 .black)),
          //                                                     subtitle: Padding(
          //                                                       padding:
          //                                                           const EdgeInsets
          //                                                               .only(
          //                                                               top:
          //                                                                   8.0),
          //                                                       child: Text(
          //                                                           "${snapshot.data![i]["charge"]}",
          //                                                           style: const TextStyle(
          //                                                               color: Colors
          //                                                                   .black,
          //                                                               fontWeight:
          //                                                                   FontWeight.bold)),
          //                                                     ),
          //                                                     trailing:
          //                                                         Checkbox(
          //                                                             value:
          //                                                                 checkboxvalues[
          //                                                                     i],
          //                                                             onChanged:
          //                                                                 (bool?
          //                                                                     value) {
          //                                                               setState(
          //                                                                   () {
          //                                                                 checkboxvalues[i] =
          //                                                                     value!;
          //                                                               });
          //                                                               if (!selectedSubCategories.contains(snapshot.data![i]
          //                                                                   [
          //                                                                   "id"])) {
          //                                                                 selectedSubCategories.add(snapshot.data![i]
          //                                                                     [
          //                                                                     "id"]);
          //                                                                 selectedSubCategoriesNames.add(snapshot.data![i]
          //                                                                     [
          //                                                                     "name"]);
          //                                                                 selectedSubCategoriesImages
          //                                                                     .add("http://admin.esoptronsalon.com/${snapshot.data![i]["image"]}");
          //                                                               } else {
          //                                                                 selectedSubCategories.remove(snapshot.data![i]
          //                                                                     [
          //                                                                     "id"]);
          //                                                                 selectedSubCategoriesNames.remove(snapshot.data![i]
          //                                                                     [
          //                                                                     "name"]);
          //                                                                 selectedSubCategoriesImages
          //                                                                     .remove("http://admin.esoptronsalon.com/${snapshot.data![i]["image"]}");
          //                                                               }
          //                                                               //print(selectedSubCategories);
          //                                                             }),
          //                                                   ),
          //                                                 ),
          //                                               ),
          //                                             SizedBox(
          //                                               height:
          //                                                   getProportionateScreenHeight(
          //                                                       100),
          //                                             )
          //                                           ],
          //                                         );
          //                                       } else {
          //                                         // You can return a placeholder or loading indicator while the image is loading
          //                                         return const CircularProgressIndicator();
          //                                       }
          //                                     },
          //                                   ),
          //                                 ]),
          //                               ))
          //                           : Container(),
          //               appBar: AppBar(
          //                 centerTitle: true,
          //                 actions: [
          //                   sheetHeight == 0.85
          //                       ? GestureDetector(
          //                           onTap: () {
          //                             setState(() {
          //                               sheetHeight = 0.33;
          //                             });
          //                           },
          //                           child: const Icon(
          //                             Icons.keyboard_arrow_down,
          //                             size: 30,
          //                             color: kPrimaryColor,
          //                           ),
          //                         )
          //                       : GestureDetector(
          //                           onTap: () {
          //                             setState(() {
          //                               sheetHeight = 0.85;
          //                             });
          //                           },
          //                           child: const Icon(
          //                             Icons.keyboard_arrow_up,
          //                             size: 30,
          //                             color: kPrimaryColor,
          //                           ),
          //                         ),
          //                 ],
          //                 automaticallyImplyLeading: false,
          //                 shadowColor: Colors.transparent,
          //                 backgroundColor: Colors.white,
          //                 title: Text("",
          //                     style: TextStyle(
          //                         color: Colors.black,
          //                         fontSize: getProportionateScreenWidth(18),
          //                         fontWeight: FontWeight.bold,
          //                         fontFamily: 'krona')),
          //               ),
          //             )))
          : Container(),
      arguments[7]
          ? Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  color: Colors.white,
                  height: getProportionateScreenHeight(85),
                  child: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: getProportionateScreenHeight(56),
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: arguments[7]
                                      ? checkboxvalues.contains(true)
                                          ? [kPrimaryColor, kPrimaryColor]
                                          : [Colors.grey, Colors.grey]
                                      : [
                                          kPrimaryColor,
                                          kPrimaryColor.withOpacity(0.8)
                                        ]),
                              borderRadius: BorderRadius.circular(15.0)),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              primary: Colors.transparent,
                            ),
                            onPressed: () {
                              if (arguments[7]) {
                                if (checkboxvalues.contains(true)) {
                                  Navigator.pushNamed(
                                      context, ServiceBooking.routeName,
                                      arguments: [
                                        arguments[0],
                                        selectedSubCategoriesImages,
                                        selectedSubCategoriesNames,
                                        arguments[9],
                                        selectedSubCategories
                                      ]);
                                } else {
                                  () => {};
                                }
                              } else {
                                Navigator.pushNamed(
                                    context, ServiceBooking.routeName,
                                    arguments: [
                                      arguments[0],
                                      [arguments[8]],
                                      [arguments[9]],
                                      arguments[10],
                                      [arguments[11]]
                                    ]);
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                arguments[7]
                                    ? Text(
                                        checkboxvalues.contains(true)
                                            ? "Proceed"
                                            : "Select Category",
                                        style: TextStyle(
                                          fontSize:
                                              getProportionateScreenWidth(18),
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        "Proceed",
                                        style: TextStyle(
                                          fontSize:
                                              getProportionateScreenWidth(18),
                                          color: Colors.white,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ))
                  // DefaultButton(
                  //   press: () =>
                  //       Navigator.pushNamed(context, ServiceBooking.routeName),
                  //   text: "Book Now",
                  // ),
                  ),
            )
          : Container(),
      //const SizedBox(height: 30)
    ]));
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
