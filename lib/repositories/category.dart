import 'package:dartz/dartz.dart';
import 'package:esoptron_salon/models/api_request.dart';
import 'package:esoptron_salon/models/api_response.dart';

abstract interface class CategoryRepository {
  Future<Either<String, ApiResponseModel>> getCategories(
      APIRequestModel apiRequestModel);
}
