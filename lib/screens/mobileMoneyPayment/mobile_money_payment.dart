import 'dart:convert';
import 'package:esoptron_salon/helper/url_launcher.dart';
import 'package:esoptron_salon/providers/profileProviders.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/widgets/default_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MobileMoneyPaymentScreen extends ConsumerStatefulWidget {
  static const routeName = '/mobile-money-payment';
  const MobileMoneyPaymentScreen({super.key});

  @override
  ConsumerState<MobileMoneyPaymentScreen> createState() =>
      _MobileMoneyPaymentScreenState();
}

class _MobileMoneyPaymentScreenState
    extends ConsumerState<MobileMoneyPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? charge;
  String? currency;
  String? description;
  int? bookingId;
  bool isCurrencyLoading = true;

  @override
  void initState() {
    super.initState();
    getUserNames();
  }

  Future<List<dynamic>> getTotalSubCategoryDetails(ids) async {
    List<dynamic> detailsHolder = [];
    for (var id in ids) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authorizationToken = prefs.getString("auth_token");
      final response = await http.get(
        Uri.parse(
            "http://admin.esoptronsalon.com/api/sub_category/$id/details"),
        headers: {
          'Authorization': 'Bearer $authorizationToken',
          'Content-Type':
              'application/json', // You may need to adjust the content type based on your API requirements
        },
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);
        detailsHolder.add({
          "unit": responseData['data']['charge_unit'],
          "charge": responseData['data']['charge'],
          "description": responseData['data']['description'],
          "image": responseData['data']['image']
        });
      } else {
        return [];
      }
    }
    if (detailsHolder.isNotEmpty) {
      return detailsHolder;
    } else {
      return [];
    }
  }

  Future getUserNames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? firstName = prefs.getString("firstName");
    String? lastName = prefs.getString("lastName");
    String userName = "$firstName $lastName";
    ref.read(userNameProvider.notifier).state = userName;
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> aruments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    final userName = ref.watch(userNameProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment",
            style: GoogleFonts.nunitoSans(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: getProportionateScreenWidth(20),
                fontWeight: FontWeight.w400,
              ),
            )),
        // centerTitle: true,
        backgroundColor: kPrimaryColor.withOpacity(0.8),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: getProportionateScreenHeight(250),
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [kPrimaryColor, kPrimaryColor.withOpacity(0.7)]),
                  borderRadius: BorderRadius.circular(13.0)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const ListTile(
                      trailing: Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "${aruments[1]}",
                        style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: getProportionateScreenWidth(20),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "$userName",
                        style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: getProportionateScreenWidth(17),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      trailing: Text(
                        "${aruments[4]}",
                        style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: getProportionateScreenWidth(17),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "${aruments[3]} ${aruments[2]}",
                        style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: getProportionateScreenWidth(17),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image(
                            height: getProportionateScreenHeight(60),
                            width: getProportionateScreenWidth(60),
                            image: const AssetImage(
                                'assets/images/mobilemoney/mm.png')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Booking Summary",
                    style: GoogleFonts.nunitoSans(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(18),
                        fontWeight: FontWeight.w500,
                      ),
                    )),
              ),
            ],
          ),
          FutureBuilder<List<dynamic>>(
            future: getTotalSubCategoryDetails(aruments[5]),
            builder: (context, snapshot) {
              //print(snapshot.data);
              if (snapshot.connectionState == ConnectionState.done) {
                isCurrencyLoading
                    ? Future(() => setState(() {
                          charge = snapshot.data![0]['charge'].toString();
                          currency = snapshot.data![0]['unit'].toString();
                          isCurrencyLoading = false;
                        }))
                    : null;
                return Column(
                  children: [
                    for (int i = 0; i < snapshot.data!.length; i++)
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Container(
                              height: getProportionateScreenHeight(120),
                              width: getProportionateScreenWidth(350),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white.withOpacity(0.6),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      child: Image(
                                          height:
                                              getProportionateScreenHeight(120),
                                          width:
                                              getProportionateScreenWidth(100),
                                          image: NetworkImage(
                                              "http://admin.esoptronsalon.com/${snapshot.data![i]["image"]}"),
                                          fit: BoxFit.cover),
                                    ),
                                    SizedBox(
                                      width: getProportionateScreenWidth(10),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width:
                                              getProportionateScreenWidth(200),
                                          child: Text(
                                            '${snapshot.data![i]['description']} \n UGX ${snapshot.data![i]['charge'].toString()}',
                                            style: GoogleFonts.nunitoSans(
                                                textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      16),
                                              fontWeight: FontWeight.w500,
                                            )),
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                              getProportionateScreenHeight(5),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                  ],
                );
              } else {
                return isLoading
                    ? Container()
                    : const CircularProgressIndicator(
                        color: kPrimaryColor,
                      );
              }
            },
          ),
          Expanded(child: Container()),
          isLoading
              ? const CircularProgressIndicator(
                  color: kPrimaryColor,
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DefaultButton(
                    text: "Checkout",
                    press: () async {
                      setState(() {
                        isLoading = true;
                      });
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String? authorizationToken =
                          prefs.getString("auth_token");
                      final data = jsonEncode({
                        "amount": "${aruments[3]}",
                        "payment_type": "mobile money",
                        "booking_id": '${aruments[0]}',
                        "phone_number": "${aruments[1]}"
                      });
                      final response = await http.post(
                        Uri.parse(
                            "http://admin.esoptronsalon.com/api/bookings/pay"),
                        body: data,
                        headers: {
                          'Authorization': 'Bearer $authorizationToken',
                          'Content-Type': 'application/json',
                          'X-Requested-With': 'XMLHttpRequest'
                        },
                      );
                      final responseData = json.decode(response.body);
                      print(responseData);
                      if (response.statusCode >= 200 &&
                          response.statusCode < 300) {
                        final responseData = json.decode(response.body);
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Booking Payment Initiated"),
                          backgroundColor: kPrimaryColor,
                          padding: EdgeInsets.all(25),
                        ));
                        launchURL(responseData['redirect-link']);
                        //print(responseData['redirect-link']);
                      } else {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("${responseData['message']}"),
                          backgroundColor: kPrimaryColor,
                          padding: const EdgeInsets.all(25),
                        ));
                      }
                      setState(() {
                        isLoading = false;
                      });
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
