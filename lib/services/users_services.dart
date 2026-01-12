import 'dart:io';

import 'package:food_app/models/users.dart';
import 'package:food_app/services/main_url.dart';
import 'package:http/http.dart' as http;

class UsersServices {
  final MainUrl url = MainUrl();

  UsersServices._internal();
  static final UsersServices _instance = UsersServices._internal();
  factory UsersServices() => _instance;

  Future<List<User>> fetchUser() async {
    final String baseUrl = '${url.baseUrll}/users';
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final ResponseUser user = ResponseUser.fromJson(response.body);
        return user.users;
      } else {
        throw HttpException('Failed to format user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Invalid loading User: $e');
    }
  }
}
