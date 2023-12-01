import 'package:awesome_icons/awesome_icons.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/providers/profileProviders.dart';
import 'package:esoptron_salon/screens/scheduleService/schedule_service.dart';
import 'package:esoptron_salon/screens/serviceSpecification/service_specification.dart';
import 'package:esoptron_salon/services/location.dart';
import 'package:esoptron_salon/widgets/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class ServiceBooking extends ConsumerStatefulWidget {
  static String routeName = '/service_booking';
  const ServiceBooking({super.key});

  @override
  ConsumerState<ServiceBooking> createState() => _ServiceBookingState();
}

class _ServiceBookingState extends ConsumerState<ServiceBooking> {
  String? _currentAddress;
  Position? _currentPosition;
  bool _isInstantSelected = false;
  bool _isScheduleSelected = false;
  TextEditingController phoneNumberController = TextEditingController();

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> getCurrentPosition() async {
    final hasPermission =
        await LocationService.handleLocationPermission(context);
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    final scheduledDate = ref.watch(scheduledDateProvider);
    final scheduledTime = ref.watch(scheduledTimeProvider);
    print("These are our arguments: ${arguments}");
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
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                          hintText: _currentAddress ?? "Getting Address...",
                          hintStyle: const TextStyle(color: Colors.black)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextFormField(
                      controller: phoneNumberController,
                      decoration: const InputDecoration(
                          hintText: "Enter Phone Number",
                          hintStyle: TextStyle(color: Colors.black)),
                    ),
                  ),
                ),
              ),
              // const Padding(
              //   padding: EdgeInsets.only(top: 4.0),
              //   child: Card(
              //     elevation: 2,
              //     child: Padding(
              //       padding: EdgeInsets.only(left: 8.0),
              //       child: TextField(
              //         decoration: InputDecoration(
              //             hintText: "Others",
              //             hintStyle: TextStyle(color: Colors.black)),
              //       ),
              //     ),
              //   ),
              // ),
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
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                          hintText: arguments[0],
                          hintStyle: const TextStyle(color: Colors.black)),
                    ),
                  ),
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
                          hintText: arguments[2],
                          hintStyle: const TextStyle(color: Colors.black)),
                    ),
                  ),
                ),
              ),
              // const Padding(
              //   padding: EdgeInsets.only(top: 4.0),
              //   child: Card(
              //     elevation: 2,
              //     child: Padding(
              //       padding: EdgeInsets.only(left: 8.0),
              //       child: TextField(
              //         decoration: InputDecoration(
              //             hintText: "Expected Time",
              //             hintStyle: TextStyle(color: Colors.black)),
              //       ),
              //     ),
              //   ),
              // ),
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
                  _isInstantSelected
                      ? GestureDetector(
                          onTap: () => setState(() {
                            _isInstantSelected = false;
                            _isScheduleSelected = true;
                          }),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color: kPrimaryColor,
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        FontAwesomeIcons.solidClock,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            getProportionateScreenHeight(5)),
                                    Text(
                                      "Instant Service",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              getProportionateScreenWidth(17),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'krona'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              _isInstantSelected = true;
                              _isScheduleSelected = false;
                            });
                            ref.read(scheduledTimeProvider.notifier).state =
                                DateFormat('hh:mm a').format(DateTime.now());
                            ref.read(scheduledDateProvider.notifier).state =
                                DateFormat("dd/MM/yyyy").format(DateTime.now());
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 3,
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
                                    SizedBox(
                                        height:
                                            getProportionateScreenHeight(5)),
                                    Text(
                                      "Instant Service",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize:
                                              getProportionateScreenWidth(17),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'krona'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                  _isScheduleSelected
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              _isInstantSelected = false;
                              _isScheduleSelected = true;
                            });
                            Navigator.pushNamed(
                                context, ScheduleService.routeName,
                                arguments: arguments);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color: kPrimaryColor,
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        FontAwesomeIcons.calendar,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            getProportionateScreenHeight(5)),
                                    Text(
                                      "Schedule Service",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              getProportionateScreenWidth(17),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'krona'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              _isInstantSelected = false;
                              _isScheduleSelected = true;
                            });
                            Navigator.pushNamed(
                                context, ScheduleService.routeName,
                                arguments: arguments);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 3,
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
                                    SizedBox(
                                        height:
                                            getProportionateScreenHeight(5)),
                                    Text(
                                      "Schedule Service",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize:
                                              getProportionateScreenWidth(17),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'krona'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              DefaultButton(
                  text: "Continue",
                  press: () {
                    // ignore: dead_code
                    if (false) {
                    } else {
                      if (scheduledDate == '' || scheduledTime == '') {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                backgroundColor: kPrimaryColor,
                                content: Text(
                                  'Select Booking Time',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                )));
                      } else {
                        Navigator.pushNamed(
                            context, ServiceSpecification.routeName,
                            arguments: [
                              arguments[1],
                              arguments[2],
                              arguments[3],
                              scheduledDate,
                              scheduledTime,
                              arguments[4],
                              _currentPosition!.latitude,
                              _currentPosition!.longitude,
                              _currentAddress
                            ]);
                      }
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
