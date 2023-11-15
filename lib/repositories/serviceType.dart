import 'package:dartz/dartz.dart';
import 'package:esoptron_salon/models/api_request.dart';
import 'package:esoptron_salon/models/api_response.dart';

abstract interface class ServiceTypeRepository {
  Future<Either<String, ApiResponseModel>> getServiceTypes(
      APIRequestModel apiRequestModel);
}
