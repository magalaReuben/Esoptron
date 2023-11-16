import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:esoptron_salon/models/api_response.dart';
import 'package:esoptron_salon/repositories/sendOtp.dart';
import 'package:esoptron_salon/utils/dio_helper.dart';
import 'package:esoptron_salon/utils/env.dart';

import '../models/api_request.dart';

class OtpService implements OtpRepository {
  @override
  Future<Either<String, ApiResponseModel>> getOtp(
      APIRequestModel requestModel) async {
    try {
      final request = requestModel.toMap();
      log(request["data"].toString());
      final data = await DioApi.dio.post(
        ENV.getOtp,
        data: requestModel.data,
      );
      log('*************************************');
      log('Response getting documents ${data.data['success']}');
      if (data.data['success'] == true) {
        // since the response is not standard we need to convert it to our standard
        return Right(ApiResponseModel.fromMap({
          "success": data.data['success'],
          "message": data.data['message'],
          "data": {"message": data.data['message']}
        }));
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
