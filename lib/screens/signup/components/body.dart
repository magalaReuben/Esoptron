import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/screens/signup/components/signup_form.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.asset(
            'assets/authentication/widgets/Vector.png',
            height: getProportionateScreenHeight(80),
            width: double.infinity,
          ),
          SizedBox(
            height: getProportionateScreenHeight(25),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Create an Account",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(18),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'krona'),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: SignUpForm(),
          )
        ],
      ),
    );
  }
}
