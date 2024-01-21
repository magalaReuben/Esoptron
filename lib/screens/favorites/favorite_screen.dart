import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/controllers/getFavorites.dart';
import 'package:esoptron_salon/screens/servicedetails/service_details.dart';
import 'package:esoptron_salon/utils/enums/global_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        centerTitle: true,
        title: Text(
          "Favorites",
          style: TextStyle(fontSize: getProportionateScreenWidth(18)),
        ),
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
      child: Container(
          height: getProportionateScreenHeight(150),
          width: getProportionateScreenWidth(360),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                width: 2,
                color: kPrimaryColor,
              )),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image(
                  height: getProportionateScreenHeight(150),
                  image: NetworkImage('http://admin.esoptronsalon.com/$image')),
            ),
            title: Text(
              serviceName,
              style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: getProportionateScreenWidth(19),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'krona'),
            ),
            subtitle: FilledButton(
                onPressed: () {
                  Navigator.pushNamed(context, ServiceDetails.routeName,
                      arguments: id);
                },
                child: const Text("Service Details")),
            trailing: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.favorite, color: kPrimaryColor)],
              ),
            ),
          )
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
          ),
    );
  }
}
