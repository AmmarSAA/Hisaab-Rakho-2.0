/*+------------------------------------------------------------------------------+*/
/*|                            © 2024 Syed Ammar Ahmed                           |*/
/*+------------------------------------------------------------------------------+*/
/*+------------------------------------------------------------------------------+*/
/*| File: user_services.dart                                                     |*/
/*| Path: lib/services/user_services.dart                                        |*/
/*| Author: Syed Ammar Ahmed                                                     |*/
/*| Content: User Services                                                       |*/
/*| Output: Implement User Services                                              |*/
/*| Description:                                                                 |*/
/*| Implement the UserService class with the following methods:                  |*/
/*| - verifyUser                                                                 |*/
/*| - addUser                                                                    |*/
/*| - getTransactionsForCurrentUser                                              |*/
/*| - getUserDetails                                                             |*/
/*+------------------------------------------------------------------------------+*/

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hisaab_rakho/utils/constants.dart';
import 'package:hisaab_rakho/utils/session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:hisaab_rakho/models/transactions.dart';
import 'package:hisaab_rakho/models/users.dart';
import 'package:hisaab_rakho/services/transaction_services.dart';
import 'package:hisaab_rakho/utils/shared_preferences.dart';

class UserService {
  static const String _baseUrl = '${Constants.DATABASE_URL}/users';

  // Verify user by checking credentials
  static Future<AppUser?> verifyUser(String email, String password) async {
    try {
      // Call API to fetch the user by email directly
      final response = await http
          .get(Uri.parse('$_baseUrl?email=${Uri.encodeComponent(email)}'));

      if (response.statusCode == 200) {
        final List<dynamic> users = json.decode(response.body);
        debugPrint('Fetched users with email $email: ${users.length}');

        if (users.isNotEmpty) {
          final userJson = users[0];
          if (userJson['password'] == password) {
            debugPrint('User found: ${userJson['email']}');
            return AppUser.fromJson(userJson);
          } else {
            debugPrint('Invalid password for email: $email');
          }
        } else {
          debugPrint('No user found with email: $email');
        }
      } else {
        debugPrint('Failed to fetch user: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error verifying user: $e');
    }
    return null;
  }

  // Add a new user
  static Future<Object> addUser(AppUser user) async {
    Object message = {"message": "Something went wrong", "success": false};
    try {
      // Check if the email already exists
      final emailCheckResponse = await http.get(
        Uri.parse('$_baseUrl?email=${user.email}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (emailCheckResponse.statusCode == 200 &&
          json.decode(emailCheckResponse.body).isNotEmpty) {
        // Email already exists
        debugPrint('Email already exists: ${user.email}');
        message = {"message": "Email already exists", "success": false};
      }

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      if (response.statusCode == 201) {
        message = {"message": "Sign up successful", "success": true};
      } else {
        debugPrint('Error: Status code ${response.statusCode}');
        message = {"message": "Something went wrong", "success": false};
      }
    } catch (e) {
      debugPrint('Error adding user: $e');
      message = {"message": "Something went wrong", "success": false};
    }

    return message;
  }

  // Get transactions for the current user
  static Future<List<Transactions>> getTransactionsForCurrentUser() async {
    final userID = await SessionManager().get("id");
    debugPrint("usrID: $userID");
    if (userID == null) return [];
    debugPrint('Fetching transactions for: $userID');
    debugPrint(
        'User Transactions: ${TransactionService.getTransactionsByUserID(userID)}');
    return TransactionService.getTransactionsByUserID(userID);
  }

  // Get user details by email
  static Future<AppUser?> getUserDetails(String email) async {
    try {
      // Ensure the email is properly encoded to avoid URL issues
      final response = await http
          .get(Uri.parse('$_baseUrl?email=${Uri.encodeComponent(email)}'));

      if (response.statusCode == 200) {
        final List<dynamic> userData = json.decode(response.body);

        if (userData.isNotEmpty) {
          final userJson = userData[0]; // Assuming the API returns a list
          AppUser user = AppUser.fromJson(userJson);

          // Store user data in shared preferences
          await SharedPreferences.storeUserInSession(user);

          return user;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching user details: $e');
      return null;
    }
  }
}
