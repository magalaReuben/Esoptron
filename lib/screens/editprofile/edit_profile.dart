import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/screens/editprofile/components/body.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfile extends StatelessWidget {
  static String routeName = "/editProfile";
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile details",
            style: GoogleFonts.nunitoSans(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: getProportionateScreenWidth(20),
                fontWeight: FontWeight.w400,
              ),
            )),
        // centerTitle: true,
        backgroundColor: kPrimaryColor.withOpacity(0.8),
      ),
      body: const Body(),
    );
  }
}
