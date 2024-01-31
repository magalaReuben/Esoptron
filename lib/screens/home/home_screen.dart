import 'dart:convert';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/providers/profileProviders.dart';
import 'package:esoptron_salon/screens/favorites/favorite_screen.dart';
import 'package:esoptron_salon/screens/home/components/body.dart';
import 'package:esoptron_salon/screens/pricemenu/pricemenu.dart';
import 'package:esoptron_salon/screens/servicesbooked/services_booked.dart';
import 'package:esoptron_salon/screens/subcategories/searched_subcategory.dart';
import 'package:esoptron_salon/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    getProfileInfo();
  }

  TextEditingController searchController = TextEditingController();

  Future getProfileInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? avatar = prefs.getString("avatar");
    ref.read(profilePicProvider.notifier).state = avatar;
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

  Future<List<dynamic>> search(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authorizationToken = prefs.getString("auth_token");
    final response = await http.get(
      Uri.parse(
          "http://admin.esoptronsalon.com/api/sub_category/search?keyword=$query"),
      headers: {
        'Authorization': 'Bearer $authorizationToken',
        'Content-Type':
            'application/json', // You may need to adjust the content type based on your API requirements
      },
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      var data = json.decode(response.body);
      return data['data']['search-results'];
    } else {
      return [];
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
          title: Text('Esoptron Salon',
              style: GoogleFonts.pacifico(
                textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(20)),
              )),
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
          ],
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
                leading: const Icon(FontAwesomeIcons.signOutAlt,
                    color: kPrimaryColor),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                },
              ),
            ],
          ),
        ),
        body: const Body());
  }
}
