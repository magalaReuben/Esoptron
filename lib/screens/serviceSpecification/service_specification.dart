import 'package:awesome_icons/awesome_icons.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/screens/scheduleService/schedule_service.dart';
import 'package:flutter/material.dart';

class ServiceSpecification extends StatelessWidget {
  static String routeName = "service_specification";
  const ServiceSpecification({super.key});

  @override
  Widget build(BuildContext context) {
    List<dynamic> arguments = ModalRoute.of(context)!.settings.arguments
        as List<dynamic>; //get arguments from previous screen
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          SizedBox(
            height: getProportionateScreenHeight(50),
          ),
          SizedBox(
            child: Image(
                image: NetworkImage("${arguments[0]}"),
                height: getProportionateScreenHeight(400),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 6.0, top: 6.0, bottom: 6.0),
                child: Text(
                  "\$20",
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
            padding: const EdgeInsets.only(left: 6.0, top: 14, bottom: 6),
            child: Text(
              "Medium hair repair is for dreads that are 40 cm long with bleach or even without.",
              softWrap: true,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionateScreenWidth(15),
                  fontWeight: FontWeight.normal,
                  fontFamily: 'krona'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6.0, top: 14, bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // FilledButton(
                //     style: ButtonStyle(
                //         side: MaterialStateBorderSide.resolveWith(
                //             (states) => const BorderSide(color: kPrimaryColor)),
                //         textStyle: MaterialStateProperty.resolveWith(
                //             (states) => const TextStyle(color: Colors.black)),
                //         backgroundColor: MaterialStateColor.resolveWith(
                //             (states) => Colors.white)),
                //     onPressed: () {},
                //     child: const Padding(
                //       padding: EdgeInsets.all(13.0),
                //       child: Text(
                //         "Service Details",
                //         style: TextStyle(
                //             color: Colors.black, fontWeight: FontWeight.bold),
                //       ),
                //     )),
                FilledButton(
                    style: ButtonStyle(
                        side: MaterialStateBorderSide.resolveWith(
                            (states) => const BorderSide(color: kPrimaryColor)),
                        // textStyle: MaterialStateProperty.resolveWith(
                        //     (states) => const TextStyle(color: Colors.black)),
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => kPrimaryColor)),
                    onPressed: () =>
                        Navigator.pushNamed(context, ScheduleService.routeName),
                    child: const Padding(
                      padding: EdgeInsets.all(13.0),
                      child: Padding(
                        padding: EdgeInsets.only(left: 14.0, right: 14.0),
                        child: Text(
                          "Proceed to Pay",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ))
              ],
            ),
          )
        ]),
      ),
    );
  }
}
