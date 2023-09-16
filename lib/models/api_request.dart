// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class APIRequestModel {
  final String? token;
  final Map<String, dynamic>? data;
  APIRequestModel({
    this.token,
    this.data,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'token': token,
      'data': data,
    }..removeWhere((key, value) => value == null);
  }

  String toJson() => json.encode(toMap());
}
