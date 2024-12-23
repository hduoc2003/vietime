import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

class APIHelper {
  static final String baseURL = dotenv.env['SERVER_API_BASE_URL']!;
  static const String emailUsedError = "User already exists with the given email";

  static Future<Map<String, String>> refreshTokens(String refreshToken) async {
    final String apiUrl = '$baseURL/api/refresh';

    // Create a RefreshTokenRequest object
    final Map<String, dynamic> requestData = {'refresh_token': refreshToken};

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          // Add any additional headers if required
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        // Successful response, parse and use the RefreshTokenResponse
        // Adjust the parsing based on your actual response structure
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final String newRefreshToken = responseBody['refresh_token'];
        final String accessToken = responseBody['access_token'];

        // TODO: Implement handling of the successful response

        return {'newRefreshToken': newRefreshToken, 'accessToken': accessToken};
      } else if (response.statusCode == 401) {
        // Unauthorized, return 2 empty strings
        return {'newRefreshToken': '', 'accessToken': ''};
      } else {
        Logger.root.info('Error: ${response.statusCode}');
        Logger.root.info('Response: ${response.body}');

        // TODO: Implement handling of error response

        // Return an empty map to indicate failure
        return {'newRefreshToken': '', 'accessToken': ''};
      }
    } catch (e) {
      // Handle any exceptions that may occur during the HTTP request
      Logger.root.severe('Exception: $e');

      // TODO: Implement handling of exceptions

      // Return an empty map to indicate failure
      return {'newRefreshToken': '', 'accessToken': ''};
    }
  }

  static Future<Map<String, String>> submitLoginRequest(String email, String password) async {
    final String apiUrl = '$baseURL/api/login';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'email': email,
          'password': password,
        },
      );
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        final String accessToken = responseBody['access_token'];
        final String refreshToken = responseBody['refresh_token'];

        return {'accessToken': accessToken, 'refreshToken': refreshToken};
      } else if (response.statusCode == 401) {
        // Unauthorized, return an error message
        return {'error': 'Email hoặc mật khẩu không hợp lệ'};
      } else {
        Logger.root.info('Error: ${response.statusCode}');
        Logger.root.info('Response: ${response.body}');

        return {'error': 'Email hoặc mật khẩu không hợp lệ'};
      }
    } catch (e) {
      Logger.root.severe('Exception: $e');

      return {'error': 'Email hoặc mật khẩu không hợp lệ'};
    }
  }

  static Future<Map<String, String>> submitSignupRequest(String name, String email, String password) async {
    final String apiUrl = '$baseURL/api/signup';

    // Create a SignupRequest object
    final Map<String, dynamic> requestData = {
      'name': name,
      'email': email,
      'password': password,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: requestData,
      );

      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        final String accessToken = responseBody['access_token'];
        final String refreshToken = responseBody['refresh_token'];

        return {'accessToken': accessToken, 'refreshToken': refreshToken};
      } else if (response.statusCode == 409) {
        assert(responseBody['error'] == emailUsedError);
        return {'error': 'Email này đã được đăng ký từ trước'};
      } else if (response.statusCode == 400 || response.statusCode == 409 || response.statusCode == 500) {
        return {'error': "Lỗi xảy ra khi đăng ký tài khoản"};
      } else {
        Logger.root.info('Error: ${response.statusCode}');
        Logger.root.info('Response: ${response.body}');

        return {'error': "Lỗi xảy ra khi đăng ký tài khoản"};
      }
    } catch (e) {
      Logger.root.severe('Exception: $e');

      return {'error': "Lỗi xảy ra khi đăng ký tài khoản"};
    }
  }
}
