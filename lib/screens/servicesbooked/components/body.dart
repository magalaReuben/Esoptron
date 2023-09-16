import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Services Booked",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(20),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'krona'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Divider(
              color: Colors.black.withOpacity(0.9),
              thickness: 1.5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Add More",
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: getProportionateScreenWidth(15),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'krona'),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.add_circle_outline,
                      size: 20, color: kPrimaryColor),
                )
              ],
            ),
          ),
          serviceBoooked("Dreadlocks style for Medium hair", ".Dread Service",
              "20", "assets/images/servicesBooked/image1.png"),
          serviceBoooked("Classic Manicure", ".Manicure Service", "30",
              "assets/images/servicesBooked/image2.png"),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Divider(
              color: Colors.black.withOpacity(0.9),
              thickness: 1.5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  "Service Provider",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(17),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'krona'),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              serviceProvider('assets/images/servicesBooked/chinoso.png',
                  "Chinoso", "Kampala,6th street"),
              serviceProvider('assets/images/servicesBooked/wonder.png',
                  "Wonder", "Masindi,6th street"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Change Specialist",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: kPrimaryColor,
                    fontSize: getProportionateScreenWidth(17),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'krona'),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Divider(
              color: Colors.black.withOpacity(0.9),
              thickness: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Padding serviceProvider(String image, String name, String location) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      child: SizedBox(
        width: getProportionateScreenWidth(130),
        height: getProportionateScreenHeight(210),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 30,
                foregroundImage: AssetImage(image),
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(5)),
            Text(
              name,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionateScreenWidth(17),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'krona'),
            ),
            SizedBox(height: getProportionateScreenHeight(5)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_pin,
                  size: 15,
                  color: kPrimaryColor,
                ),
                Text(
                  location,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(13),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'krona'),
                ),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.phone,
                    size: 15,
                    color: kPrimaryColor,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.chat,
                    size: 15,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Padding serviceBoooked(
      String title, String subTitle, String price, String image) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        trailing:
            const Icon(Icons.favorite_outline, color: kPrimaryColor, size: 25),
        tileColor: Colors.transparent,
        subtitle: Row(
          children: [
            Text(
              "\$$price",
              style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: getProportionateScreenWidth(18),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'krona'),
            ),
            Text(
              subTitle,
              style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: getProportionateScreenWidth(18),
                  fontWeight: FontWeight.normal,
                  fontFamily: 'krona'),
            ),
          ],
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            title,
            style: TextStyle(
                color: Colors.black,
                fontSize: getProportionateScreenWidth(15),
                fontWeight: FontWeight.bold,
                fontFamily: 'krona'),
          ),
        ),
        leading: Image.asset(image),
      ),
    );
  }
}
