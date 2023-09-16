import 'package:esoptron_salon/screens/onboarding/components/body.dart';
import 'package:flutter/material.dart';

class OnBoarding extends StatelessWidget {
  static String routeName = '/onboarding';
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Body());
  }
}
