import 'dart:developer';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/controllers/service.dart';
import 'package:esoptron_salon/controllers/serviceProviders.dart';
import 'package:esoptron_salon/providers/contentProvisionProviders.dart';
import 'package:esoptron_salon/providers/profileProviders.dart';
import 'package:esoptron_salon/screens/serviceProvider/service_provider.dart';
import 'package:esoptron_salon/screens/servicedetails/service_details.dart';
import 'package:esoptron_salon/screens/servicesUnderSubCategory/servicesUnderSubcategory.dart';
import 'package:esoptron_salon/utils/enums/global_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Body extends ConsumerStatefulWidget {
  const Body({super.key});

  @override
  ConsumerState<Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<Body> {
  var serviceProviderNames = [
    'Mutesi Irene',
    'Phiona Mugenyi',
    'Namubiru Ruth',
    'Ainebyona Daphine'
  ];

  Future<NetworkImage> getImage() async {
    final profileUrl = ref.watch(profilePicProvider);
    final response = await http
        .head(Uri.parse("http://admin.esoptronsalon.com/$profileUrl"));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return NetworkImage("http://admin.esoptronsalon.com/$profileUrl");
    } else {
      return const NetworkImage(
          "http://admin.esoptronsalon.com/storage/users/user.png");
    }
  }

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
                  Text("Let's take care\nof you ❤️️",
                      style: GoogleFonts.nunitoSans(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(24),
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  SizedBox(width: getProportionateScreenWidth(70)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder<NetworkImage>(
                      future: getImage(),
                      builder: (context, snapshot) {
                        //print(snapshot);
                        if (snapshot.connectionState == ConnectionState.done) {
                          return CircleAvatar(
                            radius: 35,
                            backgroundImage: snapshot.data,
                          );
                        } else {
                          // You can return a placeholder or loading indicator while the image is loading
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(12)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Services",
                      style: GoogleFonts.nunitoSans(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(18),
                          fontWeight: FontWeight.bold,
                        ),
                      )),
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
                  print(servicesState.data!.data.toString());
                  for (var element
                      in servicesState.data!.data['all-subCategories']) {
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
                            child: servicesCard(
                              "http://admin.esoptronsalon.com/${services[i]["image"]}",
                              services[i]["name"],
                              services[i]["charge"].toString(),
                              services[i]["description"],
                              services[i]['has_discount'],
                              services[i]['id'],
                            ),
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
                              "No services available at the moment",
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Service Providers",
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
            Builder(builder: (context) {
              final servicesProvidersState =
                  ref.watch(serviceProvidersProvider);
              switch (servicesProvidersState.status) {
                case Status.initial:
                case Status.loading:
                  return const Center(
                    child: CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),
                  );
                case Status.loaded:
                  var serviceProviders = [];
                  //log(servicesState.data!.data.toString());
                  for (var element in servicesProvidersState
                      .data!.data['service_providers']) {
                    // print(element.toString());
                    serviceProviders.add(element);
                  }
                  return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1,
                        crossAxisCount: 2,
                      ),
                      itemCount: serviceProviders.length,
                      itemBuilder: (BuildContext context, int index) =>
                          serviceProvider(
                              serviceProviders[index]["username"],
                              serviceProviders[index]["phone"],
                              serviceProviders[index]["avatar"],
                              serviceProviders[index]["id"],
                              ref));
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
                              "No service providers available at the moment",
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
          ],
        ),
      ),
    );
  }

  GestureDetector serviceProvider(String serviceProviderName,
      String phoneNumber, String image, int id, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(getServiceProviderDetailsIdProvider.notifier).state = id;
        Navigator.pushNamed(context, ServiceProvider.routeName,
            arguments: ['http://admin.esoptronsalon.com/$image', id]);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: getProportionateScreenWidth(100),
          height: getProportionateScreenHeight(120),
          decoration: BoxDecoration(
              border: Border.all(
                color: kPrimaryColor,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(15))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 35,
                  foregroundImage: NetworkImage(
                      "http://admin.esoptronsalon.com/storage/users/${image}"),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(5)),
              Text(
                serviceProviderName,
                style: GoogleFonts.nunitoSans(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(14),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(5)),
              Text(
                phoneNumber,
                style: GoogleFonts.nunitoSans(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(13),
                    fontWeight: FontWeight.w400,
                  ),
                ),
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

  GestureDetector servicesCard(String image, String name, String charge,
      String description, bool hasDiscount, int id) {
    // this boolean stores if you are coming from service page or not
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
          context, ServicesUnderSubCategory.routeName,
          arguments: [id, image, name, charge]),
      child: Container(
        width: getProportionateScreenWidth(160),
        height: getProportionateScreenHeight(300),
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
                    height: getProportionateScreenHeight(180),
                    //width: getProportionateScreenWidth(440),
                    fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                name,
                style: GoogleFonts.nunitoSans(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(12),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.9),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    "UGX $charge",
                    style: GoogleFonts.nunitoSans(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: getProportionateScreenWidth(12),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector ratingCard(
      String image,
      String text,
      String rating,
      String description,
      bool isAvailable,
      ratingsCount,
      Map<dynamic, dynamic> serviceProvider,
      int id) {
    // this boolean stores if you are coming from service page or not
    bool direct = true;
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, ServiceDetails.routeName, arguments: [
        text,
        image,
        description,
        serviceProvider,
        rating,
        isAvailable,
        ratingsCount,
        direct,
        serviceProvider['id'],
        id
      ]),
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
