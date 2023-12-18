// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:dio/dio.dart';

class Dio_Helper {
  static Dio? dio;
  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.edenai.run/v2',
        receiveDataWhenStatusError: true,
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
  }
  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
    var api_key = "",
  }) async {
    dio!.options.headers = {
      'Authorization': "Bearer $api_key",
      'Content-Type': 'application/json'
    };
    return dio!.post(url, queryParameters: query, data: data);
  }
}
