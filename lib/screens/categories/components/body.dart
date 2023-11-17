import 'dart:developer';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/controllers/getCategoriesUnderServiceType.dart';
import 'package:esoptron_salon/providers/contentProvisionProviders.dart';
import 'package:esoptron_salon/screens/categories/categories_page.dart';
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
              var serviceTypes = [];
              for (var element
                  in categoriesUnderService.data!.data['categories']) {
                serviceTypes.add(element);
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    for (int i = 0; i < serviceTypes.length; i++)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(serviceTypes[i]['name']),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                "http://admin.esoptronsalon.com/${serviceTypes[i]['image']}"),
                            radius: 25,
                          ),
                        ),
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
                          child: Text(
                            "Categories not available for this service",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: getProportionateScreenWidth(18)),
                          ),
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
