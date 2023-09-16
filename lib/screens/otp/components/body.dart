import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/widgets/app_text.dart';
import 'package:flutter/material.dart';

import 'otp_form.dart';

class Body extends StatelessWidget {
  final phoneNumber;

  const Body({super.key, this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.asset(
            'assets/authentication/widgets/lock.png',
            height: getProportionateScreenHeight(220),
            width: getProportionateScreenWidth(200),
          ),
          AppText.medium(
            "Verification",
            color: Colors.white,
            fontSize: getProportionateScreenWidth(25),
          ),
          AppText.small(
            "Enter your mobile number or email address to get an OTP",
            color: Colors.white,
            fontSize: getProportionateScreenWidth(13),
          ),
          SizedBox(
            height: getProportionateScreenHeight(20),
          ),
          // buildTimer(),
          Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(40))),
            child: Padding(
              padding: const EdgeInsets.all(11.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const OtpForm(),
                  SizedBox(height: SizeConfig.screenHeight * 0.03),
                  GestureDetector(
                    onTap: () {
                      // OTP code resend
                    },
                    child: AppText.medium(
                      "Resend OTP Code",
                      color: kPrimaryColor,
                      fontSize: getProportionateScreenWidth(16),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("This code will expire in "),
        TweenAnimationBuilder(
          tween: Tween(begin: 60.0, end: 0.0),
          duration: Duration(seconds: 60),
          builder: (_, dynamic value, child) => Text(
            "00:${value.toInt()}",
            style: const TextStyle(color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
