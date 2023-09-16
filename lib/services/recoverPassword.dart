import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:esoptron_salon/models/api_request.dart';
import 'package:esoptron_salon/models/api_response.dart';
import 'package:esoptron_salon/repositories/recoverPassword.dart';
import 'package:esoptron_salon/utils/dio_helper.dart';
import 'package:esoptron_salon/utils/env.dart';

class RecoverPasswordService implements RecoverPasswordRepository {
  @override
  Future<Either<String, ApiResponseModel>> getRecoveryCode(
      APIRequestModel requestModel) async {
    try {
      final request = requestModel.toMap();
      log(requestModel.toString());
      final data = await DioApi.dio.post(
        ENV.recoverPassword(requestModel.data),
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
