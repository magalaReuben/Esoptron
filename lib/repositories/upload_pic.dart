import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:esoptron_salon/models/api_request.dart';
import 'package:esoptron_salon/models/api_response.dart';

abstract interface class UploadPicRepository {
  Future<Either<String, ApiResponseModel>> uploadPic(FormData formdata);
}
