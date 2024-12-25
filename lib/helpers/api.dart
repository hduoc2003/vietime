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

  static Future<Map<String, dynamic>> submitDeleteCardRequest(
      String deckID) async {
    final String apiUrl = '$baseURL/api/card/delete';
    final Map<String, dynamic> requestData = {'card_id': deckID};
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

  static Future<Map<String, dynamic>> submitReviewCardsRequest(String deckID,
      List<String> learntCardsID, List<bool> isCorrects, int totalXP) async {
    final String apiUrl = '$baseURL/api/card/review';
    final Map<String, dynamic> requestData = {
      'deck_id': deckID,
      'card_ids': learntCardsID,
      'is_correct': isCorrects,
      'total_xp': totalXP,
    };
    try {
      final response = await http.put(
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

  static Future<Map<String, dynamic>> submitFavoriteDeckRequest(
      String deckID, bool value) async {
    final String apiUrl = '$baseURL/api/deck/update';
    final Map<String, dynamic> requestData = {
      'deck_id': deckID,
      'is_favorite': value,
    };
    try {
      final response = await http.put(
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

  static Future<Map<String, dynamic>> submitViewDeckRequest(
      String deckID, int value) async {
    if (value <= 0) {
      return {'error': generalError};
    }
    final String apiUrl = '$baseURL/api/deck/view';
    final Map<String, dynamic> requestData = {
      'deck_id': deckID,
      'views': value,
    };
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
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

  static Future<Map<String, dynamic>> submitConfigureDeckRequest(
      String deckID, int maxNew, int maxReview) async {
    if (maxNew <= 0 || maxReview <= 0) {
      return {'error': generalError};
    }
    final String apiUrl = '$baseURL/api/deck/update';
    final Map<String, dynamic> requestData = {
      'deck_id': deckID,
      'max_new_cards': maxNew,
      'max_review_cards': maxReview
    };
    try {
      final response = await http.put(
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

  static Future<Map<String, dynamic>> submitCreateCardRequest(
      String deckID,
      String question,
      String correctAnswer,
      List<String> wrongAnswers,
      String questionImgURL,
      String questionImgLabel) async {
    final String apiUrl = '$baseURL/api/card/create';
    final Map<String, dynamic> requestData = {
      'deck_id': deckID,
      'question': question,
      'answer': correctAnswer,
      'wrong_answers': wrongAnswers,
      'question_img_label': questionImgLabel,
      'question_img_url': questionImgURL,
    };
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

  static Future<Map<String, dynamic>> submitEditCardRequest(
      String cardID,
      String question,
      String correctAnswer,
      List<String> wrongAnswers,
      String questionImgURL,
      String questionImgLabel) async {
    final String apiUrl = '$baseURL/api/card/update';
    final Map<String, dynamic> requestData = {
      'card_id': cardID,
      'question': question,
      'answer': correctAnswer,
      'wrong_answers': wrongAnswers,
      'question_img_label': questionImgLabel,
      'question_img_url': questionImgURL,
    };
    try {
      final response = await http.put(
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

  static Future<Map<String, dynamic>> submitGetFactRequest() async {
    final String apiUrl = '$baseURL/api/fact';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
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

  static Future<Map<String, dynamic>> submitUpdateUserRequest(
      String name) async {
    final String apiUrl = '$baseURL/api/user/update';
    final Map<String, dynamic> requestData = {
      'name': name,
    };
    try {
      final response = await http.put(
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

  static Future<Map<String, dynamic>> submitUpdatePasswordUserRequest(
      String oldPassword, String newPassword) async {
    final String apiUrl = '$baseURL/api/user/update';
    final Map<String, dynamic> requestData = {
      'old_password': oldPassword,
      'new_password': newPassword,
    };
    try {
      final response = await http.put(
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

  static Future<Map<String, dynamic>> submitCreateDeckRequest(
      String name, String description, String descriptionImgURL) async {
    final String apiUrl = '$baseURL/api/deck/create';
    final Map<String, dynamic> requestData = {
      'name': name,
      'description': description,
      'description_img_url': descriptionImgURL,
    };
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

  static Future<Map<String, dynamic>> submitEditDeckRequest(String deckID,
      String name, String description, String descriptionImgURL) async {
    final String apiUrl = '$baseURL/api/deck/update';
    final Map<String, dynamic> requestData = {
      'deck_id': deckID,
      'name': name,
      'description': description,
      'description_img_url': descriptionImgURL,
    };
    try {
      final response = await http.put(
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
