import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/screens/categories/components/body.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoriesScreen extends StatelessWidget {
  static String routeName = "categories";
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: Text(arguments[0],
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
      body: Body(id: arguments[1]),
    );
  }
}
