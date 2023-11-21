import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/controllers/getSubCategory.dart';
import 'package:esoptron_salon/providers/contentProvisionProviders.dart';
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
    Future(() {
      ref.read(subCategoriesIdProvider.notifier).state = arguments[1];
    });
    final subCategories = ref.watch(subCategoriesProvider);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(arguments[0]),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Builder(builder: (context) {
                switch (subCategories.status) {
                  case Status.initial:
                  case Status.loading:
                    return const Center(
                      child: CircularProgressIndicator(
                        color: kPrimaryColor,
                      ),
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
                                    Image.asset(
                                        "assets/images/favorites/image1.png"),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            "Classic Manicure",
                                            style: TextStyle(
                                                color: kPrimaryColor,
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        18),
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'krona'),
                                          ),
                                          Text(
                                            "Manicure & Pedicure",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        15),
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'krona'),
                                          ),
                                          FilledButton(
                                              onPressed: () {},
                                              child: const Padding(
                                                padding: EdgeInsets.all(13.0),
                                                child: Text("Service Details"),
                                              ))
                                        ],
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.favorite,
                                              color: kPrimaryColor)
                                        ],
                                      ),
                                    )
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
