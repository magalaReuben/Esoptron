import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/controllers/upload_pic.dart';
import 'package:esoptron_salon/models/api_response.dart';
import 'package:esoptron_salon/providers/profileProviders.dart';
import 'package:esoptron_salon/states/global_state.dart';
import 'package:esoptron_salon/utils/enums/global_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Body extends ConsumerStatefulWidget {
  const Body({super.key});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends ConsumerState<Body> {
  bool forAndroid = false;

  Future<NetworkImage> getImage() async {
    final profileUrl = ref.watch(profilePicProvider);
    final response = await http
        .head(Uri.parse("http://admin.esoptronsalon.com/$profileUrl"));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return NetworkImage("http://admin.esoptronsalon.com/$profileUrl");
    } else {
      return const NetworkImage(
          "http://admin.esoptronsalon.com/storage/users/user.png");
    }
  }

  @override
  Widget build(BuildContext context) {
    final userName = ref.watch(userNameProvider);
    final phoneNumber = ref.watch(phoneNumberProvider);
    final email = ref.watch(emailProvider);
    ref.listen<AppState<ApiResponseModel>>(uploadPicNotifierProvider,
        (previous, next) {
      switch (next.status) {
        case Status.initial:
          break;
        case Status.loading:
          break;
        case Status.loaded:
          log("loaded");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(next.data!.message.toString()),
            backgroundColor: kPrimaryColor,
            padding: const EdgeInsets.all(25),
          ));
        case Status.error:
          log("error");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(next.errorMessage),
            backgroundColor: kPrimaryColor,
            padding: const EdgeInsets.all(25),
          ));
      }
    });
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(children: [
                FutureBuilder<NetworkImage>(
                  future: getImage(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return CircleAvatar(
                        radius: 30,
                        backgroundImage: snapshot.data,
                      );
                    } else {
                      // You can return a placeholder or loading indicator while the image is loading
                      return const CircularProgressIndicator();
                    }
                  },
                ),
                SizedBox(
                  height: getProportionateScreenHeight(13),
                ),
                GestureDetector(
                  onTap: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      allowMultiple: true,
                      type: FileType.custom,
                      allowedExtensions: ['jpg', 'png'],
                    );
                    if (result != null) {
                      String fileName = result!.files.first.name;
                      // FormData formData = FormData.fromMap({
                      //   "file": await MultipartFile.fromFile(
                      //     result.files.first.path!,
                      //     filename: fileName,
                      //   ),
                      // });
                      final file = await MultipartFile.fromFile(
                        result.files.first.path!,
                        filename: fileName,
                      );
                      final body = FormData.fromMap({"avatar": file});
                      ref
                          .read(uploadPicNotifierProvider.notifier)
                          .uploadPic(body);
                    } else {
                      // User canceled the picker
                    }
                  },
                  child: Text("Edit Picture",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: getProportionateScreenWidth(15),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'krona')),
                ),
              ])
            ],
          ),
          //SizedBox(
//            height: getProportionateScreenHeight(5),
          //         ),
          inputForm("Name", false, userName!),
          //SizedBox(
//            height: getProportionateScreenHeight(5),
          //         ),
          inputForm("Phone Number", false, phoneNumber!),
          //SizedBox(
//            height: getProportionateScreenHeight(5),
          //         ),
          inputForm("Adress", false),
          //SizedBox(
//            height: getProportionateScreenHeight(5),
          //         ),
          inputForm("Email Adress", false, email!),
          //SizedBox(
//            height: getProportionateScreenHeight(5),
          //         ),
          //sinputForm("Gender", false),
          //SizedBox(
//            height: getProportionateScreenHeight(5),
          //         ),
//           inputForm("Notification", true),
//           //SizedBox(
// //            height: getProportionateScreenHeight(5),
//           //         ),
//           inputForm("Service Tracking", true),
        ]),
      ),
    );
  }

  Padding inputForm(String label, bool toggle, [String helperText = '']) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        initialValue: helperText,
        decoration: InputDecoration(
            hintText: helperText,
            suffix: toggle
                ? Switch(
                    // thumb color (round icon)
                    activeColor: Colors.white,
                    activeTrackColor: kPrimaryColor,
                    inactiveThumbColor: kPrimaryColor,
                    inactiveTrackColor: Colors.grey.shade400,
                    splashRadius: 50.0,
                    // boolean variable value
                    value: forAndroid,
                    // changes the state of the switch
                    onChanged: (value) => setState(() => forAndroid = value),
                  )
                : null,
            label: Text(label),
            labelStyle: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
