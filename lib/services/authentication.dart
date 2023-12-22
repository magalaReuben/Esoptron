import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/models/api_request.dart';
import 'package:esoptron_salon/models/api_response.dart';
import 'package:esoptron_salon/repositories/authentication.dart';
import 'package:esoptron_salon/utils/dio_helper.dart';
import 'package:esoptron_salon/utils/env.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService implements AuthenticationRepository {
  @override
  Future<Either<String, ApiResponseModel<String>>> registration(
      Map<String, dynamic>? request, context) async {
    try {
      log(request.toString());
      final data = await DioApi.dio.post(
        ENV.registerUser,
        data: request,
      );
      log('*************************************');
      log('Response login user ${json.encode(data.data)}');
      log('Response login user ${data.data}');
      if (data.data['success'] == true) {
        return Right(ApiResponseModel.fromMap(data.data));
      }
      return Left(data.data['message'] ?? 'Something Happend contact Support');
    } on DioException catch (e) {
      log(e.response?.data['message']);
      return Left(
          e.response?.data['message'] ?? e.message ?? 'An error occurred');
    } catch (e) {
      log(e.toString());
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, ApiResponseModel>> login(
      APIRequestModel requestModel) async {
    try {
      log(json.encode(requestModel.toMap()));
      // return const Left('');
      final data = await DioApi.dio.post(
        ENV.loginUser,
        data: requestModel.data,
      );
      log('*************************************');
      print('Response login user ${json.encode(data.data)}');
      log('Response login user ${json.encode(data.data)}');
      if (data.data['success'] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("isLoggedin", true);
        prefs.setInt("userId", data.data['data']['id']);
        prefs.setString("firstName", data.data['data']['first_name']);
        prefs.setString("lastName", data.data['data']['last_name']);
        prefs.setString("userEmail", data.data['data']['email']);
        prefs.setString("auth_token", data.data['data']['token']);
        prefs.setString("type", data.data['data']['type']);
        prefs.setString("phone", data.data['data']['phone']);
        prefs.setString("avatar", data.data['data']['avatar']);
        return Right(ApiResponseModel.fromMap(data.data));
      }
      return Left(data.data['message'] ?? 'Something Happend contact Support');
    } on DioException catch (e) {
      log(e.response?.data['message']);
      return Left(
          e.response?.data['message'] ?? e.message ?? 'An error occurred');
    } catch (e, stackTrace) {
      print(stackTrace);
      log(e.toString());
      return Left(e.toString());
    }
  }

  Future googleSignIn(context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: kPrimaryColor,
      ));
    }
  }
}
