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
                    var subCategories = [];
                    print(subCategories);
                    return Container();
                  // for (var element
                  //     in subCategories.data!.data['categories']) {
                  //   subCategories.add(element);
                  // }
                  // return SingleChildScrollView(
                  //   child: Column(
                  //     children: [
                  // for (int i = 0; i < serviceTypes.length; i++)
                  //   Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: ListTile(
                  //       title: Text(serviceTypes[i]['name']),
                  //       leading: CircleAvatar(
                  //         backgroundImage: NetworkImage(
                  //             "http://admin.esoptronsalon.com/${serviceTypes[i]['image']}"),
                  //         radius: 25,
                  //       ),
                  //     ),
                  //   ),
                  // SizedBox(
                  //   width: getProportionateScreenWidth(15),
                  // )
                  //     ],
                  //   ),
                  // );
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
