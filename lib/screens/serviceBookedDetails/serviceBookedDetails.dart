import 'dart:convert';

import 'package:esoptron_salon/constants/size_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ServiceBookedDetails extends StatefulWidget {
  static String routeName = "/serviceBookedDetails";
  const ServiceBookedDetails({super.key});

  @override
  State<ServiceBookedDetails> createState() => _ServiceBookedDetailsState();
}

class _ServiceBookedDetailsState extends State<ServiceBookedDetails> {
  Future<List<dynamic>> bookingAction(action, id, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authorizationToken = prefs.getString("auth_token");
    final response = await http.post(
      action == "accept"
          ? Uri.parse("http://admin.esoptronsalon.com/api/bookings/$id/accept")
          : Uri.parse("http://admin.esoptronsalon.com/api/bookings/$id/reject"),
      headers: {
        'Authorization': 'Bearer $authorizationToken',
        'Content-Type':
            'application/json', // You may need to adjust the content type based on your API requirements
      },
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseData = json.decode(response.body);
      if (responseData['success'] == "true") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${responseData['message']}"),
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${responseData['message']}"),
          backgroundColor: Colors.red,
        ));
      }
      return [];
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something went wrong"),
        backgroundColor: Colors.red,
      ));
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic data = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Service Booked Details"),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(height: getProportionateScreenHeight(5)),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text("Customer Details",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'http://admin.esoptronsalon.com/${data['customer']['avatar']}')),
                title: Text("${data['customer']['name']}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${data['address']}"),
                    Text(
                      "${data['time']}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Categories Details",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ],
          ),
          for (int i = 0; i < data['sub_categories'].length; i++)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'http://admin.esoptronsalon.com/storage/sub_categories/${data['sub_categories'][i]['image']}')),
                  title: Text("${data['sub_categories'][i]['name']}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${data['sub_categories'][i]['description']}"),
                      Text(
                        "${data['sub_categories'][i]['charge']}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () =>
                        bookingAction("accept", data['id'], context),
                    child: const Text("Accept")),
                SizedBox(
                  width: getProportionateScreenWidth(15),
                ),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () =>
                        bookingAction("reject", data['id'], context),
                    child: const Text("Reject"))
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
