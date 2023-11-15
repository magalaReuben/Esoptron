import 'package:esoptron_salon/screens/categories/components/body.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  static String routeName = "categories";
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    return Scaffold(
      appBar: AppBar(title: Text(arguments[0]), centerTitle: true),
      body: Body(categories: arguments),
    );
  }
}
