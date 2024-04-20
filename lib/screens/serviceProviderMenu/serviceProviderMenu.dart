import 'dart:convert';
import 'dart:developer';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:background_location/background_location.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/providers/profileProviders.dart';
import 'package:esoptron_salon/screens/serviceBookedDetails/serviceBookedDetails.dart';
import 'package:esoptron_salon/services/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ServiceProviderMenu extends ConsumerStatefulWidget {
  const ServiceProviderMenu({super.key});

  @override
  ConsumerState<ServiceProviderMenu> createState() =>
      _ServiceProviderMenuState();
}

class _ServiceProviderMenuState extends ConsumerState<ServiceProviderMenu> {
  Future<List<dynamic>> getBookings() async {
    List<dynamic> bookedServiceIds = [];
    List<dynamic> bookingDetails = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authorizationToken = prefs.getString("auth_token");
    final response = await http.get(
      Uri.parse("http://admin.esoptronsalon.com/api/bookings/all"),
      headers: {
        'Authorization': 'Bearer $authorizationToken',
        'Content-Type':
            'application/json', // You may need to adjust the content type based on your API requirements
      },
    );
    final responseBody = json.decode(response.body);
    print(responseBody);
    if (responseBody['success'] == true) {
      for (var element in responseBody['data']['bookings']) {
        bookedServiceIds.add({
          "id": element['id'],
          "latitude": element['latitude'],
          "longitude": element['longitude']
        });
      }
      for (var element in bookedServiceIds) {
        final bookingDetailsResponse = await http.get(
          Uri.parse(
              "http://admin.esoptronsalon.com/api/bookings/${element['id']}/details"),
          headers: {
            'Authorization': 'Bearer $authorizationToken',
            'Content-Type':
                'application/json', // You may need to adjust the content type based on your API requirements
          },
        );
        if (bookingDetailsResponse.statusCode >= 200 &&
            bookingDetailsResponse.statusCode < 300) {
          final responseBody = json.decode(bookingDetailsResponse.body);
          bookingDetails.add({
            "id": responseBody['data']['id'],
            "latitude": element['latitude'],
            "longitude": element['longitude'],
            "status": responseBody['data']['status'],
            'service': responseBody['data']['service'],
            'sub_categories': responseBody['data']['sub_categories'],
            'customer': responseBody['data']['customer'],
            'address': responseBody['data']['address'],
            'time': responseBody['data']['time'],
          });
        } else {
          return [];
        }
      }
    }
    if (bookingDetails.isNotEmpty) {
      return bookingDetails;
    } else {
      return [];
    }
  }

  @override
  initState() {
    getBookings();
    super.initState();
  }

  Future<NetworkImage> getImage() async {
    final profileUrl = ref.watch(profilePicProvider);
    final response = await http
        .head(Uri.parse("http://admin.esoptronsalon.com/$profileUrl"));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return NetworkImage("http://admin.esoptronsalon.com/$profileUrl");
    } else {
      return const NetworkImage(
          "http://admin.esoptronsalon.com/storage/users/user.png");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(FontAwesomeIcons.bars, color: Colors.black),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          // leading: Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: FutureBuilder<NetworkImage>(
          //     future: getImage(),
          //     builder: (context, snapshot) {
          //       //print(snapshot);
          //       if (snapshot.connectionState == ConnectionState.done) {
          //         return CircleAvatar(
          //           radius: 15,
          //           backgroundImage: snapshot.data,
          //         );
          //       } else {
          //         // You can return a placeholder or loading indicator while the image is loading
          //         return const CircularProgressIndicator();
          //       }
          //     },
          //   ),
          // ),
          title: Text('Esoptron Salon',
              style: GoogleFonts.pacifico(
                textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(20)),
              )),
          // title: TextFieldWidget(
          //   controller: searchController,
          //   radiusBottomLeft: 30,
          //   radiusBottomRight: 30,
          //   radiusTopLeft: 30,
          //   radiusTopRight: 30,
          //   hintText: "Search for service category",
          //   suffixWidget: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Container(
          //         decoration: const BoxDecoration(
          //             color: kPrimaryColor,
          //             borderRadius: BorderRadius.all(Radius.circular(60))),
          //         child: GestureDetector(
          //           onTap: () async {
          //             if (searchController.text.isEmpty) {
          //               ScaffoldMessenger.of(context)
          //                   .showSnackBar(const SnackBar(
          //                 content: Text("Please enter a search query"),
          //                 backgroundColor: kPrimaryColor,
          //                 padding: EdgeInsets.all(25),
          //               ));
          //               return;
          //             }
          //             setState(() {
          //               isSearching = true;
          //             });
          //             final result = await search(searchController.text);
          //             setState(() {
          //               isSearching = false;
          //             });
          //             if (result.isEmpty) {
          //               // ignore: use_build_context_synchronously
          //               ScaffoldMessenger.of(context)
          //                   .showSnackBar(const SnackBar(
          //                 content: Text("No results found"),
          //                 backgroundColor: kPrimaryColor,
          //                 padding: EdgeInsets.all(25),
          //               ));
          //               return;
          //             } else {
          //               //print(result);
          //               // ignore: use_build_context_synchronously
          //               Navigator.pushNamed(
          //                   context, SearchedSubCategories.routeName,
          //                   arguments: result);
          //             }
          //           },
          //           child: isSearching
          //               ? SizedBox(
          //                   height: getProportionateScreenHeight(8),
          //                   width: getProportionateScreenWidth(8),
          //                   child: const Padding(
          //                     padding: EdgeInsets.all(8.0),
          //                     child: CircularProgressIndicator(
          //                       color: Colors.white,
          //                     ),
          //                   ),
          //                 )
          //               : const Icon(
          //                   FontAwesomeIcons.search,
          //                   color: Colors.white,
          //                 ),
          //         )),
          //   ),
          // ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<NetworkImage>(
                future: getImage(),
                builder: (context, snapshot) {
                  //print(snapshot);
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CircleAvatar(
                      radius: 25,
                      backgroundImage: snapshot.data,
                    );
                  } else {
                    // You can return a placeholder or loading indicator while the image is loading
                    return const CircularProgressIndicator();
                  }
                },
              ),
            )
            // SizedBox(
            //   width: getProportionateScreenWidth(5),
            // ),
            // GestureDetector(
            //   onTap: () =>
            //       Navigator.pushNamed(context, ServicesBooked.routeName),
            //   child: const Icon(
            //     FontAwesomeIcons.bell,
            //     color: kPrimaryColor,
            //   ),
            // ),
            // SizedBox(
            //   width: getProportionateScreenWidth(5),
            // ),
            // GestureDetector(
            //   onTap: () {
            //     showDialog(
            //         context: context,
            //         builder: (_) => SizedBox(
            //             height: getProportionateScreenHeight(300),
            //             child: PriceMenu()));
            //   },
            //   child: const Icon(
            //     FontAwesomeIcons.clipboardList,
            //     color: kPrimaryColor,
            //   ),
            // )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder<List<dynamic>>(
                  future: getBookings(),
                  builder: (context, snapshot) {
                    //print(snapshot.data);
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              //log(snapshot.data![index].toString());
                              return GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                    context, ServiceBookedDetails.routeName,
                                    arguments: snapshot.data![index]),
                                child: Card(
                                  elevation: 1,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            'http://admin.esoptronsalon.com/${snapshot.data![index]['customer']['avatar']}')),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(snapshot.data![index]['customer']
                                            ['name']),
                                        Chip(
                                            label: Text(
                                              snapshot.data![index]['status'],
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            backgroundColor: kPrimaryColor),
                                      ],
                                    ),
                                    subtitle: Text(snapshot.data![index]
                                            ['address']
                                        .toString()),
                                  ),
                                ),
                              );
                            });
                      } else {
                        return Column(
                          children: [
                            SizedBox(
                              height: getProportionateScreenHeight(30),
                            ),
                            SizedBox(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image(
                                          width:
                                              getProportionateScreenWidth(100),
                                          height:
                                              getProportionateScreenHeight(100),
                                          image: const AssetImage(
                                              "assets/images/home/nodata.png"),
                                          fit: BoxFit.cover),
                                      const Text(
                                        "No bookings made yet",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      }
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: getProportionateScreenHeight(30),
                        ),
                        const Center(child: CircularProgressIndicator()),
                      ],
                    );
                  },
                ),
                // Card(
                //   elevation: 1,
                //   child: ListTile(
                //     leading: const CircleAvatar(
                //         backgroundImage: NetworkImage(
                //             'http://admin.esoptronsalon.com/storage/users/user.png')),
                //     title: const Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Text("Miss Seven"),
                //         Padding(
                //           padding: EdgeInsets.only(left: 8.0, right: 8.0),
                //           child: Chip(
                //               label: Text(
                //                 "10:00 AM",
                //                 style: TextStyle(color: Colors.white),
                //               ),
                //               backgroundColor: kPrimaryColor),
                //         ),
                //       ],
                //     ),
                //     subtitle: Column(
                //       children: [
                //         const Row(
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           children: [
                //             Text("ButterFly Braids"),
                //           ],
                //         ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     ElevatedButton(
                //         style: ElevatedButton.styleFrom(
                //             backgroundColor: Colors.green),
                //         onPressed: () => null,
                //         child: const Text("Accept")),
                //     SizedBox(
                //       width: getProportionateScreenWidth(15),
                //     ),
                //     ElevatedButton(
                //         style: ElevatedButton.styleFrom(
                //             backgroundColor: Colors.red),
                //         onPressed: () => null,
                //         child: const Text("Reject"))
                //   ],
                // ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ));
  }
}
