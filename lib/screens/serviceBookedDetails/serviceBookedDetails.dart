import 'package:esoptron_salon/constants/size_config.dart';
import 'package:flutter/material.dart';

class ServiceBookedDetails extends StatefulWidget {
  static String routeName = "/serviceBookedDetails";
  const ServiceBookedDetails({super.key});

  @override
  State<ServiceBookedDetails> createState() => _ServiceBookedDetailsState();
}

class _ServiceBookedDetailsState extends State<ServiceBookedDetails> {
  @override
  Widget build(BuildContext context) {
    dynamic data = ModalRoute.of(context)!.settings.arguments;
    print(data);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Service Booked Details"),
      ),
      body: Column(children: [
        SizedBox(height: getProportionateScreenHeight(10)),
        const Row(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
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
                        'http://admin.esoptronsalon.com/storage/${data['sub_categories'][i]['image']}')),
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
      ]),
    );
  }
}
