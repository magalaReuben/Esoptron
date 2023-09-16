import 'package:dartz/dartz.dart';
import 'package:esoptron_salon/models/api_request.dart';
import 'package:esoptron_salon/models/api_response.dart';

abstract interface class RecoverPasswordRepository {
  Future<Either<String, ApiResponseModel>> getRecoveryCode(
      APIRequestModel apiRequestModel);
}
