import 'dart:developer';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/controllers/service.dart';
import 'package:esoptron_salon/screens/serviceProvider/service_provider.dart';
import 'package:esoptron_salon/screens/servicedetails/service_details.dart';
import 'package:esoptron_salon/utils/enums/global_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Body extends ConsumerStatefulWidget {
  const Body({super.key});

  @override
  ConsumerState<Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<Body> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // GridView.builder(
            //     shrinkWrap: true,
            //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //       childAspectRatio: 0.85,
            //       crossAxisCount: 2,
            //     ),
            //     itemCount: 4,
            //     itemBuilder: (BuildContext context, int index) =>
            //         ratedServiceCard(
            //             "assets/images/home/new4.png", "Nadia Hair & Beauty")),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "New Services",
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
                    log(element.toString());
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Service Providers",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(18),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'krona'),
                  ),
                ],
              ),
            ),
            GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1,
                  crossAxisCount: 2,
                ),
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) =>
                    serviceProvider(index))
          ],
        ),
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
  // Padding ratedServiceCard(String image, String text) {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Container(
  //       width: getProportionateScreenWidth(170),
  //       decoration: BoxDecoration(
  //           border: Border.all(
  //             color: Colors.black,
  //           ),
  //           borderRadius: const BorderRadius.all(Radius.circular(15))),
  //       child: Column(
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.all(6.0),
  //             child: ClipRRect(
  //               borderRadius: const BorderRadius.all(Radius.circular(8)),
  //               child: Image(
  //                   image: AssetImage(image),
  //                   // height: getProportionateScreenHeight(470),
  //                   // width: getProportionateScreenWidth(440),
  //                   fit: BoxFit.cover),
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.all(6.0),
  //             child: Text(
  //               text,
  //               style: TextStyle(
  //                   color: Colors.black,
  //                   fontSize: getProportionateScreenWidth(13),
  //                   fontWeight: FontWeight.bold,
  //                   fontFamily: 'krona'),
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.all(6.0),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   "4.9",
  //                   style: TextStyle(
  //                       color: Colors.black,
  //                       fontSize: getProportionateScreenWidth(10),
  //                       fontWeight: FontWeight.bold,
  //                       fontFamily: 'krona'),
  //                 ),
  //                 for (int i = 0; i < 4; i++)
  //                   Padding(
  //                     padding: const EdgeInsets.all(4.0),
  //                     child: Icon(
  //                       FontAwesomeIcons.solidStar,
  //                       size: 13,
  //                       color: Colors.black.withOpacity(0.4),
  //                     ),
  //                   ),
  //                 SizedBox(
  //                   width: getProportionateScreenWidth(5),
  //                 ),
  //                 Container(
  //                   height: getProportionateScreenHeight(20),
  //                   width: getProportionateScreenWidth(40),
  //                   decoration: const BoxDecoration(
  //                       color: Color.fromRGBO(175, 250, 140, 1),
  //                       borderRadius: BorderRadius.all(Radius.circular(15))),
  //                   child: Center(
  //                     child: Text(
  //                       "Available",
  //                       style: TextStyle(
  //                           color: Colors.black,
  //                           fontSize: getProportionateScreenWidth(8)),
  //                     ),
  //                   ),
  //                 )
  //               ],
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
