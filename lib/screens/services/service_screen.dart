import 'dart:convert';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/screens/favorites/favorite_screen.dart';
import 'package:esoptron_salon/screens/services/components/body.dart';
import 'package:esoptron_salon/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ServiceScreen extends StatelessWidget {
  const ServiceScreen({super.key});

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

  // new year commit
  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
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
                    List<dynamic> searchResults =
                        await search(searchController.text);

                    if (searchResults.isNotEmpty) {
                    } else {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("No results found"),
                        backgroundColor: kPrimaryColor,
                        padding: EdgeInsets.all(25),
                      ));
                    }
                  },
                  child: const Icon(
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
