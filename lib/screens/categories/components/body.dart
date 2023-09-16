import 'dart:developer';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/widgets/text_field.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  final List categories;
  const Body({super.key, required this.categories});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    log(widget.categories.toString());
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
        widget.categories.isNotEmpty
            ? Container()
            : Column(
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
              ),
        for (int i = 0; i < widget.categories.length; i++)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(widget.categories[i]['name']),
              subtitle: Text("Available: ${widget.categories[i]['is_active']}"),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    "http://admin.esoptronsalon.com/${widget.categories[i]['image']}"),
                radius: 25,
              ),
            ),
          )
      ]),
    );
  }
}
