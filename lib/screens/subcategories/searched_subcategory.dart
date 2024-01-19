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

class SearchedSubCategories extends ConsumerStatefulWidget {
  static String routeName = '/searched_subcategories';
  const SearchedSubCategories({super.key});

  @override
  ConsumerState<SearchedSubCategories> createState() => _SubCategoriesState();
}

class _SubCategoriesState extends ConsumerState<SearchedSubCategories> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Search Results"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Builder(builder: (context) {
                print(arguments);
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      for (int i = 0; i < arguments.length; i++)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: getProportionateScreenHeight(180),
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
                                SizedBox(
                                  width: getProportionateScreenWidth(100),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    child: Image(
                                        //image: NetImage(image),
                                        image: NetworkImage(
                                            "http://admin.esoptronsalon.com/${arguments[i]["image"]}"),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "${arguments[i]["name"]} \n ${arguments[i]["charge"].toString()}",
                                        style: TextStyle(
                                            color: kPrimaryColor,
                                            fontSize:
                                                getProportionateScreenWidth(18),
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'krona'),
                                      ),
                                      FilledButton(
                                          onPressed: () => Navigator.pushNamed(
                                                  context,
                                                  ServicesList.routeName,
                                                  arguments: [
                                                    arguments[i]['id'],
                                                    "http://admin.esoptronsalon.com/${arguments[i]["image"]}",
                                                    arguments[i]["name"]
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
              }),
            ],
          ),
        ));
  }
}
