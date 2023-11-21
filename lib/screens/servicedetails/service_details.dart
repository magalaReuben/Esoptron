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
  PageController? pageController = PageController();

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
    final response = await http.get(Uri.parse(
        "http://admin.esoptronsalon.com/api/service/19/sub_categories"));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseData = json.decode(response.body);
      return responseData['data']['sub_categories'];
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
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
          Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: CarouselSlider(
                      items: [
                        SizedBox(
                          //height: getProportionateScreenHeight(100),
                          child: Image(
                              image: NetworkImage("${arguments[1]}"),
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
                          aspectRatio: 2.1,
                          initialPage: 1)),
                ),
                // Positioned(
                //   left: getProportionateScreenWidth(450) / 2.8,
                //   bottom: 25,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: List.generate(
                //       3,
                //       (index) => buildDot(index: index),
                //     ),
                //   ),
                // ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.favorite_outline,
                        color: kPrimaryColor, size: 25),
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
                        color: Colors.yellow,
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
                                                getProportionateScreenWidth(18),
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
                                )
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  arguments[9],
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: getProportionateScreenWidth(18),
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
          ]),
          arguments[7]
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: DraggableScrollableSheet(
                      initialChildSize: arguments[5] ? 0.25 : 0.40,
                      minChildSize: 0.3,
                      maxChildSize: 0.85,
                      builder: (_, ScrollController scrollController) =>
                          Scaffold(
                            body: SingleChildScrollView(
                                controller: scrollController,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(children: [
                                    ListTile(
                                      leading: FutureBuilder<List<dynamic>>(
                                        future: getSubCategories(arguments[9]),
                                        builder: (context, snapshot) {
                                          //print(snapshot);
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            return SingleChildScrollView(
                                                child: Column(
                                              children: [
                                                for (var element
                                                    in snapshot.data!)
                                                  ListTile(
                                                    leading: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.5),
                                                            border: Border.all(
                                                                color: kPrimaryColor
                                                                    .withOpacity(
                                                                        0.5))),
                                                        child: Image.asset(
                                                            "http://admin.esoptronsalon.com/${element["image"]}")),
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
                                                  )
                                              ],
                                            ));
                                          } else {
                                            // You can return a placeholder or loading indicator while the image is loading
                                            return const CircularProgressIndicator();
                                          }
                                        },
                                      ),
                                    )
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
                child: DefaultButton(
                  press: () =>
                      Navigator.pushNamed(context, ServiceBooking.routeName),
                  text: "Book Now",
                ),
              ),
            ),
          ),
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
