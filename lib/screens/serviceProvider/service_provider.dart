import 'package:esoptron_salon/constants/size_config.dart';
import 'package:flutter/material.dart';

class ServiceProvider extends StatelessWidget {
  static String routeName = "service_provider";
  const ServiceProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Service Provider",
            style: TextStyle(fontSize: getProportionateScreenWidth(18)),
          ),
        ),
        body: Column(
          children: [],
        ));
  }
}
