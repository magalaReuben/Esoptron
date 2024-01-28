import 'dart:convert';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/providers/profileProviders.dart';
import 'package:esoptron_salon/screens/favorites/favorite_screen.dart';
import 'package:esoptron_salon/screens/pricemenu/pricemenu.dart';
import 'package:esoptron_salon/screens/services/components/body.dart';
import 'package:esoptron_salon/screens/servicesbooked/services_booked.dart';
import 'package:esoptron_salon/screens/subcategories/searched_subcategory.dart';
import 'package:esoptron_salon/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ServiceScreen extends ConsumerStatefulWidget {
  const ServiceScreen({super.key});

  @override
  ConsumerState<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends ConsumerState<ServiceScreen> {
  bool isSearching = false;

  Future<List<dynamic>> search(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authorizationToken = prefs.getString("auth_token");
    final response = await http.get(
      Uri.parse(
          "http://admin.esoptronsalon.com/api/service/search?keyword=keyword=$query"),
      headers: {
        'Authorization': 'Bearer $authorizationToken',
        'Content-Type':
            'application/json', // You may need to adjust the content type based on your API requirements
      },
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> serviceList = json.decode(response.body);
      return serviceList;
    } else {
      return [];
    }
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

  // new year commit
  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: Builder(
            builder: (context) => IconButton(
                  icon: const Icon(FontAwesomeIcons.bars, color: Colors.black),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                )),
        title: Text('Esoptron Salon',
            style: GoogleFonts.pacifico(
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionateScreenWidth(20)),
            )),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: FutureBuilder<NetworkImage>(
        //       future: getImage(),
        //       builder: (context, snapshot) {
        //         //print(snapshot);
        //         if (snapshot.connectionState == ConnectionState.done) {
        //           return CircleAvatar(
        //             radius: 25,
        //             backgroundImage: snapshot.data,
        //           );
        //         } else {
        //           // You can return a placeholder or loading indicator while the image is loading
        //           return const CircularProgressIndicator();
        //         }
        //       },
        //     ),
        //   )
        // const Icon(
        //   FontAwesomeIcons.solidBookmark,
        //   color: kPrimaryColor,
        // ),
        // SizedBox(
        //   width: getProportionateScreenWidth(5),
        // ),
        // GestureDetector(
        //   onTap: () => Navigator.pushNamed(context, FavoriteScreen.routeName),
        //   child: const Icon(
        //     FontAwesomeIcons.solidHeart,
        //     color: kPrimaryColor,
        //   ),
        // ),
        // // const Icon(
        // //   FontAwesomeIcons.solidHeart,
        // //   color: kPrimaryColor,
        // // ),
        // SizedBox(
        //   width: getProportionateScreenWidth(15),
        // ),
        //],
      ),
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
                FontAwesomeIcons.bell,
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
                FontAwesomeIcons.heart,
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
      body: const Body(),
    );
  }
}
