import 'dart:convert';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/screens/addPaymentmethod/add_payment.dart';
import 'package:esoptron_salon/screens/scheduleService/schedule_service.dart';
import 'package:esoptron_salon/widgets/default_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  int? bookingId;
  bool isCurrencyLoading = true;
  bool isLoading = false;

  Future<List<dynamic>> getTotalSubCategoryDetails(ids) async {
    List<dynamic> detailsHolder = [];
    for (var id in ids) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authorizationToken = prefs.getString("auth_token");
      final response = await http.get(
        Uri.parse(
            "http://admin.esoptronsalon.com/api/sub_category/$id/details"),
        headers: {
          'Authorization': 'Bearer $authorizationToken',
          'Content-Type':
              'application/json', // You may need to adjust the content type based on your API requirements
        },
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);
        detailsHolder.add({
          "unit": responseData['data']['charge_unit'],
          "charge": responseData['data']['charge'],
          "description": responseData['data']['description'],
          "image": responseData['data']['image']
        });
      } else {
        return [];
      }
    }
    if (detailsHolder.isNotEmpty) {
      return detailsHolder;
    } else {
      return [];
    }
  }

  Future<List<dynamic>> getServiceSubCategoryIds(
      serviceid, List<dynamic> subcategoryIdList) async {
    print(subcategoryIdList);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authorizationToken = prefs.getString("auth_token");
    List<int> service_sub_categories = [];
    final response = await http.get(
      Uri.parse(
          "http://admin.esoptronsalon.com/api/service/$serviceid/sub_categories"),
      headers: {
        'Authorization': 'Bearer $authorizationToken',
        'Content-Type':
            'application/json', // You may need to adjust the content type based on your API requirements
      },
    );
    print("Hey big man, this is our response now now: ${response.body}");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseData = json.decode(response.body);
      for (var element in responseData['data']['sub_categories']) {
        if (subcategoryIdList.contains(element['id'])) {
          service_sub_categories.add(element['service_sub_category_id']);
        }
        //print(service_sub_categories);
      }
      return service_sub_categories;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> arguments = ModalRoute.of(context)!.settings.arguments
        as List<dynamic>; //get arguments from previous screen
    //print("arguments: $arguments");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor.withOpacity(0.8),
        title: Text("Service Specification",
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: getProportionateScreenWidth(20),
              fontWeight: FontWeight.w400,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            SizedBox(
                child: CarouselSlider.builder(
                    itemCount: arguments[0].length,
                    itemBuilder: (context, index, realIndex) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            "${arguments[0][index]}",
                            fit: BoxFit.cover,
                            height: getProportionateScreenHeight(300),
                            width: getProportionateScreenWidth(390),
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      enableInfiniteScroll: false,
                      height: getProportionateScreenHeight(300),
                      enlargeCenterPage: true,
                      autoPlay: false,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      pauseAutoPlayOnTouch: true,
                      aspectRatio: 0.5,
                      onPageChanged: (index, reason) {
                        // setState(() {
                        //   //currentIndex = index;
                        // });
                      },
                    ))),
            const Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              child: Divider(
                color: Colors.black,
                thickness: 1,
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("Booking Time",
                      style: GoogleFonts.nunito(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(17),
                        fontWeight: FontWeight.bold,
                      ))
                ],
              ),
            ),
            Card(
              child: ListTile(
                title: Text("${arguments[3]}",
                    style: GoogleFonts.nunito(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(18),
                      fontWeight: FontWeight.w400,
                    )),
                subtitle: Text("${arguments[4]}",
                    style: GoogleFonts.nunito(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(15),
                      fontWeight: FontWeight.w400,
                    )),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, ScheduleService.routeName,
                        arguments: arguments);
                  },
                  icon: const Icon(
                    FontAwesomeIcons.calendarAlt,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("Service Details",
                      style: GoogleFonts.nunito(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(17),
                        fontWeight: FontWeight.bold,
                      ))
                ],
              ),
            ),
            FutureBuilder<List<dynamic>>(
              future: getTotalSubCategoryDetails(arguments[5]),
              builder: (context, snapshot) {
                //print(snapshot.data);
                if (snapshot.connectionState == ConnectionState.done) {
                  isCurrencyLoading
                      ? Future(() => setState(() {
                            charge = snapshot.data![0]['charge'].toString();
                            currency = snapshot.data![0]['unit'].toString();
                            isCurrencyLoading = false;
                          }))
                      : null;
                  return Column(
                    children: [
                      for (int i = 0; i < snapshot.data!.length; i++)
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Container(
                                height: getProportionateScreenHeight(120),
                                width: getProportionateScreenWidth(350),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white.withOpacity(0.6),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8)),
                                        child: Image(
                                            height:
                                                getProportionateScreenHeight(
                                                    120),
                                            width: getProportionateScreenWidth(
                                                100),
                                            image: NetworkImage(
                                                "http://admin.esoptronsalon.com/${snapshot.data![i]["image"]}"),
                                            fit: BoxFit.cover),
                                      ),
                                      SizedBox(
                                        width: getProportionateScreenWidth(10),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: getProportionateScreenWidth(
                                                200),
                                            child: Text(
                                              '${snapshot.data![i]['description']} \nUGX ${snapshot.data![i]['charge'].toString()}',
                                              style: GoogleFonts.nunitoSans(
                                                  textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        16),
                                                fontWeight: FontWeight.w500,
                                              )),
                                            ),
                                          ),
                                          SizedBox(
                                            height:
                                                getProportionateScreenHeight(5),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
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
                : DefaultButton(
                    // style: ButtonStyle(
                    //     side: MaterialStateBorderSide.resolveWith(
                    //         (states) =>
                    //             const BorderSide(color: kPrimaryColor)),
                    //     backgroundColor: MaterialStateColor.resolveWith(
                    //         (states) => kPrimaryColor)),
                    text: "Proceed to Pay",
                    press: () async {
                      // Navigator.pushNamed(context, AddPaymentMethod.routeName,
                      //     arguments: [
                      //       bookingId,
                      //       arguments[9],
                      //       currency,
                      //       charge,
                      //       arguments[3],
                      //       arguments[5]
                      //     ]);
                      // print(
                      //     "date: ${arguments[3]} time: ${arguments[4]} latitude:  ${arguments[6]} longitude: ${arguments[7]} address: ${arguments[8]} serviceSubCategory: ${arguments[5]} serviceId: ${arguments[2]} ");
                      setState(() {
                        isLoading = true;
                      });
                      List serviceSubCategoryIds =
                          await getServiceSubCategoryIds(
                              arguments[2], arguments[5]);
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String? authorizationToken =
                          prefs.getString("auth_token");
                      final data = jsonEncode({
                        'date': '${arguments[3]}',
                        'time': '${arguments[4]}',
                        'latitude': ' ${arguments[6]}',
                        'longitude': '${arguments[7]}',
                        'address': '${arguments[8]}',
                        'service_sub_categories': serviceSubCategoryIds,
                        'service_id': '${arguments[2]}'
                      });
                      print("Hey this is the data: $data");
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
                        final responseData = json.decode(response.body);
                        setState(() {
                          bookingId = responseData['data']['id'];
                        });
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Booking Request Made"),
                          backgroundColor: kPrimaryColor,
                          padding: EdgeInsets.all(25),
                        ));
                        // ignore: use_build_context_synchronously
                        Navigator.pushNamed(context, AddPaymentMethod.routeName,
                            arguments: [
                              bookingId,
                              arguments[9],
                              currency,
                              charge,
                              arguments[3],
                              arguments[5]
                            ]);
                        //print(responseData['data']);
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
                      print(
                          "date: ${arguments[3]} time: ${arguments[4]} latitude:  ${arguments[6]} longitude: ${arguments[7]} address: ${arguments[8]} serviceSubCategory: ${arguments[5]} serviceId: ${arguments[2]} ");
                    },
                    // child: const Padding(
                    //   padding: EdgeInsets.all(13.0),
                    //   child: Padding(
                    //     padding:
                    //         EdgeInsets.only(left: 14.0, right: 14.0),
                    //     child: Text(
                    //       "Proceed to Pay",
                    //       style: TextStyle(
                    //           color: Colors.white,
                    //           fontWeight: FontWeight.bold),
                    //     ),
                    //   ),
                    // )
                  )
          ]),
        ),
      ),
    );
  }
}
