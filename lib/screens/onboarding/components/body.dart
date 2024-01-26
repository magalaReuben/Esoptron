import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/screens/login/login_screen.dart';
import 'package:esoptron_salon/widgets/app_text.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  PageController? pageController = PageController();
  List<Map<String, String>> onBoardingData = [
    {
      "image": "assets/images/splash/1.png",
      "title": "Get Your Hair Styled Today",
      "subtitle":
          "Book for different hair styles like\n braids, dreads, twists, natural locs."
    },
    {
      "image": "assets/images/splash/2.png",
      "title": "Book For Makeup Services",
      "subtitle":
          "Order for body waxing service like\n arm waxing, back waxing etc."
    },
    {
      "image": "assets/images/splash/3.png",
      "title": "Book For Makeup Services",
      "subtitle": "Interested in any make up style,\n worry no more"
    },
    {
      "image": "assets/images/splash/4.png",
      "title": "Manicure & Pedicure Services",
      "subtitle": "In the comfort of your home, book\n your favourite stylist"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
        child: PageView.builder(
      controller: pageController,
      onPageChanged: (value) {
        setState(() {
          currentPage = value;
        });
      },
      itemCount: onBoardingData.length,
      itemBuilder: (context, index) => onBoardingPage(
          onBoardingData[index]["image"],
          onBoardingData[index]["title"],
          onBoardingData[index]["subtitle"],
          index,
          pageController),
    ));
  }

  Column onBoardingPage(image, title, subtitle, index, controller) {
    return Column(
      children: [
        Image(
            image: AssetImage(image),
            height: getProportionateScreenHeight(470),
            width: getProportionateScreenWidth(440),
            fit: BoxFit.cover),
        SizedBox(height: getProportionateScreenHeight(30)),
        AppText.medium(
          title,
          color: Colors.black,
          fontSize: getProportionateScreenWidth(15),
          fontWeight: FontWeight.w500,
        ),
        SizedBox(height: getProportionateScreenHeight(25)),
        AppText.medium(
          subtitle,
          color: Colors.black,
          fontSize: getProportionateScreenWidth(13),
          fontWeight: FontWeight.normal,
        ),
        SizedBox(height: getProportionateScreenHeight(50)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            onBoardingData.length,
            (index) => buildDot(index: index),
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(30)),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  index == 0
                      ? Navigator.pushNamed(context, LoginScreen.routeName)
                      : pageController!.jumpToPage(index - 1);
                },
                child: AppText.medium(
                  index == 0 ? "Skip" : "Back",
                  color: Colors.black,
                  fontSize: getProportionateScreenWidth(11),
                ),
              ),
              ClipOval(
                child: Material(
                  color: kPrimaryColor,
                  child: InkWell(
                    onTap: index == 3
                        ? () =>
                            Navigator.pushNamed(context, LoginScreen.routeName)
                        : () => pageController!.jumpToPage(index + 1),
                    child: const Padding(
                      padding: EdgeInsets.all(13),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
