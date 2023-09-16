import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:esoptron_salon/models/api_request.dart';
import 'package:esoptron_salon/models/api_response.dart';
import 'package:esoptron_salon/repositories/category.dart';
import 'package:esoptron_salon/utils/dio_helper.dart';
import 'package:esoptron_salon/utils/env.dart';

class CategoryService implements CategoryRepository {
  @override
  Future<Either<String, ApiResponseModel>> getCategories(
      APIRequestModel requestModel) async {
    try {
      final request = requestModel.toMap();
      final data = await DioApi.dio.get(
        ENV.getAllCategories,
        data: request,
      );
      log('*************************************');
      log('Response getting documents ${data.data}');
      if (data.data['success'] == true) {
        return Right(ApiResponseModel.fromMap(data.data));
      }
      return Left(data.data['message'] ?? 'Something Happend contact Support');
    } on DioException catch (e) {
      print(e.stackTrace);

      log(e.message ?? e.response?.data['message']);
      return Left(e.message ?? e.response?.data['message']);
    } catch (e, stackTrace) {
      print(stackTrace);
      log(e.toString());
      return Left(e.toString());
    }
  }
}
