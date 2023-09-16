import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:esoptron_salon/models/api_response.dart';
import 'package:esoptron_salon/repositories/upload_pic.dart';
import 'package:esoptron_salon/utils/dio_helper.dart';
import 'package:esoptron_salon/utils/env.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadPicService implements UploadPicRepository {
  @override
  Future<Either<String, ApiResponseModel>> uploadPic(FormData formdata) async {
    try {
      final request = formdata;
      log(request.toString());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authorizationToken = prefs.getString("auth_token");
      final data = await DioApi.dio.post(ENV.uploadPic,
          data: formdata,
          options: Options(
              headers: {'authorization': 'Bearer $authorizationToken'}));
      log('*************************************');
      log('Response getting documents ${data}');
      log(data.toString());
      if (data.data['success'] == true) {
        //log(ApiResponseModel.fromMap(data.data).toString());
        return Right(ApiResponseModel(
            success: data.data['success'],
            data: {},
            message: data.data['message']));
      }
      return Left(data.data['message'] ?? 'Something Happend contact Support');
    } on DioException catch (e) {
      log(e.toString());
      return Left(e.message ?? e.response?.data['message']);
    } catch (e, stackTrace) {
      return Left(e.toString());
    }
  }
}
