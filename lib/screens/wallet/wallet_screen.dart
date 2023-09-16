import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/screens/wallet/components/body.dart';
import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: getProportionateScreenHeight(10),
          automaticallyImplyLeading: false,
        ),
        body: const Body());
  }
}
