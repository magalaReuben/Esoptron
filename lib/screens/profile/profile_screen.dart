import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/screens/profile/components/body.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: getProportionateScreenHeight(10),
        automaticallyImplyLeading: false,
      ),
      body: const Body(),
    );
  }
}
