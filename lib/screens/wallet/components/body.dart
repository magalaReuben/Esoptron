import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/providers/profileProviders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Body extends ConsumerStatefulWidget {
  const Body({super.key});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends ConsumerState<Body> {
  String? firstName;
  String? lastName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfileInfo();
  }

  Future getProfileInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? avatar = prefs.getString("avatar");
    setState(() {
      firstName = prefs.getString("firstName");
      lastName = prefs.getString("lastName");
    });
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                FutureBuilder<NetworkImage>(
                  future: getImage(),
                  builder: (context, snapshot) {
                    print(snapshot);
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
                SizedBox(
                  width: getProportionateScreenWidth(15),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        children: [
                          Text("$firstName $lastName",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: getProportionateScreenWidth(17),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'krona')),
                          SizedBox(
                            width: getProportionateScreenWidth(135),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text("Current balance: UGX 10,712:00",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(17),
                              fontWeight: FontWeight.normal,
                              fontFamily: 'krona')),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(10),
                    ),
                  ],
                )
              ],
            ),
          ),
          walletDetails(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Transaction History",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(17),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'krona'),
                ),
              ],
            ),
          ),
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
          )
        ],
      ),
    );
  }

  Container walletDetails() {
    return Container(
      width: getProportionateScreenWidth(350),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black.withOpacity(0.4),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("Top Up",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(17),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'krona')),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Image.asset("assets/images/services/bank.png"),
                      SizedBox(
                        height: getProportionateScreenHeight(15),
                      ),
                      Text("Bank",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(15),
                              fontWeight: FontWeight.normal,
                              fontFamily: 'krona'))
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset("assets/images/services/transfer.png"),
                      SizedBox(
                        height: getProportionateScreenHeight(15),
                      ),
                      Text("Transfer",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(15),
                              fontWeight: FontWeight.normal,
                              fontFamily: 'krona'))
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset("assets/images/services/card.png"),
                      SizedBox(
                        height: getProportionateScreenHeight(15),
                      ),
                      Text("Card",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(15),
                              fontWeight: FontWeight.normal,
                              fontFamily: 'krona'))
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
