import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/screens/login/login_screen.dart';
import 'package:esoptron_salon/screens/signup/signup_screen.dart';
import 'package:esoptron_salon/screens/termsAndConditions/termsAndConditionsScreen.dart';
import 'package:flutter/material.dart';

class TermsAndCondtionsLink extends StatelessWidget {
  final String text1;
  final String text2;
  const TermsAndCondtionsLink(
      {super.key, required this.text1, required this.text2});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text1,
          style: TextStyle(fontSize: getProportionateScreenWidth(12)),
        ),
        Divider(
          height: getProportionateScreenHeight(30),
          color: kPrimaryColor,
        ),
        GestureDetector(
          onTap: () =>
              Navigator.pushNamed(context, TermsAndConditions.routeName),
          child: Text(
            text2,
            style: TextStyle(
                fontSize: getProportionateScreenWidth(12),
                color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
