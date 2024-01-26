import 'package:esoptron_salon/controllers/service.dart';
import 'package:esoptron_salon/screens/addPaymentmethod/add_payment.dart';
import 'package:esoptron_salon/screens/categories/categories_page.dart';
import 'package:esoptron_salon/screens/editprofile/edit_profile.dart';
import 'package:esoptron_salon/screens/favorites/favorite_screen.dart';
import 'package:esoptron_salon/screens/forgot/forgot_scren.dart';
import 'package:esoptron_salon/screens/landing/landing_screen.dart';
import 'package:esoptron_salon/screens/login/login_screen.dart';
import 'package:esoptron_salon/screens/mobileMoneyPayment/mobile_money_payment.dart';
import 'package:esoptron_salon/screens/onboarding/onboarding.dart';
import 'package:esoptron_salon/screens/otp/otp_screen.dart';
import 'package:esoptron_salon/screens/pricemenu/pricemenu.dart';
import 'package:esoptron_salon/screens/scheduleService/schedule_service.dart';
import 'package:esoptron_salon/screens/serviceBookedDetails/serviceBookedDetails.dart';
import 'package:esoptron_salon/screens/serviceBooking/service_booking.dart';
import 'package:esoptron_salon/screens/serviceDetailsFromTracking/serviceDetailsFromTrack.dart';
import 'package:esoptron_salon/screens/serviceProvider/service_provider.dart';
import 'package:esoptron_salon/screens/serviceSpecification/service_specification.dart';
import 'package:esoptron_salon/screens/servicedetails/service_details.dart';
import 'package:esoptron_salon/screens/servicesFromSubCategories/servicesFromSubCategories.dart';
import 'package:esoptron_salon/screens/servicesbooked/services_booked.dart';
import 'package:esoptron_salon/screens/signup/signup_screen.dart';
import 'package:esoptron_salon/screens/splash/splash_screen.dart';
import 'package:esoptron_salon/screens/subcategories/searched_subcategory.dart';
import 'package:esoptron_salon/screens/subcategories/subcategories.dart';
import 'package:esoptron_salon/screens/termsAndConditions/termsAndConditionsScreen.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  OnBoarding.routeName: (context) => const OnBoarding(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  SignupScreen.routeName: (context) => const SignupScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  LandingScreen.routeName: (context) => const LandingScreen(),
  EditProfile.routeName: (context) => const EditProfile(),
  CategoriesScreen.routeName: (context) => const CategoriesScreen(),
  PriceMenu.routeName: (context) => PriceMenu(),
  ServicesBooked.routeName: (context) => const ServicesBooked(),
  FavoriteScreen.routeName: (context) => const FavoriteScreen(),
  ServiceDetails.routeName: (context) => const ServiceDetails(),
  ServiceProvider.routeName: (context) => const ServiceProvider(),
  ServiceBooking.routeName: (context) => const ServiceBooking(),
  ServiceSpecification.routeName: (context) => const ServiceSpecification(),
  ScheduleService.routeName: (context) => const ScheduleService(),
  AddPaymentMethod.routeName: (context) => const AddPaymentMethod(),
  SubCategories.routeName: (context) => const SubCategories(),
  ServicesList.routeName: (context) => const ServicesList(),
  MobileMoneyPaymentScreen.routeName: (context) =>
      const MobileMoneyPaymentScreen(),
  ServiceBookedDetails.routeName: (context) => const ServiceBookedDetails(),
  ServiceDetailsFromTracking.routeName: ((context) =>
      const ServiceDetailsFromTracking()),
  SearchedSubCategories.routeName: (context) => const SearchedSubCategories(),
  TermsAndConditions.routeName: (context) => const TermsAndConditions(),
};
