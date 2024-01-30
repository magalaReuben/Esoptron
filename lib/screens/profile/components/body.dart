import 'package:awesome_icons/awesome_icons.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/providers/profileProviders.dart';
import 'package:esoptron_salon/screens/editprofile/edit_profile.dart';
import 'package:esoptron_salon/screens/login/login_screen.dart';
import 'package:esoptron_salon/screens/statementsAndReports/statements_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Body extends ConsumerStatefulWidget {
  const Body({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BodyState createState() => _BodyState();
}

class _BodyState extends ConsumerState<Body> {
  bool forAndroid = false;

  Future getUserNames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? firstName = prefs.getString("firstName");
    String? lastName = prefs.getString("lastName");
    String? phoneNumber = prefs.getString("phone");
    String? email = prefs.getString("userEmail");
    String userName = "$firstName $lastName";
    ref.read(userNameProvider.notifier).state = userName;
    ref.read(phoneNumberProvider.notifier).state = phoneNumber;
    ref.read(emailProvider.notifier).state = email;
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
  void initState() {
    super.initState();
    getUserNames();
  }

  @override
  Widget build(BuildContext context) {
    final userName = ref.watch(userNameProvider);
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: getProportionateScreenHeight(350),
                  width: getProportionateScreenWidth(450),
                  child: FutureBuilder<NetworkImage>(
                    future: getImage(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Image(
                            image: NetworkImage(snapshot.data.toString()),
                            //height: getProportionateScreenHeight(300),
                            width: getProportionateScreenWidth(450),
                            fit: BoxFit.cover);
                      } else {
                        // You can return a placeholder or loading indicator while the image is loading
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
                onTap: () =>
                    Navigator.pushNamed(context, EditProfile.routeName),
                leading: FutureBuilder<NetworkImage>(
                  future: getImage(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return CircleAvatar(
                        radius: 35,
                        backgroundImage: snapshot.data,
                      );
                    } else {
                      // You can return a placeholder or loading indicator while the image is loading
                      return const CircularProgressIndicator();
                    }
                  },
                ),
                title: Text(
                  userName ?? "",
                  style: GoogleFonts.nunitoSans(
                    fontSize: getProportionateScreenWidth(18),
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text("View Profile"),
                trailing: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(userName ?? "",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: getProportionateScreenWidth(17),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'krona')),
                          content: Text("Are you sure you want to logout?",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: getProportionateScreenWidth(15),
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'krona')),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setBool("isLoggedin", false);
                                prefs.setString("firstName", "");
                                prefs.setString("lastName", "");
                                prefs.setString("userEmail", "");
                                // ignore: use_build_context_synchronously
                                Navigator.pushNamed(
                                    context, LoginScreen.routeName);
                              },
                              child: const Text("OK"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Icon(
                    Icons.logout,
                    color: kPrimaryColor,
                    size: 25,
                    weight: 10,
                  ),
                )),
            // child: Row(
            //   children: [
            //     FutureBuilder<NetworkImage>(
            //       future: getImage(),
            //       builder: (context, snapshot) {
            //         if (snapshot.connectionState == ConnectionState.done) {
            //           return CircleAvatar(
            //             radius: 20,
            //             backgroundImage: snapshot.data,
            //           );
            //         } else {
            //           // You can return a placeholder or loading indicator while the image is loading
            //           return const CircularProgressIndicator();
            //         }
            //       },
            //     ),
            //     SizedBox(
            //       width: getProportionateScreenWidth(15),
            //     ),
            //     Column(
            //       children: [
            //         Padding(
            //           padding: const EdgeInsets.all(3.0),
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Text(userName ?? "",
            //                   style: TextStyle(
            //                       color: Colors.black,
            //                       fontSize: getProportionateScreenWidth(18),
            //                       fontWeight: FontWeight.bold,
            //                       fontFamily: 'krona')),
            //               SizedBox(
            //                   width: userName == null
            //                       ? getProportionateScreenWidth(130)
            //                       : getProportionateScreenWidth(
            //                           1550 / userName!.length.toDouble())),
            //               GestureDetector(
            //                 onTap: () {
            //                   showDialog(
            //                       context: context,
            //                       builder: (_) => SizedBox(
            //                           height:
            //                               MediaQuery.of(context).size.height *
            //                                   0.6,
            //                           width:
            //                               MediaQuery.of(context).size.height *
            //                                   0.5,
            //                           child: Padding(
            //                             padding: const EdgeInsets.only(
            //                                 top: 150, bottom: 120),
            //                             child: Container(
            //                               margin: EdgeInsets.all(
            //                                   getProportionateScreenWidth(20)),
            //                               width:
            //                                   MediaQuery.of(context).size.width,
            //                               height: MediaQuery.of(context)
            //                                       .size
            //                                       .height *
            //                                   0.7,
            //                               clipBehavior: Clip.hardEdge,
            //                               decoration: BoxDecoration(
            //                                   color: Colors.white,
            //                                   borderRadius:
            //                                       BorderRadius.circular(20),
            //                                   border: Border.all(
            //                                       color: kPrimaryColor,
            //                                       width: 5)),
            //                               child: Center(
            //                                   child: Column(
            //                                 children: [
            //                                   Padding(
            //                                     padding:
            //                                         const EdgeInsets.all(8.0),
            //                                     child: Row(
            //                                       mainAxisAlignment:
            //                                           MainAxisAlignment.end,
            //                                       children: [
            //                                         GestureDetector(
            //                                             onTap: () {
            //                                               Navigator.pop(
            //                                                   context);
            //                                             },
            //                                             child: const Icon(
            //                                                 Icons.cancel))
            //                                       ],
            //                                     ),
            //                                   ),
            //                                   Padding(
            //                                     padding:
            //                                         const EdgeInsets.all(8.0),
            //                                     child: Text(userName ?? "",
            //                                         style: TextStyle(
            //                                             color: Colors.black,
            //                                             fontSize:
            //                                                 getProportionateScreenWidth(
            //                                                     25),
            //                                             fontWeight:
            //                                                 FontWeight.bold,
            //                                             fontFamily: 'krona')),
            //                                   ),
            //                                   Padding(
            //                                     padding:
            //                                         const EdgeInsets.all(8.0),
            //                                     child: Text(
            //                                         "Are you sure you want to logout?",
            //                                         style: TextStyle(
            //                                             color: Colors.black,
            //                                             fontSize:
            //                                                 getProportionateScreenWidth(
            //                                                     15),
            //                                             fontWeight:
            //                                                 FontWeight.normal,
            //                                             fontFamily: 'krona')),
            //                                   ),
            //                                   Padding(
            //                                     padding:
            //                                         const EdgeInsets.all(8.0),
            //                                     child: Row(
            //                                         mainAxisAlignment:
            //                                             MainAxisAlignment
            //                                                 .spaceAround,
            //                                         children: [
            //                                           ElevatedButton(
            //                                               child: const Text(
            //                                                   "Logout"),
            //                                               onPressed: () async {
            //                                                 SharedPreferences
            //                                                     prefs =
            //                                                     await SharedPreferences
            //                                                         .getInstance();
            //                                                 prefs.setBool(
            //                                                     "isLoggedin",
            //                                                     false);
            //                                                 prefs.setString(
            //                                                     "firstName",
            //                                                     "");
            //                                                 prefs.setString(
            //                                                     "lastName", "");
            //                                                 prefs.setString(
            //                                                     "userEmail",
            //                                                     "");
            //                                                 // ignore: use_build_context_synchronously
            //                                                 Navigator.pushNamed(
            //                                                     context,
            //                                                     LoginScreen
            //                                                         .routeName);
            //                                               }),
            //                                           ElevatedButton(
            //                                               child: const Text(
            //                                                   "Cancel"),
            //                                               onPressed: () {
            //                                                 Navigator.pop(
            //                                                     context);
            //                                               })
            //                                         ]),
            //                                   )
            //                                 ],
            //                               )),
            //                             ),
            //                           )));
            //                 },
            //                 child: const Icon(Icons.logout,
            //                     size: 25, color: kPrimaryColor),
            //               ),
            //             ],
            //           ),
            //         ),
            //         Padding(
            //           padding: const EdgeInsets.all(3.0),
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.end,
            //             children: [
            //               SizedBox(
            //                 width: getProportionateScreenWidth(200),
            //               ),
            //               Text("Log Out",
            //                   style: TextStyle(
            //                       color: Colors.black,
            //                       fontSize: getProportionateScreenWidth(17),
            //                       fontWeight: FontWeight.bold,
            //                       fontFamily: 'krona'))
            //             ],
            //           ),
            //         ),
            //         SizedBox(
            //           height: getProportionateScreenHeight(10),
            //         ),
            //       ],
            //     )
            //   ],
            // ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Text("Enable dark Mode",
          //             style: TextStyle(
          //                 color: Colors.black,
          //                 fontSize: getProportionateScreenWidth(15),
          //                 fontWeight: FontWeight.bold,
          //                 fontFamily: 'krona')),
          //         Switch(
          //           // thumb color (round icon)
          //           activeColor: Colors.white,
          //           activeTrackColor: kPrimaryColor,
          //           inactiveThumbColor: kPrimaryColor,
          //           inactiveTrackColor: Colors.grey.shade400,
          //           splashRadius: 50.0,
          //           // boolean variable value
          //           value: forAndroid,
          //           // changes the state of the switch
          //           onChanged: (value) => setState(() => forAndroid = value),
          //         )
          //       ]),
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                onTap: () =>
                    Navigator.pushNamed(context, EditProfile.routeName),
                leading: const Icon(Icons.account_circle, color: kPrimaryColor),
                title: Text(
                  "Edit Profile",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(17),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'krona'),
                ),
                subtitle: const Text("Name, Phone Number, Adress"),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Card(
          //     child: ListTile(
          //       onTap: () {
          //         showDialog(
          //             context: context,
          //             builder: (_) => SizedBox(
          //                 height: getProportionateScreenHeight(300),
          //                 child: const StatementPopup()));
          //       },
          //       leading: const Icon(Icons.edit_document, color: kPrimaryColor),
          //       title: Text(
          //         "Statements & Reports",
          //         style: TextStyle(
          //             color: Colors.black,
          //             fontSize: getProportionateScreenWidth(17),
          //             fontWeight: FontWeight.w500,
          //             fontFamily: 'krona'),
          //       ),
          //       subtitle: const Text("Download transaction details, Services"),
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Card(
          //     child: ListTile(
          //       onTap: () =>
          //           Navigator.pushNamed(context, EditProfile.routeName),
          //       leading: const Icon(Icons.edit_document, color: kPrimaryColor),
          //       title: Text(
          //         "Notification Settings",
          //         style: TextStyle(
          //             color: Colors.black,
          //             fontSize: getProportionateScreenWidth(17),
          //             fontWeight: FontWeight.w500,
          //             fontFamily: 'krona'),
          //       ),
          //       subtitle: const Text("mute, unmute, set location & tracking.."),
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.money, color: kPrimaryColor),
                title: Text(
                  "Referrals",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(17),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'krona'),
                ),
                subtitle: const Text("check no of friends and earn"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.star, color: kPrimaryColor),
                title: Text(
                  "Loyalty Points",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(17),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'krona'),
                ),
                subtitle: const Text("Check your points as a loyal customer"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.map, color: kPrimaryColor),
                title: Text(
                  "About Us",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(17),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'krona'),
                ),
                subtitle:
                    const Text("know more about us, terms and conditions"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
