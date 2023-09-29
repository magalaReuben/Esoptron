import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/widgets/default_button.dart';
import 'package:flutter/material.dart';

class AddPaymentMethod extends StatefulWidget {
  static String routeName = "add_payment_method";
  const AddPaymentMethod({super.key});

  @override
  State<AddPaymentMethod> createState() => _AddPaymentMethodState();
}

class _AddPaymentMethodState extends State<AddPaymentMethod> {
  bool isChecked = false;
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Payment Method"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    onTap: () {},
                    leading: Checkbox(
                        value: isChecked,
                        fillColor: MaterialStateProperty.resolveWith(
                            (states) => kPrimaryColor),
                        shape: const CircleBorder(),
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        }),
                    title: Text(
                      "Pay with wallet",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(17),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'krona'),
                    ),
                    subtitle:
                        const Text("complete the payment using your e wallet"),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    onTap: () {},
                    leading: Checkbox(
                        value: isChecked1,
                        fillColor: MaterialStateProperty.resolveWith(
                            (states) => kPrimaryColor),
                        shape: const CircleBorder(),
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked1 = value!;
                          });
                        }),
                    title: Text(
                      "Credit / debit card",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(17),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'krona'),
                    ),
                    subtitle:
                        const Text("complete payment using your credit card"),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    onTap: () {},
                    leading: Checkbox(
                        value: isChecked2,
                        fillColor: MaterialStateProperty.resolveWith(
                            (states) => kPrimaryColor),
                        shape: const CircleBorder(),
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked2 = value!;
                          });
                        }),
                    title: Text(
                      "Pay with mobile money",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(17),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'krona'),
                    ),
                    subtitle: const Text(
                        "complete the payment using your mobile money"),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    onTap: () {},
                    leading: Checkbox(
                        value: isChecked3,
                        fillColor: MaterialStateProperty.resolveWith(
                            (states) => kPrimaryColor),
                        shape: const CircleBorder(),
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked3 = value!;
                          });
                        }),
                    title: Text(
                      "Pay on Cash",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(17),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'krona'),
                    ),
                    subtitle: const Text(
                        "complete the payment on cash after the service"),
                  ),
                ),
              ),
            ),
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DefaultButton(
                text: "Proceed to pay",
                press: () =>
                    Navigator.pushNamed(context, AddPaymentMethod.routeName),
              ),
            )
          ],
        ));
  }
}
