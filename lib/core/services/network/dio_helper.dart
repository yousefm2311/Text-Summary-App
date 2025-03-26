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
    var api_key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMjg2ZDBhMTctMmQ5MC00NTY0LWI5MmMtODRiYzY1N2FkMDQ4IiwidHlwZSI6ImFwaV90b2tlbiJ9.xgC8-2G4sXUTyO5xWjiYoGr6mz75e_3G3v95zYvlxNo",
  }) async {
    dio!.options.headers = {
      'Authorization': "Bearer $api_key",
      'Content-Type': 'application/json'
    };
    return dio!.post(url, queryParameters: query, data: data);
  }
}
