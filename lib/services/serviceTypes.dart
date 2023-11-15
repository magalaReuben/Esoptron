import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:esoptron_salon/models/api_request.dart';
import 'package:esoptron_salon/models/api_response.dart';
import 'package:esoptron_salon/repositories/serviceType.dart';
import 'package:esoptron_salon/utils/dio_helper.dart';
import 'package:esoptron_salon/utils/env.dart';

class ServiceTypesService implements ServiceTypeRepository {
  @override
  Future<Either<String, ApiResponseModel>> getServiceTypes(
      APIRequestModel requestModel) async {
    try {
      final request = requestModel.toMap();
      final data = await DioApi.dio.get(
        ENV.getServiceTypes,
        data: request,
      );
      log('*************************************');
      //log('Response getting documents ${data.data}');
      if (data.data['success'] == true) {
        print(data.data);
        return Right(ApiResponseModel.fromMap(data.data));
      }
      log(data.data['all-services']['data']);
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
