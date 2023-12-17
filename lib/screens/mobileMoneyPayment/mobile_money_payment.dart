import 'dart:convert';
import 'package:esoptron_salon/helper/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/widgets/default_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MobileMoneyPaymentScreen extends StatefulWidget {
  static const routeName = '/mobile-money-payment';
  const MobileMoneyPaymentScreen({super.key});

  @override
  State<MobileMoneyPaymentScreen> createState() =>
      _MobileMoneyPaymentScreenState();
}

class _MobileMoneyPaymentScreenState extends State<MobileMoneyPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    List<dynamic> aruments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text('Mobile Money'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Image(
                  image: AssetImage('assets/images/mobilemoney/mm.png'),
                  fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.phone,
                    size: 15,
                    color: kPrimaryColor,
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(10),
                  ),
                  Text(
                    "Phone Number",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(18),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'krona'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                        hintText: "${aruments[1]}",
                        hintStyle: const TextStyle(color: Colors.black)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.monetization_on,
                    size: 15,
                    color: kPrimaryColor,
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(7),
                  ),
                  Text(
                    "Total: ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(18),
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    " ${aruments[3]} ${aruments[2]}",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(18),
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            isLoading
                ? const CircularProgressIndicator(
                    color: kPrimaryColor,
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DefaultButton(
                      text: "Checkout",
                      press: () async {
                        setState(() {
                          isLoading = true;
                        });
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String? authorizationToken =
                            prefs.getString("auth_token");
                        final data = jsonEncode({
                          "payment_type": "mobile money",
                          "booking_id": '${aruments[0]}',
                          "phone_number": "${aruments[1]}"
                        });
                        final response = await http.post(
                          Uri.parse(
                              "http://admin.esoptronsalon.com/api/bookings/pay"),
                          body: data,
                          headers: {
                            'Authorization': 'Bearer $authorizationToken',
                            'Content-Type': 'application/json',
                            'X-Requested-With': 'XMLHttpRequest'
                          },
                        );
                        final responseData = json.decode(response.body);
                        if (response.statusCode >= 200 &&
                            response.statusCode < 300) {
                          final responseData = json.decode(response.body);
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Booking Payment Initiated"),
                            backgroundColor: kPrimaryColor,
                            padding: EdgeInsets.all(25),
                          ));
                          launchURL(responseData['redirect-link']);
                          //print(responseData['redirect-link']);
                        } else {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("${responseData['message']}"),
                            backgroundColor: kPrimaryColor,
                            padding: const EdgeInsets.all(25),
                          ));
                        }
                        setState(() {
                          isLoading = false;
                        });
                      },
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
