import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

class APIHelper {
  static final String baseURL = dotenv.env['SERVER_API_BASE_URL']!;

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
}
