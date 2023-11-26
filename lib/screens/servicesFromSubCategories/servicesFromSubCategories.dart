import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/controllers/getService.dart';
import 'package:esoptron_salon/controllers/getSubCategory.dart';
import 'package:esoptron_salon/providers/contentProvisionProviders.dart';
import 'package:esoptron_salon/screens/servicedetails/service_details.dart';
import 'package:esoptron_salon/utils/enums/global_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServicesList extends ConsumerStatefulWidget {
  static String routeName = "/ServicesList";
  const ServicesList({super.key});

  @override
  ConsumerState<ServicesList> createState() => _ServicesListState();
}

class _ServicesListState extends ConsumerState<ServicesList> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    print("my id is : ${arguments[0]}");
    Future(() {
      ref.read(getServiceIdProvider.notifier).state = arguments[0];
    });
    final services = ref.watch(servicesProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(arguments[2]),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Builder(builder: (context) {
              switch (services.status) {
                case Status.initial:
                case Status.loading:
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 50),
                      Center(
                        child: CircularProgressIndicator(
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  );
                case Status.loaded:
                  var servicesList = [];
                  for (var element in services.data!.data['services']['data']) {
                    servicesList.add(element);
                  }
                  print(servicesList);
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        for (int i = 0; i < servicesList.length; i++)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: getProportionateScreenHeight(150),
                              width: getProportionateScreenWidth(360),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(
                                    width: 2,
                                    color: kPrimaryColor,
                                  )),
                              child: Row(
                                children: [
                                  Image(
                                      //image: NetImage(image),
                                      image: NetworkImage(
                                          "http://admin.esoptronsalon.com/${servicesList[i]["logo"]}"),
                                      fit: BoxFit.cover),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          "${servicesList[i]["name"]}",
                                          style: TextStyle(
                                              color: kPrimaryColor,
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      18),
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'krona'),
                                        ),
                                        FilledButton(
                                            onPressed: () =>
                                                Navigator.pushNamed(context,
                                                    ServiceDetails.routeName,
                                                    arguments: [
                                                      servicesList[i]["name"],
                                                      "http://admin.esoptronsalon.com/${servicesList[i]["logo"]}",
                                                      servicesList[i]
                                                          ["description"],
                                                      {},
                                                      servicesList[i]
                                                          ["ratings_count"],
                                                      servicesList[i][
                                                                  "is_available"] ==
                                                              0
                                                          ? false
                                                          : true,
                                                      servicesList[i]
                                                          ["ratings_count"],
                                                      false,
                                                      arguments[1],
                                                      arguments[2],
                                                      servicesList[i]["id"],
                                                      arguments[0]
                                                    ]),
                                            child: const Padding(
                                              padding: EdgeInsets.all(13.0),
                                              child: Text("Select"),
                                            ))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        SizedBox(
                          width: getProportionateScreenWidth(15),
                        )
                      ],
                    ),
                  );
                case Status.error:
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: getProportionateScreenHeight(50)),
                    ],
                  );
              }
            }),
          ],
        ),
      ),
    );
  }
}
