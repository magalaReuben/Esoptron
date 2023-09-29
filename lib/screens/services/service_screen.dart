import 'package:awesome_icons/awesome_icons.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/screens/favorites/favorite_screen.dart';
import 'package:esoptron_salon/screens/services/components/body.dart';
import 'package:esoptron_salon/widgets/text_field.dart';
import 'package:flutter/material.dart';

class ServiceScreen extends StatelessWidget {
  const ServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: TextFieldWidget(
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
        actions: [
          // const Icon(
          //   FontAwesomeIcons.solidBookmark,
          //   color: kPrimaryColor,
          // ),
          SizedBox(
            width: getProportionateScreenWidth(5),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, FavoriteScreen.routeName),
            child: const Icon(
              FontAwesomeIcons.solidHeart,
              color: kPrimaryColor,
            ),
          ),
          // const Icon(
          //   FontAwesomeIcons.solidHeart,
          //   color: kPrimaryColor,
          // ),
          SizedBox(
            width: getProportionateScreenWidth(15),
          ),
        ],
      ),
      body: const Body(),
    );
  }
}
