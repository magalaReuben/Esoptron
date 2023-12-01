import 'dart:convert';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/screens/addPaymentmethod/add_payment.dart';
import 'package:esoptron_salon/screens/scheduleService/schedule_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ServiceSpecification extends StatefulWidget {
  static String routeName = "service_specification";
  const ServiceSpecification({super.key});

  @override
  State<ServiceSpecification> createState() => _ServiceSpecificationState();
}

class _ServiceSpecificationState extends State<ServiceSpecification> {
  String? charge;
  String? currency;
  String? description;
  bool isLoading = false;

  Future<List<dynamic>> getSubCategoryDetails(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authorizationToken = prefs.getString("auth_token");
    final response = await http.get(
      Uri.parse("http://admin.esoptronsalon.com/api/sub_category/$id/details"),
      headers: {
        'Authorization': 'Bearer $authorizationToken',
        'Content-Type':
            'application/json', // You may need to adjust the content type based on your API requirements
      },
    );
    print(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseData = json.decode(response.body);
      print(responseData['data']);
      return [
        responseData['data']['charge_unit'],
        responseData['data']['charge'],
        responseData['data']['description']
      ];
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> arguments = ModalRoute.of(context)!.settings.arguments
        as List<dynamic>; //get arguments from previous screen
    return Scaffold(
      appBar: AppBar(
        title: const Text("Service Specification"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            SizedBox(
              child: Image(
                  image: NetworkImage("${arguments[0]}"),
                  height: getProportionateScreenHeight(350),
                  fit: BoxFit.cover),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6.0, top: 14, bottom: 6),
                  child: Text(
                    "${arguments[1]}",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(15),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'krona'),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    FontAwesomeIcons.clock,
                    color: kPrimaryColor,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 6.0, top: 6.0, bottom: 6.0),
                  child: Text(
                    "${arguments[3]} ${arguments[4]}",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(15),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'krona'),
                  ),
                ),
              ],
            ),
            FutureBuilder<List<dynamic>>(
              future: getSubCategoryDetails(arguments[5]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 6.0, top: 6.0, bottom: 6.0),
                            child: Text(
                              "${snapshot.data![0]} ${snapshot.data![1]}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: getProportionateScreenWidth(15),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'krona'),
                            ),
                          ),
                          Image.asset(
                            "assets/images/serviceBooking/cut.png",
                            height: getProportionateScreenHeight(35),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Divider(
                          color: Colors.black.withOpacity(0.9),
                          thickness: 1.5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 6.0, top: 14, bottom: 6),
                        child: Text(
                          "${snapshot.data![2]} ",
                          softWrap: true,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(15),
                              fontWeight: FontWeight.normal,
                              fontFamily: 'krona'),
                        ),
                      ),
                    ],
                  );
                } else {
                  return isLoading
                      ? Container()
                      : const CircularProgressIndicator(
                          color: kPrimaryColor,
                        );
                }
              },
            ),
            isLoading
                ? const CircularProgressIndicator(
                    color: kPrimaryColor,
                  )
                : Padding(
                    padding:
                        const EdgeInsets.only(left: 6.0, top: 14, bottom: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FilledButton(
                            style: ButtonStyle(
                                side: MaterialStateBorderSide.resolveWith(
                                    (states) =>
                                        const BorderSide(color: kPrimaryColor)),
                                // textStyle: MaterialStateProperty.resolveWith(
                                //     (states) => const TextStyle(color: Colors.black)),
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => kPrimaryColor)),
                            onPressed: () async {
                              print(
                                  "date: ${arguments[3]} time: ${arguments[4]} latitude:  ${arguments[6]} longitude: ${arguments[7]} address: ${arguments[8]} serviceSubCategory: ${arguments[5]} serviceId: ${arguments[2]} ");
                              setState(() {
                                isLoading = true;
                              });
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String? authorizationToken =
                                  prefs.getString("auth_token");
                              //print("this is the time ${arguments[4]}");
                              final data = jsonEncode({
                                'date': '${arguments[3]}',
                                'time': '${arguments[4]}',
                                'latitude': ' ${arguments[6]}',
                                'longitude': '${arguments[7]}',
                                'address': '${arguments[8]}',
                                'service_sub_categories': ['${arguments[5]}'],
                                'service_id': '${arguments[2]}'
                              });
                              final response = await http.post(
                                Uri.parse(
                                    "http://admin.esoptronsalon.com/api/bookings/new_request"),
                                body: data,
                                headers: {
                                  'Authorization': 'Bearer $authorizationToken',
                                  'Content-Type': 'application/json',
                                  'X-Requested-With': 'XMLHttpRequest'
                                },
                              );
                              print(response.body);
                              final responseData = json.decode(response.body);
                              if (response.statusCode >= 200 &&
                                  response.statusCode < 300) {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Booking Request Made"),
                                  backgroundColor: kPrimaryColor,
                                  padding: EdgeInsets.all(25),
                                ));
                                // ignore: use_build_context_synchronously
                                Navigator.pushNamed(
                                    context, AddPaymentMethod.routeName);
                                //print(responseData['data']);
                              } else {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("${responseData['message']}"),
                                  backgroundColor: kPrimaryColor,
                                  padding: const EdgeInsets.all(25),
                                ));
                              }
                              setState(() {
                                isLoading = false;
                              });
                              print(
                                  "date: ${arguments[3]} time: ${arguments[4]} latitude:  ${arguments[6]} longitude: ${arguments[7]} address: ${arguments[8]} serviceSubCategory: ${arguments[5]} serviceId: ${arguments[2]} ");
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(13.0),
                              child: Padding(
                                padding:
                                    EdgeInsets.only(left: 14.0, right: 14.0),
                                child: Text(
                                  "Proceed to Pay",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ))
                      ],
                    ),
                  )
          ]),
        ),
      ),
    );
  }
}
