import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/screens/login/components/no_account_text.dart';
import 'package:esoptron_salon/screens/login/components/sign_form.dart';
import 'package:esoptron_salon/services/authentication.dart';
import 'package:esoptron_salon/widgets/social_card.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/authentication/widgets/Vector.png',
              height: getProportionateScreenHeight(80),
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  Image.asset(
                    'assets/icons/purplelogo 1.png',
                    height: getProportionateScreenHeight(140),
                    width: getProportionateScreenWidth(140),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.03),
                  Text(
                    "Sign in",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(22),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'krona'),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.05),
                  SignForm(),
                  SizedBox(height: SizeConfig.screenHeight * 0.05),
                  //Row(children: [],)
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     SocialCard(
                  //       icon: "assets/authentication/icons/google.png",
                  //       press: () async {
                  //         // User? result =
                  //         await AuthenticationService().googleSignIn(context);
                  //         // if (result != null) {
                  //         //   // ignore: use_build_context_synchronously
                  //         //   // Navigator.pushNamed(
                  //         //   //     context, LoginSuccessScreen.routeName);
                  //         // }
                  //       },
                  //     ),
                  //     SocialCard(
                  //       icon: "assets/authentication/icons/fb.png",
                  //       press: () {},
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  const NoAccountText(
                      text1: "Don’t have an account? ", text2: "Register now"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
