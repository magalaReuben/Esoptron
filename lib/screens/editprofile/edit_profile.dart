import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/screens/editprofile/components/body.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatelessWidget {
  static String routeName = "/editProfile";
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Body(),
    );
  }
}
