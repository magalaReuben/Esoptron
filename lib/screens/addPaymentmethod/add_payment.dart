import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/screens/mobileMoneyPayment/mobile_money_payment.dart';
import 'package:esoptron_salon/widgets/default_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    List<dynamic> aruments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    print("These are our arguments: $aruments");
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Payment Method",
              style: GoogleFonts.nunitoSans(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: getProportionateScreenWidth(20),
                  fontWeight: FontWeight.w400,
                ),
              )),
          // centerTitle: true,
          backgroundColor: kPrimaryColor.withOpacity(0.8),
        ),
        body: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Card(
            //     child: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: ListTile(
            //         onTap: () {
            //           setState(() {
            //             isChecked = !isChecked;
            //             isChecked1 = false;
            //             isChecked2 = false;
            //             isChecked3 = false;
            //           });
            //         },
            //         leading: Checkbox(
            //             value: isChecked,
            //             fillColor: MaterialStateProperty.resolveWith(
            //                 (states) => kPrimaryColor),
            //             shape: const CircleBorder(),
            //             onChanged: (bool? value) {
            //               setState(() {
            //                 isChecked = value!;
            //               });
            //             }),
            //         title: Text(
            //           "Pay with wallet",
            //           style: TextStyle(
            //               color: Colors.black,
            //               fontSize: getProportionateScreenWidth(17),
            //               fontWeight: FontWeight.w500,
            //               fontFamily: 'krona'),
            //         ),
            //         subtitle:
            //             const Text("complete the payment using your e wallet"),
            //       ),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Card(
            //     child: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: ListTile(
            //         onTap: () {
            //           setState(() {
            //             isChecked1 = !isChecked1;
            //             isChecked = false;
            //             isChecked2 = false;
            //             isChecked3 = false;
            //           });
            //         },
            //         leading: Checkbox(
            //             value: isChecked1,
            //             fillColor: MaterialStateProperty.resolveWith(
            //                 (states) => kPrimaryColor),
            //             shape: const CircleBorder(),
            //             onChanged: (bool? value) {
            //               setState(() {
            //                 isChecked1 = value!;
            //               });
            //             }),
            //         title: Text(
            //           "Credit / debit card",
            //           style: TextStyle(
            //               color: Colors.black,
            //               fontSize: getProportionateScreenWidth(17),
            //               fontWeight: FontWeight.w500,
            //               fontFamily: 'krona'),
            //         ),
            //         subtitle:
            //             const Text("complete payment using your credit card"),
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    onTap: () {
                      setState(() {
                        isChecked2 = !isChecked2;
                        isChecked1 = false;
                        isChecked = false;
                        isChecked3 = false;
                      });
                    },
                    leading: Checkbox(
                        value: isChecked2,
                        fillColor: MaterialStateProperty.resolveWith(
                            (states) => kPrimaryColor.withOpacity(0.7)),
                        shape: const CircleBorder(),
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked2 = value!;
                          });
                        }),
                    title: Text(
                      "Pay with mobile money",
                      style: GoogleFonts.nunitoSans(
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(17),
                            fontWeight: FontWeight.w500,
                            fontFamily: 'krona'),
                      ),
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
                    onTap: () {
                      setState(() {
                        isChecked3 = !isChecked3;
                        isChecked1 = false;
                        isChecked2 = false;
                        isChecked = false;
                      });
                    },
                    leading: Checkbox(
                        value: isChecked3,
                        fillColor: MaterialStateProperty.resolveWith(
                            (states) => kPrimaryColor.withOpacity(0.7)),
                        shape: const CircleBorder(),
                        onChanged: (bool? value) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: kPrimaryColor,
                              content: Text(
                                'This payment method is not available',
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: getProportionateScreenWidth(14),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'krona'),
                                ),
                              )));
                          // setState(() {
                          //   isChecked3 = value!;
                          // });
                        }),
                    title: Text(
                      "Pay on Cash",
                      style: GoogleFonts.nunitoSans(
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(17),
                            fontWeight: FontWeight.w500,
                            fontFamily: 'krona'),
                      ),
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
                press: () {
                  if (isChecked2 == true) {
                    Navigator.pushNamed(
                        context, MobileMoneyPaymentScreen.routeName,
                        arguments: aruments);
                  }
                },
              ),
            )
          ],
        ));
  }
}
