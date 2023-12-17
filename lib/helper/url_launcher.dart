import 'package:url_launcher/url_launcher.dart';

launchURL(String urlPath) async {
  final Uri url = Uri.parse(urlPath);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    print("error");
    throw 'Could not launch $url';
  }
}
