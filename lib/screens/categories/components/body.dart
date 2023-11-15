import 'dart:developer';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/controllers/getCategoriesUnderServiceType.dart';
import 'package:esoptron_salon/utils/enums/global_state.dart';
import 'package:esoptron_salon/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Body extends ConsumerStatefulWidget {
  final int id;
  const Body({super.key, required this.id});

  @override
  ConsumerState<Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<Body> {
  @override
  Widget build(BuildContext context) {
    log(widget.id.toString());
    return SingleChildScrollView(
      child: Column(children: [
        SizedBox(
          height: getProportionateScreenWidth(25),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFieldWidget(
            radiusBottomLeft: 30,
            radiusBottomRight: 30,
            radiusTopLeft: 30,
            radiusTopRight: 30,
            hintText: "Search for service",
            suffixWidget: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  decoration: const BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(60))),
                  child: const Icon(
                    FontAwesomeIcons.search,
                    color: Colors.white,
                  )),
            ),
          ),
        ),
        Builder(builder: (context) {
          // ref.invalidate(documentsProvider);
          final categoriesUnderService =
              ref.watch(GetCategoriesUnderServiceProvider);
          switch (categoriesUnderService.status) {
            case Status.initial:
            case Status.loading:
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),
                  ],
                ),
              );
            case Status.loaded:
              var serviceTypes = [];

              ///log(categoriesUnderService.data!.data.toString());
              // for (var element
              //     in categoriesUnderService.data!.data['categories']) {
              //   serviceTypes.add(element);
              // }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // for (int i = 1; i < serviceTypes.length; i++)
                    //   GestureDetector(
                    //     onTap: () {
                    //       Navigator.pushNamed(
                    //           context, CategoriesScreen.routeName, arguments: [
                    //         serviceTypes[i]['name'],
                    //         serviceTypes[i]['id']
                    //       ]);
                    //     },
                    //     child: Column(
                    //       children: [
                    //         Padding(
                    //           padding: const EdgeInsets.all(8.0),
                    //           child: ClipRRect(
                    //             borderRadius:
                    //                 const BorderRadius.all(Radius.circular(8)),
                    //             child: Image(
                    //                 height: 120,
                    //                 width: 120,
                    //                 image: NetworkImage(
                    //                     "http://admin.esoptronsalon.com/${serviceTypes[i]['image']}"),
                    //                 fit: BoxFit.cover),
                    //           ),
                    //         ),
                    //         Text(
                    //           serviceTypes[i]['name'],
                    //           style: TextStyle(
                    //               color: Colors.black,
                    //               fontSize: getProportionateScreenWidth(15),
                    //               fontWeight: FontWeight.w500,
                    //               fontFamily: 'krona'),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // SizedBox(
                    //   width: getProportionateScreenWidth(15),
                    // )
                  ],
                ),
              );
            case Status.error:
              return const SizedBox();
          }
        }),
        // widget.categories.isNotEmpty
        //     ? Container()
        //     : Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           SizedBox(height: getProportionateScreenHeight(50)),
        //           Center(
        //             child: Column(
        //               children: [
        //                 Image.asset(
        //                   "assets/images/services/unavailable.png",
        //                   height: getProportionateScreenHeight(280),
        //                   width: getProportionateScreenWidth(280),
        //                 ),
        //                 SizedBox(height: getProportionateScreenHeight(20)),
        //                 Padding(
        //                   padding: const EdgeInsets.all(8.0),
        //                   child: Text(
        //                     "Categories not available for this service",
        //                     style: TextStyle(
        //                         color: Colors.black,
        //                         fontWeight: FontWeight.bold,
        //                         fontSize: getProportionateScreenWidth(18)),
        //                   ),
        //                 )
        //               ],
        //             ),
        //           ),
        //         ],
        //       ),
        // for (int i = 0; i < widget.categories.length; i++)
        //   Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: ListTile(
        //       title: Text(widget.categories[i]['name']),
        //       subtitle: Text("Available: ${widget.categories[i]['is_active']}"),
        //       leading: CircleAvatar(
        //         backgroundImage: NetworkImage(
        //             "http://admin.esoptronsalon.com/${widget.categories[i]['image']}"),
        //         radius: 25,
        //       ),
        //     ),
        //   )
      ]),
    );
  }
}
