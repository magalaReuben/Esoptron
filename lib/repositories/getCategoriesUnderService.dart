import 'package:dartz/dartz.dart';
import 'package:esoptron_salon/models/api_request.dart';
import 'package:esoptron_salon/models/api_response.dart';

abstract interface class GetCategoriesUnderServiceRepository {
  Future<Either<String, ApiResponseModel>> getCategoriesUnderService(
      APIRequestModel apiRequestModel);
}
