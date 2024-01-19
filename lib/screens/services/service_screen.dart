import 'dart:convert';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/providers/profileProviders.dart';
import 'package:esoptron_salon/screens/favorites/favorite_screen.dart';
import 'package:esoptron_salon/screens/services/components/body.dart';
import 'package:esoptron_salon/screens/subcategories/searched_subcategory.dart';
import 'package:esoptron_salon/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<NetworkImage>(
            future: getImage(),
            builder: (context, snapshot) {
              //print(snapshot);
              if (snapshot.connectionState == ConnectionState.done) {
                return CircleAvatar(
                  radius: 5,
                  backgroundImage: snapshot.data,
                );
              } else {
                // You can return a placeholder or loading indicator while the image is loading
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
        title: TextFieldWidget(
          radiusBottomLeft: 30,
          radiusBottomRight: 30,
          radiusTopLeft: 30,
          radiusTopRight: 30,
          controller: searchController,
          hintText: "Search for service",
          suffixWidget: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(60))),
                child: GestureDetector(
                  onTap: () async {
                    if (searchController.text.isEmpty) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Please enter a search term"),
                        backgroundColor: kPrimaryColor,
                        padding: EdgeInsets.all(25),
                      ));
                      return;
                    }
                    setState(() {
                      isSearching = true;
                    });
                    List<dynamic> searchResults =
                        await search(searchController.text);
                    setState(() {
                      isSearching = false;
                    });
                    if (searchResults.isNotEmpty) {
                      // ignore: use_build_context_synchronously
                      Navigator.pushNamed(
                          context, SearchedSubCategories.routeName,
                          arguments: searchResults);
                    } else {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("No results found"),
                        backgroundColor: kPrimaryColor,
                        padding: EdgeInsets.all(25),
                      ));
                    }
                  },
                  child: isSearching
                      ? SizedBox(
                          height: getProportionateScreenHeight(8),
                          width: getProportionateScreenWidth(8),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : const Icon(
                          FontAwesomeIcons.search,
                          color: Colors.white,
                        ),
                )),
          ),
        ),
        actions: [
          // const Icon(
          //   FontAwesomeIcons.solidBookmark,
          //   color: kPrimaryColor,
          // ),
          SizedBox(
            width: getProportionateScreenWidth(5),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, FavoriteScreen.routeName),
            child: const Icon(
              FontAwesomeIcons.solidHeart,
              color: kPrimaryColor,
            ),
          ),
          // const Icon(
          //   FontAwesomeIcons.solidHeart,
          //   color: kPrimaryColor,
          // ),
          SizedBox(
            width: getProportionateScreenWidth(15),
          ),
        ],
      ),
      body: const Body(),
    );
  }
}
