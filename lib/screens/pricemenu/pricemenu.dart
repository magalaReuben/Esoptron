import 'package:awesome_icons/awesome_icons.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/widgets/default_button.dart';
import 'package:esoptron_salon/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PriceMenu extends StatefulWidget {
  bool selected = false;
  static String routeName = "price_menu";
  PriceMenu({super.key});

  @override
  State<PriceMenu> createState() => _PriceMenuState();
}

class _PriceMenuState extends State<PriceMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: BottomAppBar(
      //   child: SizedBox(
      //     height: getProportionateScreenHeight(90),
      //     child: const Padding(
      //       padding: EdgeInsets.all(13.0),
      //       child: DefaultButton(
      //         text: "Book Now",
      //       ),
      //     ),
      //   ),
      // ),
      appBar: AppBar(
        backgroundColor: kPrimaryColor.withOpacity(0.8),
        // actions: const [
        //   Padding(
        //     padding: EdgeInsets.all(8.0),
        //     child: Icon(
        //       FontAwesomeIcons.filter,
        //       color: Colors.white,
        //       size: 20,
        //     ),
        //   )
        // ],
        centerTitle: false,
        title: Text("Price Menu",
            style: GoogleFonts.nunitoSans(
              fontSize: getProportionateScreenWidth(18),
              color: Colors.white,
              fontWeight: FontWeight.w600,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextFieldWidget(
            //     radiusBottomLeft: 30,
            //     radiusBottomRight: 30,
            //     radiusTopLeft: 30,
            //     radiusTopRight: 30,
            //     hintText: "Search for service",
            //     suffixWidget: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Container(
            //           decoration: const BoxDecoration(
            //               color: kPrimaryColor,
            //               borderRadius: BorderRadius.all(Radius.circular(60))),
            //           child: const Icon(
            //             FontAwesomeIcons.search,
            //             color: Colors.white,
            //           )),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "HAIRSTYLES",
                style: GoogleFonts.nunitoSans(
                  fontSize: getProportionateScreenWidth(18),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            priceItem("Crotchets", "UGX 45,000"),
            priceItem("Twists & Threes short", "UGX 55,000"),
            priceItem("Twists & Threes Long", "UGX 30-60,000"),
            priceItem("Bob", "UGX 35,000"),
            priceItem("Butterfly Locs", "UGX 50000"),
            priceItem("Passion Twists", "UGX 50000"),
            priceItem("DreadLocks", "UGX 150,000 And Above"),
            priceItem("Weaves", "UGX 40,000"),
            priceItem("Faux Locs", "UGX 50,000"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "MANICURE & PEDICURE",
                style: GoogleFonts.nunitoSans(
                  fontSize: getProportionateScreenWidth(18),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            priceItem("Manicure & Pedicure", "UGX 30-100,000"),
            // priceItem("Gel Builder", "UGX 50000"),
            // priceItem("Polish Change", "UGX 50000"),
            // priceItem("Stick on", "UGX 50000"),
            // priceItem("Nail Clipping", "UGX 50000"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("WAXING",
                  style: GoogleFonts.nunitoSans(
                    fontSize: getProportionateScreenWidth(18),
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            priceItem("waxing", "UGX 150-300,000"),
            // priceItem("Body wax", "UGX 50000"),
            // priceItem("Bikini wax", "UGX 50000"),
            // priceItem("Face wax", "UGX 50000"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "ADDS ON",
                style: GoogleFonts.nunitoSans(
                  fontSize: getProportionateScreenWidth(18),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            priceItem("Adds on", "UGX 5-10,000"),
            // priceItem("Treatment", "UGX 50000"),
            // priceItem("Washing", "UGX 50000"),
            // priceItem("Relaxing", "UGX 50000"),
          ],
        ),
      ),
    );
  }

  Padding priceItem(String item, String price) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Checkbox(
              //     checkColor: Colors.white,
              //     value: widget.selected,
              //     onChanged: (bool? value) {
              //       setState(() {
              //         widget.selected = value!;
              //       });
              //     }),
              Text(
                item,
                style: GoogleFonts.nunitoSans(
                  fontSize: getProportionateScreenWidth(14),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text(
            price,
            style: GoogleFonts.nunitoSans(
              fontSize: getProportionateScreenWidth(14),
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
