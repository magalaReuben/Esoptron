import 'package:awesome_icons/awesome_icons.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:flutter/material.dart';

class ServiceProvider extends StatelessWidget {
  static String routeName = "service_provider";

  const ServiceProvider({super.key});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Service Provider",
            style: TextStyle(fontSize: getProportionateScreenWidth(18)),
          ),
        ),
        body: Stack(children: [
          Column(children: [
            Stack(children: [
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: getProportionateScreenHeight(150),
                  child: Image(
                      image: const AssetImage(
                          "assets/images/serviceDetails/waxingWoman.png"),
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
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 35,
                          foregroundImage: AssetImage(arguments[0]),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ]),
            // SizedBox(
            //   height: getProportionateScreenHeight(20),
            // ),
            Text(
              "John Joshua",
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
              "40 Ratings",
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
                    "Service Offering",
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
                    "Dreads",
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
                  Text(
                    "Free after 4hrs",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(15),
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
                    "M",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(15),
                        fontWeight: FontWeight.normal,
                        fontFamily: 'krona'),
                  ),
                ]),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: getProportionateScreenHeight(100),
                width: getProportionateScreenWidth(360),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      width: 2,
                      color: kPrimaryColor.withOpacity(0.2),
                    )),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 30,
                        foregroundImage: AssetImage(
                            "assets/images/serviceDetails/review.png"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Mrs Bimbo",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: getProportionateScreenWidth(18),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'krona')),
                          Text("Right on time",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: getProportionateScreenWidth(18),
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'krona')),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(30),
                    ),
                    for (int i = 0; i < 5; i++)
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          FontAwesomeIcons.solidStar,
                          size: 8,
                          color: kPrimaryColor.withOpacity(0.4),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: getProportionateScreenHeight(100),
                width: getProportionateScreenWidth(360),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      width: 2,
                      color: kPrimaryColor.withOpacity(0.2),
                    )),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 30,
                        foregroundImage: AssetImage(
                            "assets/images/serviceDetails/review.png"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Gentle Ibe",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: getProportionateScreenWidth(18),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'krona')),
                          Text("Right on time",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: getProportionateScreenWidth(18),
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'krona')),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(30),
                    ),
                    for (int i = 0; i < 5; i++)
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          FontAwesomeIcons.solidStar,
                          size: 8,
                          color: kPrimaryColor.withOpacity(0.4),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ]),
        ]));
  }
}
