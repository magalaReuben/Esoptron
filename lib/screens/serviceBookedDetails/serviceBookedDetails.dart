import 'package:flutter/material.dart';

class ServiceBookedDetails extends StatefulWidget {
  static String routeName = "/serviceBookedDetails";
  const ServiceBookedDetails({super.key});

  @override
  State<ServiceBookedDetails> createState() => _ServiceBookedDetailsState();
}

class _ServiceBookedDetailsState extends State<ServiceBookedDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Service Booked Details"),
      ),
      body: const Center(
        child: Text("Service Booked Details"),
      ),
    );
  }
}
