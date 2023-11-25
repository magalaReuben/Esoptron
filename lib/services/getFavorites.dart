import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:esoptron_salon/models/api_request.dart';
import 'package:esoptron_salon/models/api_response.dart';
import 'package:esoptron_salon/repositories/favorites.dart';
import 'package:esoptron_salon/repositories/getCategoriesUnderService.dart';
import 'package:esoptron_salon/repositories/recoverPassword.dart';
import 'package:esoptron_salon/utils/dio_helper.dart';
import 'package:esoptron_salon/utils/env.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService implements FavoritesRepository {
  @override
  Future<Either<String, ApiResponseModel>> getFavorites(
      APIRequestModel requestModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authorizationToken = prefs.getString("auth_token");
    try {
      final request = requestModel.toMap();
      final data = await DioApi.dio.get(ENV.getFavorites,
          data: request,
          options: Options(
              headers: {'authorization': 'Bearer $authorizationToken'}));
      log('*************************************');
      log('Response getting documents ${data.data}');
      print(data.data);
      if (data.data['success'] == true) {
        return Right(ApiResponseModel.fromMap(data.data));
      }
      print(data.data);
      return Left(data.data['message'] ?? 'Something Happend contact Support');
    } on DioException catch (e) {
      print(e.stackTrace);
      log(e.response!.data.toString());
      log(e.message ?? e.response?.data['message']);
      return Left(e.message ?? e.response?.data['message']);
    } catch (e, stackTrace) {
      print(stackTrace);
      log(e.toString());
      return Left(e.toString());
    }
  }
}
