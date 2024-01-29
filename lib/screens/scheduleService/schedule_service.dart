import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/providers/profileProviders.dart';
import 'package:esoptron_salon/screens/addPaymentmethod/add_payment.dart';
import 'package:esoptron_salon/widgets/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ScheduleService extends ConsumerStatefulWidget {
  static String routeName = "schedule_service";
  const ScheduleService({super.key});

  @override
  ConsumerState<ScheduleService> createState() => _ScheduleServiceState();
}

class _ScheduleServiceState extends ConsumerState<ScheduleService> {
  List<DateTime?> _dates = [DateTime.now()];
  bool time1 = false;
  bool time2 = false;
  bool time3 = false;
  bool time4 = false;
  bool time5 = false;
  bool time6 = false;
  bool time7 = false;
  bool time8 = false;
  bool hasSelectedTime = false;
  final EasyInfiniteDateTimelineController _controller =
      EasyInfiniteDateTimelineController();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: kPrimaryColor.withOpacity(0.8),
          title: Text("Schedule Service",
              style: GoogleFonts.nunitoSans(
                fontSize: getProportionateScreenWidth(18),
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ))),
      body: Column(
        children: [
          SizedBox(
            height: getProportionateScreenHeight(10),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Today's Schedule",
                  style: GoogleFonts.nunitoSans(
                    fontSize: getProportionateScreenWidth(18),
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          EasyDateTimeLine(
            headerProps: EasyHeaderProps(
              monthPickerType: MonthPickerType.switcher,
              dateFormatter: const DateFormatter.fullDateDMY(),
              selectedDateStyle: GoogleFonts.nunitoSans(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              monthStyle: GoogleFonts.nunitoSans(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            activeColor: kPrimaryColor.withOpacity(0.9),
            dayProps: const EasyDayProps(
              todayHighlightColor: kPrimaryColor,
            ),
            initialDate: DateTime.now(),
            onDateChange: (selectedDate) => _dates = [selectedDate],
          ),
          // CalendarTimeline(
          //   initialDate: DateTime.now(),
          //   firstDate: DateTime.now(),
          //   lastDate: DateTime(2040, 12, 31),
          //   onDateSelected: (date) => _dates = [date],
          //   leftMargin: 20,
          //   monthColor: Colors.blueGrey,
          //   dayColor: Colors.black.withOpacity(0.8),
          //   activeDayColor: Colors.white,
          //   activeBackgroundDayColor: kPrimaryColor,
          //   dotsColor: const Color(0xFF333A47),
          //   selectableDayPredicate: (date) => date.day != 23,
          //   locale: 'en_ISO',
          // ),
          SizedBox(
            height: getProportionateScreenHeight(40),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Choose Schedule Time",
                  style: GoogleFonts.nunitoSans(
                    fontSize: getProportionateScreenWidth(18),
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          // Card(
          //   child: ListTile(
          //     title: Text(
          //       "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')} ${selectedTime.period.toString().split(".")[1]}",
          //       style: TextStyle(
          //         fontWeight: FontWeight.bold,
          //         color: time1 ? Colors.white : Colors.black,
          //         fontSize: getProportionateScreenWidth(18),
          //       ),
          //     ),
          //     trailing: GestureDetector(
          //       onTap: () async {
          //         final TimeOfDay? pickedTime = await showTimePicker(
          //           context: context,
          //           initialTime: selectedTime,
          //         );

          //         if (pickedTime != null && pickedTime != selectedTime) {
          //           // Check if the picked time is within the allowed range (8 am to 6 pm)
          //           if (pickedTime.hour < 8 || pickedTime.hour >= 18) {
          //             // Show error message
          //             // ignore: use_build_context_synchronously
          //             showDialog(
          //               context: context,
          //               builder: (BuildContext context) {
          //                 return AlertDialog(
          //                   title: const Text("Invalid Time"),
          //                   content: const Text(
          //                       "Please select a time between\n8 am and 6 pm."),
          //                   actions: [
          //                     TextButton(
          //                       onPressed: () {
          //                         Navigator.of(context).pop();
          //                       },
          //                       child: const Text("OK"),
          //                     ),
          //                   ],
          //                 );
          //               },
          //             );
          //           } else {
          //             // Update the selected time if it's within the allowed range
          //             setState(() {
          //               hasSelectedTime = true;
          //               selectedTime = pickedTime;
          //             });
          //           }
          //         }
          //       },
          //       child: const Icon(
          //         Icons.keyboard_arrow_down,
          //         color: kPrimaryColor,
          //       ),
          //     ),
          //   ),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: Text("☕️ Morning",
                    style: GoogleFonts.nunitoSans(
                        fontSize: getProportionateScreenWidth(17),
                        color: Colors.black.withOpacity(0.9),
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      time1 = true;
                      time2 = false;
                      time3 = false;
                      time4 = false;
                      time5 = false;
                      time6 = false;
                      time7 = false;
                      time8 = false;
                    });
                  },
                  child: Container(
                    width: getProportionateScreenWidth(80),
                    height: getProportionateScreenHeight(50),
                    decoration: BoxDecoration(
                        color: time1 ? kPrimaryColor : Colors.white,
                        border: Border.all(
                          color: kPrimaryColor.withOpacity(0.3),
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Center(
                      child: Text(
                        "9:00",
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.bold,
                            color: time1 ? Colors.white : Colors.black,
                            fontSize: getProportionateScreenWidth(18)),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      time1 = false;
                      time2 = true;
                      time3 = false;
                      time4 = false;
                      time5 = false;
                      time6 = false;
                      time7 = false;
                      time8 = false;
                    });
                  },
                  child: Container(
                    width: getProportionateScreenWidth(80),
                    height: getProportionateScreenHeight(50),
                    decoration: BoxDecoration(
                        color: time2 ? kPrimaryColor : Colors.white,
                        border: Border.all(
                          color: kPrimaryColor.withOpacity(0.3),
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Center(
                      child: Text(
                        "10:00",
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.bold,
                            color: time2 ? Colors.white : Colors.black,
                            fontSize: getProportionateScreenWidth(18)),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      time1 = false;
                      time2 = false;
                      time3 = true;
                      time4 = false;
                      time5 = false;
                      time6 = false;
                      time7 = false;
                      time8 = false;
                    });
                  },
                  child: Container(
                    width: getProportionateScreenWidth(80),
                    height: getProportionateScreenHeight(50),
                    decoration: BoxDecoration(
                        color: time3 ? kPrimaryColor : Colors.white,
                        border: Border.all(
                          color: kPrimaryColor.withOpacity(0.3),
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Center(
                      child: Text(
                        "11:00",
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.bold,
                            color: time3 ? Colors.white : Colors.black,
                            fontSize: getProportionateScreenWidth(18)),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      time1 = false;
                      time2 = false;
                      time3 = false;
                      time4 = true;
                      time5 = false;
                      time6 = false;
                      time7 = false;
                      time8 = false;
                    });
                  },
                  child: Container(
                    width: getProportionateScreenWidth(80),
                    height: getProportionateScreenHeight(50),
                    decoration: BoxDecoration(
                        color: time4 ? kPrimaryColor : Colors.white,
                        border: Border.all(
                          color: kPrimaryColor.withOpacity(0.3),
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Center(
                      child: Text(
                        "12:00",
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.bold,
                            color: time4 ? Colors.white : Colors.black,
                            fontSize: getProportionateScreenWidth(18)),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: Text(
                  "🍹 Afternoon",
                  style: GoogleFonts.nunitoSans(
                      fontSize: getProportionateScreenWidth(17),
                      color: Colors.black.withOpacity(0.9),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      time1 = false;
                      time2 = false;
                      time3 = false;
                      time4 = false;
                      time5 = true;
                      time6 = false;
                      time7 = false;
                      time8 = false;
                    });
                  },
                  child: Container(
                    width: getProportionateScreenWidth(80),
                    height: getProportionateScreenHeight(50),
                    decoration: BoxDecoration(
                        color: time5 ? kPrimaryColor : Colors.white,
                        border: Border.all(
                          color: kPrimaryColor.withOpacity(0.3),
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Center(
                      child: Text(
                        "13:00",
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.bold,
                            color: time5 ? Colors.white : Colors.black,
                            fontSize: getProportionateScreenWidth(18)),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      time1 = false;
                      time2 = false;
                      time3 = false;
                      time4 = false;
                      time5 = false;
                      time6 = true;
                      time7 = false;
                      time8 = false;
                    });
                  },
                  child: Container(
                    width: getProportionateScreenWidth(80),
                    height: getProportionateScreenHeight(50),
                    decoration: BoxDecoration(
                        color: time6 ? kPrimaryColor : Colors.white,
                        border: Border.all(
                          color: kPrimaryColor.withOpacity(0.3),
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Center(
                      child: Text(
                        "14:00",
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.bold,
                            color: time6 ? Colors.white : Colors.black,
                            fontSize: getProportionateScreenWidth(18)),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      time1 = false;
                      time2 = false;
                      time3 = false;
                      time4 = false;
                      time5 = false;
                      time6 = false;
                      time7 = true;
                      time8 = false;
                    });
                  },
                  child: Container(
                    width: getProportionateScreenWidth(80),
                    height: getProportionateScreenHeight(50),
                    decoration: BoxDecoration(
                        color: time7 ? kPrimaryColor : Colors.white,
                        border: Border.all(
                          color: kPrimaryColor.withOpacity(0.3),
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Center(
                      child: Text(
                        "15:00",
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.bold,
                            color: time7 ? Colors.white : Colors.black,
                            fontSize: getProportionateScreenWidth(18)),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      time1 = false;
                      time2 = false;
                      time3 = false;
                      time4 = false;
                      time5 = false;
                      time6 = false;
                      time7 = false;
                      time8 = true;
                    });
                  },
                  child: Container(
                    width: getProportionateScreenWidth(80),
                    height: getProportionateScreenHeight(50),
                    decoration: BoxDecoration(
                        color: time8 ? kPrimaryColor : Colors.white,
                        border: Border.all(
                          color: kPrimaryColor.withOpacity(0.3),
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Center(
                      child: Text(
                        "16:00",
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.bold,
                            color: time8 ? Colors.white : Colors.black,
                            fontSize: getProportionateScreenWidth(18)),
                      ),
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
              text: "Confirm",
              press: () {
                DateTime current = DateTime.now();
                if ("${_dates[0]!.day}${_dates[0]!.month}${_dates[0]!.year}" ==
                        "${current.day}${current.month}${current.year}" ||
                    current.compareTo(_dates[0]!) < 0) {
                  if (time1 ||
                      time2 ||
                      time3 ||
                      time4 ||
                      time5 ||
                      time6 ||
                      time7 ||
                      time8) {
                    ref.read(scheduledTimeProvider.notifier).state =
                        DateFormat('hh:mm a').format(DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                            int.parse(
                                selectedTime.hour.toString().padLeft(2, '0')),
                            int.parse(selectedTime.minute
                                .toString()
                                .padLeft(2, '0'))));
                    ref.read(scheduledTimeProvider.notifier).state = time1
                        ? DateFormat('hh:mm a').format(DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                            10,
                            00))
                        : time2
                            ? DateFormat('hh:mm a').format(DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                                12,
                                00))
                            : time3
                                ? DateFormat('hh:mm a').format(DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day,
                                    15,
                                    30))
                                : time4
                                    ? DateFormat('hh:mm a').format(DateTime(
                                        DateTime.now().year,
                                        DateTime.now().month,
                                        DateTime.now().day,
                                        17,
                                        00))
                                    : time5
                                        ? DateFormat('hh:mm a').format(DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day,
                                            13,
                                            00))
                                        : time6
                                            ? DateFormat('hh:mm a').format(
                                                DateTime(
                                                    DateTime.now().year,
                                                    DateTime.now().month,
                                                    DateTime.now().day,
                                                    14,
                                                    00))
                                            : time7
                                                ? DateFormat('hh:mm a').format(
                                                    DateTime(
                                                        DateTime.now().year,
                                                        DateTime.now().month,
                                                        DateTime.now().day,
                                                        15,
                                                        00))
                                                : time8
                                                    ? DateFormat('hh:mm a')
                                                        .format(DateTime(
                                                            DateTime.now().year,
                                                            DateTime.now()
                                                                .month,
                                                            DateTime.now().day,
                                                            16,
                                                            00))
                                                    : "";
                    ref.read(scheduledDateProvider.notifier).state =
                        DateFormat("dd/MM/yyyy").format(DateTime(
                            _dates[0]!.year, _dates[0]!.month, _dates[0]!.day));
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: kPrimaryColor,
                        content: Text(
                          "Please select from predefined time",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )));
                  }
                } else if (current.compareTo(_dates[0]!) > 0) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: kPrimaryColor,
                      content: Text(
                        "We don't travel back into the past",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      )));
                } else {}
              },
            ),
          ),
          // const SizedBox(
          //   height: 35,
          // )
        ],
      ),
    );
  }
}
