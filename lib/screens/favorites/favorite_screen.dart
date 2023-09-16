import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  static String routeName = "/favorite";
  const FavoriteScreen({super.key});

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [favoriteCard(), favoriteCard()],
        ),
      ),
    );
  }

  Padding favoriteCard() {
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
        child: Row(
          children: [
            Image.asset("assets/images/favorites/image1.png"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Classic Manicure",
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: getProportionateScreenWidth(18),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'krona'),
                  ),
                  Text(
                    "Manicure & Pedicure",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(15),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'krona'),
                  ),
                  FilledButton(
                      onPressed: () {},
                      child: const Padding(
                        padding: EdgeInsets.all(13.0),
                        child: Text("Service Details"),
                      ))
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.favorite, color: kPrimaryColor)],
              ),
            )
          ],
        ),
      ),
    );
  }
}
