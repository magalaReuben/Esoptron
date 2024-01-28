import 'dart:developer';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/controllers/getCategoriesUnderServiceType.dart';
import 'package:esoptron_salon/providers/contentProvisionProviders.dart';
import 'package:esoptron_salon/screens/categories/categories_page.dart';
import 'package:esoptron_salon/screens/subcategories/subcategories.dart';
import 'package:esoptron_salon/screens/servicesFromSubCategories/servicesFromSubCategories.dart';
import 'package:esoptron_salon/utils/enums/global_state.dart';
import 'package:esoptron_salon/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class Body extends ConsumerStatefulWidget {
  final int id;
  const Body({super.key, required this.id});

  @override
  ConsumerState<Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<Body> {
  bool isLoaded = false;
  @override
  Widget build(BuildContext context) {
    Future(() {
      ref.read(categoriesUnderServiceIdProvider.notifier).state = widget.id;
    });
    !isLoaded ? ref.invalidate(getCategoriesUnderServiceProvider) : null;
    final categoriesUnderService = ref.watch(getCategoriesUnderServiceProvider);
    setState(() {
      isLoaded = true;
    });
    return SingleChildScrollView(
      child: Column(children: [
        SizedBox(
          height: getProportionateScreenWidth(5),
        ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: TextFieldWidget(
        //     radiusBottomLeft: 30,
        //     radiusBottomRight: 30,
        //     radiusTopLeft: 30,
        //     radiusTopRight: 30,
        //     hintText: "Search for service",
        //     suffixWidget: Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //           decoration: const BoxDecoration(
        //               color: kPrimaryColor,
        //               borderRadius: BorderRadius.all(Radius.circular(60))),
        //           child: const Icon(
        //             FontAwesomeIcons.search,
        //             color: Colors.white,
        //           )),
        //     ),
        //   ),
        // ),
        Builder(builder: (context) {
          switch (categoriesUnderService.status) {
            case Status.initial:
            case Status.loading:
              return const Center(
                child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ),
              );
            case Status.loaded:
              log(categoriesUnderService.data!.data.toString());
              var serviceCategories = [];
              for (var element
                  in categoriesUnderService.data!.data['categories']) {
                serviceCategories.add(element);
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Results(${serviceCategories.length})",
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
                    for (int i = 0; i < serviceCategories.length; i++)
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Container(
                              height: getProportionateScreenHeight(150),
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
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      child: Image(
                                          height: 200,
                                          width: 100,
                                          image: NetworkImage(
                                              "http://admin.esoptronsalon.com/${serviceCategories[i]['image']}"),
                                          fit: BoxFit.cover),
                                    ),
                                    SizedBox(
                                      width: getProportionateScreenWidth(10),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          serviceCategories[i]['name'],
                                          style: GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize:
                                                getProportionateScreenWidth(18),
                                            fontWeight: FontWeight.w500,
                                          )),
                                        ),
                                        SizedBox(
                                          height:
                                              getProportionateScreenHeight(5),
                                        ),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                foregroundColor: kPrimaryColor,
                                                backgroundColor: kPrimaryColor),
                                            onPressed: () =>
                                                Navigator.pushNamed(context,
                                                    SubCategories.routeName,
                                                    arguments: [
                                                      serviceCategories[i]
                                                          ['id'],
                                                      "http://admin.esoptronsalon.com/${serviceCategories[i]['image']}",
                                                      serviceCategories[i]
                                                          ['name']
                                                    ]),
                                            child: Text(
                                              "View Services",
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
                          )
                          // Card(
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(8.0),
                          //     child: ListTile(
                          //       tileColor: Colors.white.withOpacity(0.8),
                          //       title: Text(
                          //         serviceCategories[i]['name'],
                          //         style: TextStyle(
                          //             fontWeight: FontWeight.w500,
                          //             fontSize:
                          //                 getProportionateScreenWidth(18)),
                          //       ),
                          //       leading: ClipRRect(
                          //         borderRadius: const BorderRadius.all(
                          //             Radius.circular(8)),
                          //         child: Image(
                          //             height: 200,
                          //             width: 100,
                          //             image: NetworkImage(
                          //                 "http://admin.esoptronsalon.com/${serviceCategories[i]['image']}"),
                          //             fit: BoxFit.fill),
                          //       ),

                          //       //  CircleAvatar(
                          //       //   backgroundImage: NetworkImage(
                          //       //       "http://admin.esoptronsalon.com/${serviceCategories[i]['image']}"),
                          //       //   radius: 45,
                          //       // ),
                          //     ),
                          //   ),
                          // ),
                          ),
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
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/services/unavailable.png",
                          height: getProportionateScreenHeight(280),
                          width: getProportionateScreenWidth(280),
                        ),
                        SizedBox(height: getProportionateScreenHeight(20)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              Text("Categories not available for this service",
                                  style: GoogleFonts.nunitoSans(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: getProportionateScreenWidth(17),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )),
                        )
                      ],
                    ),
                  ),
                ],
              );
          }
        }),
      ]),
    );
  }
}
