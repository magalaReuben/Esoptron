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
    print("These are our arguments: $arguments");
    Future(() {
      ref.read(subCategoriesIdProvider.notifier).state = arguments[0];
    });
    final subCategories = ref.watch(subCategoriesProvider);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("${arguments[2]}"),
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
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          for (int i = 0; i < subCategoriesList.length; i++)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: getProportionateScreenHeight(150),
                                width: getProportionateScreenWidth(360),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(
                                      width: 2,
                                      color: kPrimaryColor,
                                    )),
                                child: Row(
                                  children: [
                                    Image(
                                        //image: NetImage(image),
                                        image: NetworkImage(
                                            "http://admin.esoptronsalon.com/${subCategoriesList[i]["image"]}"),
                                        fit: BoxFit.cover),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            "${subCategoriesList[i]["name"]} \n ${subCategoriesList[i]["charge"].toString()} ${subCategoriesList[i]['id']}",
                                            style: TextStyle(
                                                color: kPrimaryColor,
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        18),
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'krona'),
                                          ),
                                          FilledButton(
                                              onPressed: () =>
                                                  Navigator.pushNamed(context,
                                                      ServicesList.routeName,
                                                      arguments: [
                                                        subCategoriesList[i]
                                                            ['id'],
                                                        "http://admin.esoptronsalon.com/${subCategoriesList[i]["image"]}",
                                                        subCategoriesList[i]
                                                            ["name"]
                                                      ]),
                                              child: const Padding(
                                                padding: EdgeInsets.all(13.0),
                                                child: Text("Make Order"),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ],
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
                      ],
                    );
                }
              }),
            ],
          ),
        ));
  }
}
