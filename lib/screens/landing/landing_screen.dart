import 'package:awesome_icons/awesome_icons.dart';
import 'package:esoptron_salon/screens/home/home_screen.dart';
import 'package:esoptron_salon/screens/profile/profile_screen.dart';
import 'package:esoptron_salon/screens/services/service_screen.dart';
import 'package:esoptron_salon/screens/track/track.dart';
import 'package:esoptron_salon/screens/wallet/wallet_screen.dart';
import 'package:esoptron_salon/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  static String routeName = '/landing';
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int currentTab = 0; // to keep track of active tab index
  final List<Widget> screens = [
    const HomeScreen(),
    const ServiceScreen(),
    // const WalletScreen(),
    const ProfileScreen()
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const HomeScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      bottomNavigationBar: BottomNavWidget(
        currentIndex: currentTab,
        onChange: (index) async {
          setState(() {
            currentTab = index;
            switch (index) {
              case 0:
                currentScreen = const HomeScreen();
                break;
              case 1:
                currentScreen = const ServiceScreen();
                break;
              // case 2:
              //   currentScreen = const WalletScreen();
              //   break;
              case 2:
                currentScreen = const TrackScreen();
                break;
              case 3:
                currentScreen = const ProfileScreen();
                break;
            }
          });
        },
      ),
    );
  }
}
