import 'package:awesome_icons/awesome_icons.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/providers/profileProviders.dart';
import 'package:esoptron_salon/screens/favorites/favorite_screen.dart';
import 'package:esoptron_salon/screens/pricemenu/pricemenu.dart';
import 'package:esoptron_salon/screens/servicesbooked/services_booked.dart';
import 'package:esoptron_salon/screens/track/components/body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TrackScreen extends ConsumerStatefulWidget {
  const TrackScreen({super.key});

  @override
  ConsumerState<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends ConsumerState<TrackScreen> {
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
      body: const Body(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: kPrimaryColor,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/icons/mainlogo 1.png',
                          height: getProportionateScreenHeight(60),
                          width: getProportionateScreenWidth(60),
                        ),
                      ),
                      Text(
                        'Esoptron Salon',
                        style: GoogleFonts.pacifico(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: getProportionateScreenWidth(17)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(
                'Notifications',
                style: GoogleFonts.nunitoSans(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              leading: const Icon(
                Icons.notifications_active,
                color: kPrimaryColor,
              ),
              onTap: () =>
                  Navigator.pushNamed(context, ServicesBooked.routeName),
            ),
            ListTile(
              title: Text(
                'Favorites',
                style: GoogleFonts.nunitoSans(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              leading: const Icon(
                Icons.favorite,
                color: kPrimaryColor,
              ),
              onTap: () {
                Navigator.pushNamed(context, FavoriteScreen.routeName);
              },
            ),
            ListTile(
              title: Text(
                'Price Menu',
                style: GoogleFonts.nunitoSans(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              leading: const Icon(
                FontAwesomeIcons.clipboardList,
                color: kPrimaryColor,
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (_) => SizedBox(
                        height: getProportionateScreenHeight(300),
                        child: PriceMenu()));
              },
            ),
            ListTile(
              title: Text(
                'Logout',
                style: GoogleFonts.nunitoSans(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              leading:
                  const Icon(FontAwesomeIcons.signOutAlt, color: kPrimaryColor),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
              },
            ),
          ],
        ),
      ),
    );
  }
}
