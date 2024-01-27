import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServicesUnderSubCategory extends ConsumerStatefulWidget {
  static String routeName = "/servicesUnderSubCategory";
  const ServicesUnderSubCategory({super.key});

  @override
  ConsumerState<ServicesUnderSubCategory> createState() =>
      _ServicesUnderSubCategoryState();
}

class _ServicesUnderSubCategoryState
    extends ConsumerState<ServicesUnderSubCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Services Under Sub Category"),
        ),
        body: const Padding(
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [],
            ),
          ),
        ));
  }
}
