import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/screens/addPaymentmethod/add_payment.dart';
import 'package:esoptron_salon/widgets/default_button.dart';
import 'package:flutter/material.dart';

class ScheduleService extends StatefulWidget {
  static String routeName = "schedule_service";
  const ScheduleService({super.key});

  @override
  State<ScheduleService> createState() => _ScheduleServiceState();
}

class _ScheduleServiceState extends State<ScheduleService> {
  List<DateTime?> _dates = [
    DateTime(2021, 8, 10),
    //DateTime(2021, 8, 13),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Schedule Service"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: getProportionateScreenHeight(10),
          ),
          Center(
            child: Container(
              width: getProportionateScreenWidth(350),
              height: getProportionateScreenHeight(350),
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.fromRGBO(244, 227, 227, 1),
                        Color.fromRGBO(241, 239, 243, 1),
                        Color.fromRGBO(223, 239, 244, 1)
                      ]),
                  border: Border.all(
                    color: kPrimaryColor.withOpacity(0.3),
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              child: CalendarDatePicker2(
                config: CalendarDatePicker2Config(),
                value: _dates,
                onValueChanged: (dates) => _dates = dates,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Available Time",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(18),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'krona'),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: getProportionateScreenWidth(80),
                  height: getProportionateScreenHeight(50),
                  decoration: BoxDecoration(
                      color: kPrimaryColor,
                      border: Border.all(
                        color: kPrimaryColor.withOpacity(0.3),
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  child: Center(
                    child: Text(
                      "10:00",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: getProportionateScreenWidth(18)),
                    ),
                  ),
                ),
                Container(
                  width: getProportionateScreenWidth(80),
                  height: getProportionateScreenHeight(50),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: kPrimaryColor.withOpacity(0.3),
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  child: Center(
                    child: Text(
                      "12:00",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(18)),
                    ),
                  ),
                ),
                Container(
                  width: getProportionateScreenWidth(80),
                  height: getProportionateScreenHeight(50),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: kPrimaryColor.withOpacity(0.3),
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  child: Center(
                    child: Text(
                      "15:30",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(18)),
                    ),
                  ),
                ),
                Container(
                  width: getProportionateScreenWidth(80),
                  height: getProportionateScreenHeight(50),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: kPrimaryColor.withOpacity(0.3),
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  child: Center(
                    child: Text(
                      "17:00",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(18)),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DefaultButton(
              text: "Confirm and Pay",
              press: () =>
                  Navigator.pushNamed(context, AddPaymentMethod.routeName),
            ),
          )
        ],
      ),
    );
  }
}
