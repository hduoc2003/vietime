import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import '../services/api_handler.dart';

class APIHelper {
  static final String baseURL = dotenv.env['SERVER_API_BASE_URL']!;
  static const String emailUsedError =
      "User already exists with the given email";
  static const String needLogInAgain = "Need log in again";
  static const String logInError = 'Email hoặc mật khẩu không hợp lệ';
  static const String generalError = 'Lỗi đã xảy ra';

  static Future<Map<String, dynamic>> getAllDataWithRefreshToken(
      String refreshToken) async {
    final String apiUrl = '$baseURL/api/get-all';

    // Create a RefreshTokenRequest object
    final Map<String, dynamic> requestData = {'refresh_token': refreshToken};

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        return responseBody;
      } else if (response.statusCode == 401) {
        return {'error': needLogInAgain};
      } else {
        return {'error': needLogInAgain};
      }
    } catch (e) {
      return {'error': needLogInAgain};
    }
  }

  static Future<Map<String, dynamic>> submitLoginRequest(
      String email, String password) async {
    final String apiUrl = '$baseURL/api/login-get-all';

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
        return responseBody;
      } else if (response.statusCode == 401) {
        return {'error': logInError};
      } else {
        return {'error': logInError};
      }
    } catch (e) {
      return {'error': logInError};
    }
  }

  static Future<Map<String, dynamic>> submitSignupRequest(
      String name, String email, String password) async {
    final String apiUrl = '$baseURL/api/signup-get-all';

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
        return responseBody;
      } else if (response.statusCode == 409) {
        assert(responseBody['error'] == emailUsedError);
        return {'error': 'Email này đã được đăng ký từ trước'};
      } else if (response.statusCode == 400 ||
          response.statusCode == 409 ||
          response.statusCode == 500) {
        return {'error': "Lỗi xảy ra khi đăng ký tài khoản"};
      } else {
        return {'error': "Lỗi xảy ra khi đăng ký tài khoản"};
      }
    } catch (e) {
      return {'error': "Lỗi xảy ra khi đăng ký tài khoản"};
    }
  }

  static Future<Map<String, dynamic>> submitCopyDeckRequest(
      String deckID) async {
    final String apiUrl = '$baseURL/api/deck/copy';
    final Map<String, dynamic> requestData = {'deck_id': deckID};
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer ${GetIt.I<APIHanlder>().accessToken}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        return responseBody;
      } else if (response.statusCode == 401) {
        return {'error': generalError};
      } else {
        return {'error': generalError};
      }
    } catch (e) {
      return {'error': generalError};
    }
  }

  static Future<Map<String, dynamic>> submitDeleteDeckRequest(
      String deckID) async {
    final String apiUrl = '$baseURL/api/deck/delete';
    final Map<String, dynamic> requestData = {'deck_id': deckID};
    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer ${GetIt.I<APIHanlder>().accessToken}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        return responseBody;
      } else if (response.statusCode == 401) {
        return {'error': generalError};
      } else {
        return {'error': generalError};
      }
    } catch (e) {
      return {'error': generalError};
    }
  }
}
