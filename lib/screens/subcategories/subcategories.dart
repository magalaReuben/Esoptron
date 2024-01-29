import 'dart:developer';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/controllers/getSubCategory.dart';
import 'package:esoptron_salon/providers/contentProvisionProviders.dart';
import 'package:esoptron_salon/screens/servicesFromSubCategories/servicesFromSubCategories.dart';
import 'package:esoptron_salon/utils/enums/global_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SubCategories extends ConsumerStatefulWidget {
  static String routeName = '/subcategories';
  const SubCategories({super.key});

  @override
  ConsumerState<SubCategories> createState() => _SubCategoriesState();
}

class _SubCategoriesState extends ConsumerState<SubCategories> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    //print("These are our arguments: $arguments");
    Future(() {
      ref.read(subCategoriesIdProvider.notifier).state = arguments[0];
    });
    final subCategories = ref.watch(subCategoriesProvider);
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text("${arguments[2]}",
              style: GoogleFonts.nunitoSans(
                  textStyle: TextStyle(
                color: Colors.white,
                fontSize: getProportionateScreenWidth(20),
                fontWeight: FontWeight.w400,
              ))),
          backgroundColor: kPrimaryColor.withOpacity(0.8),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Builder(builder: (context) {
                switch (subCategories.status) {
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
                    var subCategoriesList = [];
                    for (var element
                        in subCategories.data!.data['sub_categories']) {
                      subCategoriesList.add(element);
                    }
                    print(subCategoriesList);
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Results(${subCategoriesList.length})",
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
                          for (int i = 0; i < subCategoriesList.length; i++)
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
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8)),
                                            child: Image(
                                                height: 200,
                                                width: 100,
                                                image: NetworkImage(
                                                    "http://admin.esoptronsalon.com/${subCategoriesList[i]["image"]}"),
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
                                                '${subCategoriesList[i]["name"]} \n UGX ${subCategoriesList[i]["charge"].toString()}',
                                                style: GoogleFonts.nunitoSans(
                                                    textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize:
                                                      getProportionateScreenWidth(
                                                          18),
                                                  fontWeight: FontWeight.w500,
                                                )),
                                              ),
                                              SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        5),
                                              ),
                                              ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          foregroundColor:
                                                              kPrimaryColor,
                                                          backgroundColor:
                                                              kPrimaryColor),
                                                  onPressed: () =>
                                                      Navigator.pushNamed(
                                                          context,
                                                          ServicesList
                                                              .routeName,
                                                          arguments: [
                                                            subCategoriesList[i]
                                                                ['id'],
                                                            "http://admin.esoptronsalon.com/${subCategoriesList[i]["image"]}",
                                                            subCategoriesList[i]
                                                                ["name"]
                                                          ]),
                                                  child: Text(
                                                    "View Providers",
                                                    style: GoogleFonts.nunitoSans(
                                                        textStyle: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                getProportionateScreenWidth(
                                                                    12),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                  ))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                          SizedBox(
                            width: getProportionateScreenWidth(15),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Container(
                          //     height: getProportionateScreenHeight(180),
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
                          //         SizedBox(
                          //           width: getProportionateScreenWidth(100),
                          //           child: Padding(
                          //             padding: const EdgeInsets.all(8.0),
                          //             child: ClipRRect(
                          //               borderRadius: const BorderRadius.all(
                          //                   Radius.circular(8)),
                          //               child: Image(
                          //                   //image: NetImage(image)
                          //                   height:
                          //                       getProportionateScreenHeight(
                          //                           180),
                          //                   image: NetworkImage(
                          //                       "http://admin.esoptronsalon.com/${subCategoriesList[i]["image"]}"),
                          //                   fit: BoxFit.cover),
                          //             ),
                          //           ),
                          //         ),
                          //         Padding(
                          //           padding: const EdgeInsets.all(8.0),
                          //           child: Column(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.spaceEvenly,
                          //             children: [
                          //               Text(
                          //                 "${subCategoriesList[i]["name"]} \n ${subCategoriesList[i]["charge"].toString()}",
                          //                 style: TextStyle(
                          //                     color: kPrimaryColor,
                          //                     fontSize:
                          //                         getProportionateScreenWidth(
                          //                             18),
                          //                     fontWeight: FontWeight.bold,
                          //                     fontFamily: 'krona'),
                          //               ),
                          //               FilledButton(
                          //                   onPressed: () =>
                          //                       Navigator.pushNamed(context,
                          //                           ServicesList.routeName,
                          //                           arguments: [
                          //                             subCategoriesList[i]
                          //                                 ['id'],
                          //                             "http://admin.esoptronsalon.com/${subCategoriesList[i]["image"]}",
                          //                             subCategoriesList[i]
                          //                                 ["name"]
                          //                           ]),
                          //                   child: const Padding(
                          //                     padding: EdgeInsets.all(13.0),
                          //                     child: Text("Make Order"),
                          //                   ))
                          //             ],
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //   width: getProportionateScreenWidth(15),
                          // )
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
                              SizedBox(
                                  height: getProportionateScreenHeight(20)),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    Text("${arguments[2]} has no subcategories",
                                        style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize:
                                                getProportionateScreenWidth(17),
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
            ],
          ),
        ));
  }
}
