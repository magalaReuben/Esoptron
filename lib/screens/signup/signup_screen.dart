import 'package:esoptron_salon/screens/signup/components/body.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  static String routeName = '/signup';
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Body());
  }
}
