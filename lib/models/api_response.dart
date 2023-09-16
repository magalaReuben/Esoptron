import 'dart:convert';
import 'dart:developer';

class ApiResponseModel<T> {
  final bool success;
  final Map<String, dynamic> data;
  final String message;

  ApiResponseModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory ApiResponseModel.fromJson(String str) =>
      ApiResponseModel.fromMap(json.decode(str));

  factory ApiResponseModel.fromMap(Map<String, dynamic> json) {
    log(json.toString());
    return ApiResponseModel(
      success: json["success"],
      data: json["data"],
      message: json["message"],
    );
  }
}
