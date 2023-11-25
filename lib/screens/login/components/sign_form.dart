import 'dart:developer';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/controllers/authentication.dart';
import 'package:esoptron_salon/helper/form_errors.dart';
import 'package:esoptron_salon/helper/keyboard.dart';
import 'package:esoptron_salon/models/api_request.dart';
import 'package:esoptron_salon/models/api_response.dart';
import 'package:esoptron_salon/screens/forgot/forgot_scren.dart';
import 'package:esoptron_salon/screens/landing/landing_screen.dart';
import 'package:esoptron_salon/states/global_state.dart';
import 'package:esoptron_salon/utils/enums/global_state.dart';
import 'package:esoptron_salon/widgets/app_text.dart';
import 'package:esoptron_salon/widgets/default_button.dart';
import 'package:esoptron_salon/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignForm extends ConsumerStatefulWidget {
  @override
  ConsumerState<SignForm> createState() => _SignFormState();
}

class _SignFormState extends ConsumerState<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool isObscure = true;
  bool? remember = false;
  bool loading = false;
  TextEditingController phoneFormController = TextEditingController();
  TextEditingController passwordFormController = TextEditingController();
  final List<String?> errors = [];

  @override
  Widget build(BuildContext context) {
    ref.listen<AppState<ApiResponseModel>>(loginNotifierProvider,
        (previous, next) {
      log(next.toString());
      switch (next.status) {
        case Status.initial:
          break;
        case Status.loading:
          setState(() {
            loading = true;
          });
        case Status.loaded:
          setState(() {
            loading = false;
          });
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LandingScreen()));
        case Status.error:
          setState(() {
            loading = false;
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
              FontAwesomeIcons.phone,
              size: 20, //Icon Size
              color: kPrimaryColor, //Color Of Icon
            ),
            keyboardType: TextInputType.phone,
            //onSaved: (newValue) => email = newValue,
            validator: (value) {
              if (value!.isEmpty) {
                return "Phone Number can't be empty";
              }
              // return null;
            },
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          TextFieldWidget(
            hintText: "Password",
            suffixWidget: isObscure
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        isObscure = false;
                      });
                    },
                    child: const Icon(
                      FontAwesomeIcons.eye,
                      size: 20, //Icon Size
                      color: kPrimaryColor, //Color Of Icon
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        isObscure = true;
                      });
                    },
                    child: const Icon(
                      FontAwesomeIcons.eyeSlash,
                      size: 20, //Icon Size
                      color: kPrimaryColor, //Color Of Icon
                    ),
                  ),
            controller: passwordFormController,
            isObscure: isObscure,
            //onSaved: (newValue) => password = newValue,
            validator: (value) {
              if (value!.isEmpty) {
                return "Password can't be empty";
              } else if (value.length < 8) {
                return "Password is too short";
              }
            },
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: AppText.small(
                  "Forgot Password?",
                  color: kPrimaryColor,
                  fontSize: getProportionateScreenWidth(16),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          loading
              ? const CircularProgressIndicator(
                  color: kPrimaryColor,
                )
              : DefaultButton(
                  text: "Login",
                  press: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      setState(() {
                        loading = true;
                      });

                      KeyboardUtil.hideKeyboard(context);
                      APIRequestModel requestModel = APIRequestModel(
                        data: {
                          "phone": phoneFormController.text,
                          "password": passwordFormController.text,
                        },
                      );
                      ref
                          .read(loginNotifierProvider.notifier)
                          .login(requestModel);
                    }
                  },
                ),
        ],
      ),
    );
  }
}
