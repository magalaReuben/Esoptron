import 'dart:developer';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/controllers/authentication.dart';
import 'package:esoptron_salon/controllers/recoverPassword.dart';
import 'package:esoptron_salon/controllers/sendOtp.dart';
import 'package:esoptron_salon/helper/form_errors.dart';
import 'package:esoptron_salon/models/api_request.dart';
import 'package:esoptron_salon/models/api_response.dart';
import 'package:esoptron_salon/screens/login/components/no_account_text.dart';
import 'package:esoptron_salon/screens/otp/otp_screen.dart';
import 'package:esoptron_salon/states/global_state.dart';
import 'package:esoptron_salon/utils/enums/global_state.dart';
import 'package:esoptron_salon/widgets/default_button.dart';
import 'package:esoptron_salon/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Body extends ConsumerStatefulWidget {
  const Body({super.key});

  @override
  ConsumerState<Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<Body> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.02),
              Image(
                  image: const AssetImage(
                      "assets/authentication/widgets/forgot.jpg"),
                  height: getProportionateScreenHeight(250),
                  width: getProportionateScreenWidth(250),
                  fit: BoxFit.cover),
              Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(23),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Enter your email in the field for your password recovery",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              ForgotPassForm(ref: ref),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPassForm extends ConsumerStatefulWidget {
  final WidgetRef ref;
  const ForgotPassForm({super.key, required this.ref});

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends ConsumerState<ForgotPassForm> {
  bool isLoading = false;
  TextEditingController phoneFormController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String? email;

  @override
  Widget build(BuildContext context) {
    // still needs to be implemented
    ref.listen<AppState<ApiResponseModel>>(otpProvider, (previous, next) {
      log(next.toString());
      switch (next.status) {
        case Status.initial:
          break;
        case Status.loading:
          setState(() {
            isLoading = true;
          });
        case Status.loaded:
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(next.data!.message),
            backgroundColor: kPrimaryColor,
            padding: const EdgeInsets.all(25),
          ));
          Navigator.pushNamed(context, OtpScreen.routeName);
        case Status.error:
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(next.errorMessage),
            backgroundColor: kPrimaryColor,
            padding: const EdgeInsets.all(25),
          ));
      }
    });

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFieldWidget(
            controller: phoneFormController,
            hintText: "Phone Number",
            suffixWidget: const Icon(
              FontAwesomeIcons.envelope,
              size: 20, //Icon Size
              color: kPrimaryColor, //Color Of Icon
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) {
                return "Phone number can't be empty";
              }
              if (value.length != 10) {
                return "Phone number is supposed to be 10 digits";
              }
              return null;
            },
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          isLoading
              ? const CircularProgressIndicator()
              : DefaultButton(
                  text: "Continue",
                  press: () async {
                    if (_formKey.currentState!.validate()) {
                      APIRequestModel requestModel = APIRequestModel(
                        data: {
                          "phone_number": phoneFormController.text,
                        },
                      );
                      widget.ref
                          .read(otpProvider.notifier)
                          .getOtpCode(requestModel);
                    }
                  },
                ),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
        ],
      ),
    );
  }
}
