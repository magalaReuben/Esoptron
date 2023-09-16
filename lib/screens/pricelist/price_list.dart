import 'package:esoptron_salon/screens/pricelist/components/body.dart';
import 'package:flutter/material.dart';

class PriceList extends StatelessWidget {
  static String routeName = "/pricelist";
  const PriceList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Price Menu"),
        ),
        body: Body());
  }
}
