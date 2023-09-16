import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/screens/landing/landing_screen.dart';
import 'package:esoptron_salon/screens/onboarding/onboarding.dart';
import 'package:esoptron_salon/screens/splash/components/body.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splash";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoggedInState();
  }

  void checkLoggedInState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Future.delayed(
        const Duration(seconds: 6),
        () => prefs.getBool("isLoggedin") == true
            ? Navigator.pushNamed(context, LandingScreen.routeName)
            : Navigator.pushNamed(context, OnBoarding.routeName));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return const Scaffold(
      body: Body(),
    );
  }
}
