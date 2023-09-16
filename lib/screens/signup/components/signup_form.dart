import 'dart:developer';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/controllers/authentication.dart';
import 'package:esoptron_salon/models/api_request.dart';
import 'package:esoptron_salon/models/api_response.dart';
import 'package:esoptron_salon/screens/login/components/no_account_text.dart';
import 'package:esoptron_salon/screens/login/login_screen.dart';
import 'package:esoptron_salon/screens/otp/otp_screen.dart';
import 'package:esoptron_salon/states/global_state.dart';
import 'package:esoptron_salon/utils/enums/global_state.dart';
import 'package:esoptron_salon/widgets/app_text.dart';
import 'package:esoptron_salon/widgets/default_button.dart';
import 'package:esoptron_salon/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});

  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String? password;
  bool selected = false;
  bool isObscure = true;
  String? confirm_password;
  bool remember = false;
  bool loading = false;
  final List<String?> errors = [];
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final restrationState = ref.watch(registrationNotifierProvider);
    ref.listen<AppState<ApiResponseModel>>(registrationNotifierProvider,
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
              MaterialPageRoute(builder: (_) => const LoginScreen()));
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
            hintText: "First Name",
            suffixWidget: const Icon(
              FontAwesomeIcons.user,
              size: 20, //Icon Size
              color: kPrimaryColor, //Color Of Icon
            ),
            controller: firstNameController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return "First Name cannot be empty";
              }
              return null;
            },
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          TextFieldWidget(
            hintText: "Last Name",
            suffixWidget: const Icon(
              FontAwesomeIcons.user,
              size: 20, //Icon Size
              color: kPrimaryColor, //Color Of Icon
            ),
            controller: lastNameController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return "Last Name cannot be empty";
              }
              return null;
            },
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          TextFieldWidget(
            controller: phoneNumberController,
            hintText: "Phone Number",
            suffixWidget: const Icon(
              FontAwesomeIcons.phone,
              size: 20, //Icon Size
              color: kPrimaryColor, //Color Of Icon
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) {
                return "Phone Number cannot be empty";
              }
              if (value!.length != 10) {
                return "Phone Number must be 10 characters";
              }
              return null;
            },
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          TextFieldWidget(
            controller: emailController,
            hintText: "Email Adress",
            suffixWidget: const Icon(
              FontAwesomeIcons.envelope,
              size: 20, //Icon Size
              color: kPrimaryColor, //Color Of Icon
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value!.isEmpty) {
                return "Email cannot be empty";
              }
              if (!emailValidatorRegExp.hasMatch(value)) {
                return 'Entered email is not a valid email address';
              }
              return null;
            },
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          TextFieldWidget(
            isObscure: isObscure,
            hintText: "Confirm Password",
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
            controller: confirmPasswordController,
            onSaved: (newValue) => confirm_password = newValue,
            validator: (value) {
              if (value == null) {
                return 'Password can not be empty';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters long';
              }
              if (value != password) {
                return 'Password does not match';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 12.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                    value: selected,
                    onChanged: (bool? value) {
                      setState(() {
                        selected = value!;
                      });
                    }),
                const AppText.small("I agree to the app terms  & conditions",
                    color: Colors.black)
              ],
            ),
          ),
          // FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(10)),
          loading
              ? const CircularProgressIndicator(
                  color: kPrimaryColor,
                )
              : DefaultButton(
                  text: "Continue",
                  press: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      APIRequestModel requestModel = APIRequestModel(
                        data: {
                          "first_name": firstNameController.text,
                          "last_name": lastNameController.text,
                          "phone": phoneNumberController.text,
                          "email": emailController.text,
                          "password": password,
                          "confirm_password": confirm_password
                        },
                      );
                      ref
                          .read(registrationNotifierProvider.notifier)
                          .register(requestModel, context);
                    }
                    //Navigator.pushNamed(context, OtpScreen.routeName);
                  },
                ),
          SizedBox(height: getProportionateScreenHeight(10)),
          const NoAccountText(
              text1: "Already have an account? ", text2: "Login"),
        ],
      ),
    );
  }

  TextFieldWidget buildPasswordFormField() {
    //TextEditingController passwordFormController = TextEditingController();
    return TextFieldWidget(
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
      isObscure: isObscure,
      onChanged: (value) => {password = value},
      validator: (value) {
        if (value == null) {
          return 'Password can not be empty';
        }
        if (value.length < 8) {
          return 'Password must be at least 8 characters long';
        }
        return null;
      },
    );
  }
}
