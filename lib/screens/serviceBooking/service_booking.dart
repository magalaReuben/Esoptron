import 'package:awesome_icons/awesome_icons.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/screens/serviceSpecification/service_specification.dart';
import 'package:esoptron_salon/widgets/default_button.dart';
import 'package:flutter/material.dart';

class ServiceBooking extends StatelessWidget {
  static String routeName = '/service_booking';
  const ServiceBooking({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Service Booking",
          style: TextStyle(fontSize: getProportionateScreenWidth(18)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_pin,
                      size: 15,
                      color: kPrimaryColor,
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(10),
                    ),
                    Text(
                      "Destination Details",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(18),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'krona'),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Ply",
                          hintStyle: TextStyle(color: Colors.black)),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Phone Number",
                          hintStyle: TextStyle(color: Colors.black)),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Others",
                          hintStyle: TextStyle(color: Colors.black)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.add_box,
                      size: 15,
                      color: kPrimaryColor,
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(5),
                    ),
                    Text(
                      "Add Destination",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(14),
                          fontWeight: FontWeight.normal,
                          fontFamily: 'krona'),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 6.0, top: 14, bottom: 6),
                    child: Text(
                      "Service Details",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(18),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'krona'),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Name of the service provider",
                          hintStyle: TextStyle(color: Colors.black)),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Service booked",
                          hintStyle: TextStyle(color: Colors.black)),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Expected Time",
                          hintStyle: TextStyle(color: Colors.black)),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 6.0, top: 14, bottom: 6),
                    child: Text(
                      "Select Booking Time",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(18),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'krona'),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      // shape: Border.fromBorderSide(BorderSide()),
                      elevation: 3,
                      // width: getProportionateScreenWidth(130),
                      // height: getProportionateScreenHeight(150),
                      // decoration: BoxDecoration(
                      //     border: Border.all(
                      //       color: kPrimaryColor,
                      //     ),
                      //     borderRadius:
                      //         const BorderRadius.all(Radius.circular(15))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                FontAwesomeIcons.solidClock,
                                color: kPrimaryColor,
                              ),
                            ),
                            SizedBox(height: getProportionateScreenHeight(5)),
                            Text(
                              "Instant Service",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: getProportionateScreenWidth(17),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'krona'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      // shape: Border.fromBorderSide(BorderSide()),
                      elevation: 3,
                      // width: getProportionateScreenWidth(130),
                      // height: getProportionateScreenHeight(150),
                      // decoration: BoxDecoration(
                      //     border: Border.all(
                      //       color: kPrimaryColor,
                      //     ),
                      //     borderRadius:
                      //         const BorderRadius.all(Radius.circular(15))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                FontAwesomeIcons.calendar,
                                color: kPrimaryColor,
                              ),
                            ),
                            SizedBox(height: getProportionateScreenHeight(5)),
                            Text(
                              "Schedule Service",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: getProportionateScreenWidth(17),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'krona'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              DefaultButton(
                  text: "Continue",
                  press: () => Navigator.pushNamed(
                      context, ServiceSpecification.routeName))
            ],
          ),
        ),
      ),
    );
  }
}
