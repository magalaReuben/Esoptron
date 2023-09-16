import 'package:esoptron_salon/constants/size_config.dart';
import 'package:flutter/material.dart';

class StatementPopup extends StatelessWidget {
  const StatementPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Card(
            child: ListTile(
              trailing: const Text("-UGX3,000.00"),
              title: Text(
                "Service fee",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(17),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'krona'),
              ),
              subtitle: const Text("July 7, 2022"),
            ),
          ),
          Card(
            child: ListTile(
              trailing: const Text("-UGX2,000.00"),
              title: Text(
                "Service fee",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(17),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'krona'),
              ),
              subtitle: const Text("July 7, 2022"),
            ),
          ),
          Card(
            child: ListTile(
              trailing: const Text("-UGX1,000.00"),
              title: Text(
                "Top Up",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(17),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'krona'),
              ),
              subtitle: const Text("July 7, 2022"),
            ),
          ),
          Card(
            child: ListTile(
              trailing: const Text("-UGX2,000.00"),
              title: Text(
                "Service fee",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(17),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'krona'),
              ),
              subtitle: const Text("July 7, 2022"),
            ),
          ),
          Card(
            child: ListTile(
              trailing: const Text("-UGX2,000.00"),
              title: Text(
                "Service fee",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(17),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'krona'),
              ),
              subtitle: const Text("July 7, 2022"),
            ),
          ),
          Card(
            child: ListTile(
              trailing: const Text("-UGX1,000.00"),
              title: Text(
                "Top Up",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(17),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'krona'),
              ),
              subtitle: const Text("July 7, 2022"),
            ),
          ),
          FilledButton(
              onPressed: () {},
              child: const Padding(
                padding: EdgeInsets.all(13.0),
                child: Text("Download"),
              ))
        ],
      ),
    );
  }
}
