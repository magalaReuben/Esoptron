import 'package:esoptron_salon/constants/size_config.dart';
import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  static String routeName = "/termsAndConditions";
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text("Terms and Conditions"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle('1. Acceptance of Terms'),
              const Text(
                  'By using our mobile app for salon services, you agree to comply with and be bound by these terms and conditions. If you do not agree, please do not use the app.'),
              SectionTitle('2. Service Description'),
              const Text(
                  'Our mobile app facilitates the booking of professional hairstyling services to be delivered at your home. Services include plaiting, styling, waxing, pedicure and manicure and related services. The app serves as a platform to connect users with licensed and vetted Beauticians.'),
              SectionTitle('3. User Eligibility'),
              const Text(
                  'Users must be of legal age in their jurisdiction to use our app. By using the app, you confirm that you meet this eligibility requirement and you are 18 years and above.'),
              SectionTitle('4. Booking and Payments'),
              const Text(
                  'Users can book appointments through the app. Payments are processed securely within the app. Cancellations and refunds are subject to our cancellation policy outlined in a separate document.'),
              SectionTitle('5. Professional Service Providers'),
              const Text(
                  'Beauticians using our platform are independent professionals. We do not employ hairstylists directly. We  are responsible for verifying the credentials and licences of the Beauticians booked through the app.'),
              SectionTitle('6. User Conduct'),
              const Text(
                  'Users agree to treat Beauticians with respect and courtesy. Any inappropriate behaviour, harassment, or violation of these terms may result in the termination of services.'),
              SectionTitle('7. Liability and Disclaimer'),
              const Text(
                  'We do not guarantee the quality of hairstyling services provided by independent professionals. Users agree that the app is used at their own risk, and we are not liable for any damages, losses, or injuries resulting from the services provided.'),
              SectionTitle('8. Privacy and Data Security'),
              const Text(
                  'User data, including personal information and payment details, will be handled in accordance with our Privacy Policy. Users are encouraged to review the Privacy Policy for more information on data handling practices.'),
              SectionTitle('9. Intellectual Property'),
              const Text(
                  'All content and materials on the app, including logos, images, and text, are the intellectual property of the app owner. Users are not authorised to use, reproduce, or distribute any content without prior written consent.'),
              SectionTitle('10. Termination of Services'),
              const Text(
                  'We reserve the right to terminate services and access to the app for users who violate these terms or engage in inappropriate behaviour.'),
              SectionTitle('11. Changes to Terms'),
              const Text(
                  'We reserve the right to update these terms and conditions at any time. Users will be notified of any changes, and continued use of the app constitutes acceptance of the modified terms.'),
              SectionTitle('12. Governing Law'),
              const Text(
                  'These terms and conditions are governed by the laws of Uganda. Any disputes arising out of or related to these terms will be resolved through arbitration in accordance with the rules of the [Arbitration Organization].'),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'By using our mobile app, you acknowledge that you have read, understood, and agree to abide by these terms and conditions. If you have any questions, please contact our customer support team before using the app.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ));
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
    );
  }
}
