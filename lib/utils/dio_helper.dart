import 'package:dio/dio.dart';

import 'env.dart';

enum AppDioError {
  cancel,
  connectionTimeout,
  other,
  receiveTimeout,
  notAuthorized,
  sendTimeout,
  notFound,
  internalServerError,
  badRequest,
  noInternet
}

class DioExceptions {
  static AppDioError fromDioError(Object dioError) {
    AppDioError appDioError = AppDioError.noInternet;
    if (dioError is DioError) {
      switch (dioError.type) {
        case DioErrorType.cancel:
          appDioError = AppDioError.cancel;
          break;
        case DioErrorType.connectionTimeout:
          appDioError = AppDioError.connectionTimeout;
          appDioError = AppDioError.noInternet;
          break;
        case DioErrorType.receiveTimeout:
          appDioError = AppDioError.receiveTimeout;
          break;
        case DioErrorType.sendTimeout:
          appDioError = AppDioError.sendTimeout;
          break;
        case DioErrorType.badCertificate:
          appDioError = AppDioError.badRequest;
          break;
        case DioErrorType.badResponse:
          switch (dioError.response!.statusCode!) {
            case 400:
              appDioError = AppDioError.badRequest;
              break;
            case 401:
              appDioError = AppDioError.notAuthorized;
              break;
            case 404:
              appDioError = AppDioError.notFound;
              break;
            case 500:
              appDioError = AppDioError.internalServerError;
              break;
            default:
              appDioError = AppDioError.other;
          }
          break;
        case DioErrorType.connectionError:
          appDioError = AppDioError.connectionTimeout;
          break;
        case DioErrorType.unknown:
          appDioError = AppDioError.other;
          break;
      }
    }
    return appDioError;
  }
}

class DioApi {
  static Dio dio = Dio(BaseOptions(
    baseUrl: ENV.baseUrl,
    contentType: 'application/json',
    headers: {
      'Accept': 'application/json',
    },
  ));
}
