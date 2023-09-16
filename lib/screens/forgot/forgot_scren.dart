import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/screens/forgot/components/body.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static String routeName = "/forgot_password";

  const ForgotPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: kPrimaryColor),
      ),
      body: const Body(),
    );
  }
}
