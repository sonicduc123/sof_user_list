import 'dart:io';

import 'package:sof_user_list/network/endpoint.dart';
import 'package:http/http.dart' as client;
import 'package:sof_user_list/network/result.dart';

class ClientNetwork {
  static Result<client.Response> handleResponse(
    client.Response response,
  ) {
    if (response.statusCode == 200) {
      return Result.ok(response);
    } else if (response.statusCode == 400) {
      return Result.error(HttpException('Bad request'));
    } else if (response.statusCode == 401) {
      return Result.error(HttpException('Unauthorized'));
    } else if (response.statusCode == 403) {
      return Result.error(HttpException('Forbidden'));
    } else if (response.statusCode == 404) {
      return Result.error(HttpException('User not found'));
    } else if (response.statusCode == 500) {
      return Result.error(HttpException('Server error'));
    } else {
      return Result.error(HttpException('Invalid response'));
    }
  }

 static Future<Result<client.Response>> get({required String endpoint, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await client.get(
        Uri.https(
          Endpoint.baseUrl,
          endpoint,
          queryParameters,
        ),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptCharsetHeader: 'utf-8',
          HttpHeaders.acceptLanguageHeader: 'en',
        },
      );

      return handleResponse(response);
    } on Exception catch (exception) {
      return Result.error(exception);
    }
  }
}