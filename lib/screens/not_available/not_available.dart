import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotAvailable extends StatelessWidget {
  static String routeName = "/not_available";
  const NotAvailable({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor.withOpacity(0.8),
        title: Text("Coming Soon",
            style: GoogleFonts.nunitoSans(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: getProportionateScreenWidth(20),
                fontWeight: FontWeight.w400,
              ),
            )),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/images/comingsoon/soon.png',
              height: 200,
              width: 200,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(45)),
          Text("Coming Soon!",
              style: GoogleFonts.nunitoSans(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionateScreenWidth(20),
                  fontWeight: FontWeight.w500,
                ),
              ))
        ],
      ),
    );
  }
}
