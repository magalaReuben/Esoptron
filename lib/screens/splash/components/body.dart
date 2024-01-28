import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: kPrimaryColor),
      child: Center(
        child: TweenAnimationBuilder<double>(
          duration: const Duration(seconds: 4),
          tween: Tween(begin: 10, end: 56),
          curve: Curves.bounceOut,
          builder: (context, size, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/icons/mainlogo 1.png',
                  height: getProportionateScreenHeight(200),
                  width: getProportionateScreenWidth(200),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                Text('Esoptron Salon',
                    style: GoogleFonts.pacifico(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: getProportionateScreenWidth(20)),
                    )),
              ],
            );
          },
        ),
      ),
    );
  }
}
