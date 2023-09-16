import 'package:dartz/dartz.dart';
import 'package:esoptron_salon/models/api_request.dart';
import 'package:esoptron_salon/models/api_response.dart';

abstract interface class AuthenticationRepository {
  Future<Either<String, ApiResponseModel<String>>> registration(
      Map<String, dynamic>? apiRequest, context);

  Future<Either<String, ApiResponseModel>> login(
      APIRequestModel apiRequestModel);
}
