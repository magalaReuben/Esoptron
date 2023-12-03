import 'dart:convert';
import 'dart:developer';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/screens/serviceBooking/service_booking.dart';
import 'package:esoptron_salon/widgets/default_button.dart';
import 'package:flutter/material.dart';
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

  Future<List<dynamic>> getSubCategories(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authorizationToken = prefs.getString("auth_token");
    final response = await http.get(
      Uri.parse(
          "http://admin.esoptronsalon.com/api/service/$id/sub_categories"),
      headers: {
        'Authorization': 'Bearer $authorizationToken',
        'Content-Type':
            'application/json', // You may need to adjust the content type based on your API requirements
      },
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseData = json.decode(response.body);
      return responseData['data']['sub_categories'];
    } else {
      return [];
    }
  }

  Future<List<dynamic>> getServiceImages(id) async {
    //print('my test id: $id');
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
    //print(response.body);
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
      print("This is our favorite data: $favoritesServiceId");
      print("These are our favorite dics: $favouritesServiceIdMapper");
      return responseData['data']['favourite_services'];
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    print("These are our arguments: ${arguments}");
    CarouselController buttonCarouselController = CarouselController();
    log(arguments.toString());
    return Scaffold(
        //bottomNavigationBar: Container(),
        appBar: AppBar(
          title: Text(
            arguments[0],
            style: TextStyle(fontSize: getProportionateScreenWidth(18)),
          ),
        ),
        body: Stack(children: [
          SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: FutureBuilder<List<dynamic>>(
                      future: getServiceImages(
                          arguments[7] ? arguments[9] : arguments[10]),
                      builder: (context, snapshot) {
                        //print('This is our data: ${snapshot.data}');
                        if (snapshot.connectionState == ConnectionState.done) {
                          //print(snapshot.data);
                          return CarouselSlider(
                              items: [
                                for (int i = 0; i < snapshot.data!.length; i++)
                                  SizedBox(
                                    //height: getProportionateScreenHeight(100),
                                    child: Image(
                                        image: NetworkImage(
                                            "http://admin.esoptronsalon.com/${snapshot.data![i]['url']}"),
                                        //height: getProportionateScreenHeight(300),
                                        width: getProportionateScreenWidth(450),
                                        fit: BoxFit.cover),
                                  ),
                              ],
                              carouselController: buttonCarouselController,
                              options: CarouselOptions(
                                  autoPlay: false,
                                  enlargeCenterPage: true,
                                  viewportFraction: 1,
                                  aspectRatio: 1.5,
                                  initialPage: 1));
                        } else {
                          // You can return a placeholder or loading indicator while the image is loading
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
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: favoritesServiceId.contains(
                              arguments[7] ? arguments[9] : arguments[10])
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
                                    if (!favoritesServiceId
                                        .contains(element["service_id"])) {
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
                                      "http://admin.esoptronsalon.com/api/user/favourite_service/${arguments[7] ? favouritesServiceIdMapper[arguments[9]] : favouritesServiceIdMapper[arguments[10]]}/remove"),
                                  headers: {
                                    'Authorization':
                                        'Bearer $authorizationToken',
                                    'Content-Type':
                                        'application/json', // You may need to adjust the content type based on your API requirements
                                  },
                                );
                                var test = arguments[7]
                                    ? favouritesServiceIdMapper[arguments[9]]
                                    : favouritesServiceIdMapper[arguments[10]];
                                print(favouritesServiceIdMapper);
                                print(test);
                                print(response.body);
                                if (response.statusCode >= 200 &&
                                    response.statusCode < 300) {
                                  // ignore: use_build_context_synchronously
                                  setState(() {
                                    favoritesServiceId.remove(arguments[7]
                                        ? arguments[9]
                                        : arguments[10]);
                                  });
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content:
                                        Text("Service removed from favorites"),
                                    backgroundColor: kPrimaryColor,
                                    padding: EdgeInsets.all(25),
                                  ));
                                } else {
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Something wrong happened"),
                                    backgroundColor: kPrimaryColor,
                                    padding: EdgeInsets.all(25),
                                  ));
                                }
                              },
                              child: const Icon(Icons.favorite,
                                  color: kPrimaryColor, size: 25),
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
                                      "http://admin.esoptronsalon.com/api/user/service/${arguments[7] ? arguments[9] : arguments[10]}/add_favourites"),
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
                                        ? arguments[9]
                                        : arguments[10]);
                                  });
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Service Added to favorites"),
                                    backgroundColor: kPrimaryColor,
                                    padding: EdgeInsets.all(25),
                                  ));
                                } else {
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Something wrong happened"),
                                    backgroundColor: kPrimaryColor,
                                    padding: EdgeInsets.all(25),
                                  ));
                                }
                              },
                              child: const Icon(Icons.favorite_outline)),
                    ),
                    Container(
                      height: getProportionateScreenHeight(30),
                      width: getProportionateScreenWidth(80),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(175, 250, 140, 1),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Center(
                        child: Text(
                          arguments[5] ? "Available" : "Unavailable",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(12),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  //padding: const EdgeInsets.only(top: 8.0),
                  child: Text(arguments[2],
                      softWrap: true,
                      maxLines: 3,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(15),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'krona')),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    Text(
                      "${arguments[6]}",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(13),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'krona'),
                    ),
                    for (int i = 0; i < arguments[6]; i++)
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          FontAwesomeIcons.solidStar,
                          size: 13,
                          color: Colors.orangeAccent,
                        ),
                      ),
                    for (int i = 0; i < 5 - arguments[6]; i++)
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          FontAwesomeIcons.solidStar,
                          size: 13,
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ),
                  ],
                ),
              ),
              arguments[7]
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: getProportionateScreenHeight(100),
                          width: getProportionateScreenWidth(360),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                width: 2,
                                color: kPrimaryColor.withOpacity(0.2),
                              )),
                          child: Center(
                            child: ListTile(
                              leading: FutureBuilder<NetworkImage>(
                                future: getImage(arguments[3]["avatar"]),
                                builder: (context, snapshot) {
                                  //print(snapshot);
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return CircleAvatar(
                                      radius: 25,
                                      backgroundImage: snapshot.data,
                                    );
                                  } else {
                                    // You can return a placeholder or loading indicator while the image is loading
                                    return const CircularProgressIndicator();
                                  }
                                },
                              ),
                              title: Text("Service Provider",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: getProportionateScreenWidth(18),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'krona')),
                              subtitle: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(arguments[3]["name"],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      18),
                                              fontWeight: FontWeight.normal,
                                              fontFamily: 'krona')),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.email,
                                          size: 15,
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                      Text(
                                        arguments[3]["email"],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize:
                                                getProportionateScreenWidth(13),
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'krona'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )),
                    )
                  : Padding(
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
                                image: NetworkImage(arguments[8]),
                                fit: BoxFit.cover),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    arguments[9],
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize:
                                            getProportionateScreenWidth(18),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'krona'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              // const SizedBox(height: 10),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Text("Service Images",
              //         style: TextStyle(
              //             color: Colors.black,
              //             fontSize: getProportionateScreenWidth(18),
              //             fontWeight: FontWeight.bold,
              //             fontFamily: 'krona')),
              //   ],
              // )
            ]),
          ),
          arguments[7]
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: DraggableScrollableSheet(
                      initialChildSize: arguments[5] ? 0.2 : 0.25,
                      minChildSize: 0.2,
                      maxChildSize: 0.85,
                      builder: (_, ScrollController scrollController) =>
                          Scaffold(
                            body: SingleChildScrollView(
                                controller: scrollController,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(children: [
                                    FutureBuilder<List<dynamic>>(
                                      future: getSubCategories(arguments[8]),
                                      builder: (context, snapshot) {
                                        //print(arguments);
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          return Column(
                                            children: [
                                              for (var element
                                                  in snapshot.data!)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: ListTile(
                                                    leading: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.5),
                                                            border: Border.all(
                                                                color: kPrimaryColor
                                                                    .withOpacity(
                                                                        0.5))),
                                                        child: Image(
                                                          image: NetworkImage(
                                                              "http://admin.esoptronsalon.com/${element["image"]}"),
                                                        )),
                                                    title: Text(
                                                        "${element["name"]}",
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black)),
                                                    subtitle: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: Text(
                                                          "${element["charge"]}",
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                    trailing: Checkbox(
                                                        value: selected1,
                                                        onChanged:
                                                            (bool? value) {
                                                          setState(() {
                                                            selected1 = value!;
                                                          });
                                                        }),
                                                  ),
                                                )
                                            ],
                                          );
                                        } else {
                                          // You can return a placeholder or loading indicator while the image is loading
                                          return const CircularProgressIndicator();
                                        }
                                      },
                                    ),
                                  ]),
                                )),
                            appBar: AppBar(
                              centerTitle: true,
                              actions: const [
                                Icon(
                                  Icons.keyboard_arrow_up,
                                  size: 30,
                                  color: kPrimaryColor,
                                ),
                              ],
                              automaticallyImplyLeading: false,
                              shadowColor: Colors.transparent,
                              backgroundColor: Colors.white,
                              title: Text("",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: getProportionateScreenWidth(18),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'krona')),
                            ),
                          )))
              : Container(),
          Align(
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
                                    ? selected1
                                        ? [kPrimaryColor, kPrimaryColor]
                                        : [Colors.grey, Colors.grey]
                                    : [kPrimaryColor, kPrimaryColor]),
                            borderRadius: BorderRadius.circular(15.0)),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            primary: Colors.transparent,
                          ),
                          onPressed: () {
                            if (arguments[7]) {
                              if (selected1) {
                                Navigator.pushNamed(
                                    context, ServiceBooking.routeName,
                                    arguments: [
                                      arguments[0],
                                      arguments[8],
                                      arguments[9],
                                      arguments[10],
                                      arguments[11]
                                    ]);
                              } else {
                                () => {};
                              }
                            } else {
                              Navigator.pushNamed(
                                  context, ServiceBooking.routeName,
                                  arguments: [
                                    arguments[0],
                                    arguments[8],
                                    arguments[9],
                                    arguments[10],
                                    arguments[11]
                                  ]);
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              arguments[7]
                                  ? Text(
                                      selected1 ? "Proceed" : "Select Category",
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
          ),
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
