import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';

class OtpScreen extends StatelessWidget {
  static String routeName = "/otp";
  @override
  Widget build(BuildContext context) {
    String phoneNumber = ModalRoute.of(context)!.settings.arguments.toString();
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: kPrimaryColor,
      ),
      body: Body(phoneNumber: phoneNumber),
    );
  }
}
