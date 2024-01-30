import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/controllers/getFavorites.dart';
import 'package:esoptron_salon/screens/servicedetails/service_details.dart';
import 'package:esoptron_salon/utils/enums/global_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  static String routeName = "/favorite";
  const FavoriteScreen({super.key});

  @override
  ConsumerState<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor.withOpacity(0.8),
        title: Text("Favorites",
            style: GoogleFonts.nunitoSans(
                textStyle: TextStyle(
              color: Colors.white,
              fontSize: getProportionateScreenWidth(20),
              fontWeight: FontWeight.w600,
            ))),
      ),
      body: Builder(builder: (context) {
        // ref.invalidate(documentsProvider);
        final favoritesState = ref.watch(favoritesProvider);
        switch (favoritesState.status) {
          case Status.initial:
          case Status.loading:
            return const Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            );
          case Status.loaded:
            var favorites = [];
            //print(favoritesState.data!.data.toString());
            for (var element
                in favoritesState.data!.data['favourite_services']) {
              favorites.add(element);
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  for (int i = 0; i < favorites.length; i++)
                    favoriteCard(
                        favorites[i]['logo'],
                        favorites[i]['name'],
                        favorites[i]['description'],
                        favorites[i]['favourite_service_id']),
                  SizedBox(
                    width: getProportionateScreenWidth(15),
                  )
                ],
              ),
            );
          case Status.error:
            return SizedBox(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                          width: getProportionateScreenWidth(200),
                          height: getProportionateScreenHeight(200),
                          image: const AssetImage(
                              "assets/images/favorites/favorite.png"),
                          fit: BoxFit.cover),
                      const Text(
                        "No favorites yet!",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ),
            );
        }
      }),
    );
  }

  Padding favoriteCard(
      String image, String serviceName, String serviceType, int id) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Container(
            height: getProportionateScreenHeight(195),
            width: getProportionateScreenWidth(360),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withOpacity(0.6),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: Image(
                        height: 200,
                        width: 140,
                        image: NetworkImage(
                            'http://admin.esoptronsalon.com/$image'),
                        fit: BoxFit.cover),
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(10),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        serviceName,
                        style: GoogleFonts.nunitoSans(
                            textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(16),
                          fontWeight: FontWeight.w500,
                        )),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(5),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(200),
                        child: Text(
                          serviceType,
                          style: GoogleFonts.nunitoSans(
                              textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(12),
                            fontWeight: FontWeight.w400,
                          )),
                        ),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(5),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              foregroundColor: kPrimaryColor,
                              backgroundColor: kPrimaryColor),
                          onPressed: () async {
                            //print(arguments[0]);
                            // SharedPreferences prefs =
                            //     await SharedPreferences.getInstance();
                            // String? authorizationToken =
                            //     prefs.getString("auth_token");
                            // final response = await http.get(
                            //   Uri.parse(
                            //       "http://admin.esoptronsalon.com/api/service/${servicesList[i]["id"]}/details"),
                            //   headers: {
                            //     'Authorization': 'Bearer $authorizationToken',
                            //     'Content-Type':
                            //         'application/json', // You may need to adjust the content type based on your API requirements
                            //   },
                            // );
                            // if (response.statusCode >= 200 &&
                            //     response.statusCode < 300) {
                            //   final responseData = json.decode(response.body);
                            //   setState(() {
                            //     serviceProvider = responseData['data']
                            //         ['service']['service_provider'];
                            //   });
                            // } else {
                            //   setState(() {
                            //     serviceProvider = {
                            //       'name': '',
                            //       'email': '',
                            //       'avatar': '',
                            //       'phone': ''
                            //     };
                            //   });
                            // }
                            // // ignore: use_build_context_synchronously
                            // Navigator.pushNamed(
                            //     context, ServiceDetails.routeName,
                            //     arguments: [
                            //       servicesList[i]["name"],
                            //       "http://admin.esoptronsalon.com/${servicesList[i]["logo"]}",
                            //       servicesList[i]["description"],
                            //       serviceProvider,
                            //       servicesList[i]["ratings_count"],
                            //       servicesList[i]["is_available"] == 0
                            //           ? false
                            //           : true,
                            //       servicesList[i]["ratings_count"],
                            //       true,
                            //       servicesList[i]["id"],
                            //       arguments[0]
                            //     ]);
                          },
                          child: Text(
                            "View Service",
                            style: GoogleFonts.nunitoSans(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: getProportionateScreenWidth(12),
                                    fontWeight: FontWeight.w500)),
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
    // return Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: Container(
    //       height: getProportionateScreenHeight(150),
    //       width: getProportionateScreenWidth(360),
    //       decoration: BoxDecoration(
    //           borderRadius: const BorderRadius.all(Radius.circular(10)),
    //           border: Border.all(
    //             width: 2,
    //             color: kPrimaryColor,
    //           )),
    //       child: ListTile(
    //         leading: ClipRRect(
    //           borderRadius: BorderRadius.circular(10),
    //           child: Image(
    //               height: getProportionateScreenHeight(150),
    //               image: NetworkImage('http://admin.esoptronsalon.com/$image')),
    //         ),
    //         title: Text(
    //           serviceName,
    //           style: TextStyle(
    //               color: kPrimaryColor,
    //               fontSize: getProportionateScreenWidth(19),
    //               fontWeight: FontWeight.bold,
    //               fontFamily: 'krona'),
    //         ),
    //         subtitle: FilledButton(
    //             onPressed: () {
    //               Navigator.pushNamed(context, ServiceDetails.routeName,
    //                   arguments: id);
    //             },
    //             child: const Text("Service Details")),
    //         trailing: const Padding(
    //           padding: EdgeInsets.all(8.0),
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [Icon(Icons.favorite, color: kPrimaryColor)],
    //           ),
    //         ),
    //       )
    //   Row(
    //     children: [
    //       Image(image: NetworkImage('http://admin.esoptronsalon.com/$image')),
    //       Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //           children: [
    //             Text(
    //               serviceName,
    //               style: TextStyle(
    //                   color: kPrimaryColor,
    //                   fontSize: getProportionateScreenWidth(15),
    //                   fontWeight: FontWeight.bold,
    //                   fontFamily: 'krona'),
    //             ),
    //             // Text(
    //             //   serviceType,
    //             //   style: TextStyle(
    //             //       color: Colors.black,
    //             //       fontSize: getProportionateScreenWidth(15),
    //             //       fontWeight: FontWeight.bold,
    //             //       fontFamily: 'krona'),
    //             // ),
    // FilledButton(
    //     onPressed: () {},
    //     child: const Padding(
    //       padding: EdgeInsets.all(13.0),
    //       child: Text("Service Details"),
    //     ))
    //           ],
    //         ),
    //       ),
    //       const Padding(
    //         padding: EdgeInsets.all(8.0),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [Icon(Icons.favorite, color: kPrimaryColor)],
    //         ),
    //       )
    //     ],
    //   ),
    //       ),
    // );
  }
}
