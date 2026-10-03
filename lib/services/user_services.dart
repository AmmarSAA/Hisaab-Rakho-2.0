import 'dart:convert';
import 'package:hisaab_rakho/models/transactions.dart';
import 'package:hisaab_rakho/models/users.dart';
import 'package:hisaab_rakho/services/api_client.dart';
import 'package:hisaab_rakho/services/transaction_services.dart';
import 'package:hisaab_rakho/utils/session_manager.dart';
import 'package:hisaab_rakho/utils/shared_preferences.dart';

class UserService {
  static Future<AppUser> _saveAuthentication(String body) async {
    final data = jsonDecode(body) as Map<String, dynamic>;
    final user = AppUser.fromJson(data['user'] as Map<String, dynamic>);
    if (user.id == null || user.email == null) {
      throw const FormatException('Invalid user');
    }
    try {
      await Api.client.session
          .save(data['token'] as String, data['expires_at'] as int);
      await SharedPreferences.storeUserInSession(user);
      await SessionManager().set('session', true);
    } catch (_) {
      await Api.client.session.clear();
      await SessionManager().clear();
      rethrow;
    }
    return user;
  }

  static Future<AppUser?> verifyUser(String email, String password) async {
    try {
      final response = await Api.client.request('POST', '/auth/login',
          authenticated: false,
          body: {'email': email.trim(), 'password': password});
      if (response.statusCode == 200)
        return await _saveAuthentication(response.body);
    } catch (_) {/* Show the same login failure without logging credentials. */}
    return null;
  }

  static Future<Map<String, dynamic>> addUser(AppUser user) async {
    try {
      final response = await Api.client
          .request('POST', '/auth/register', authenticated: false, body: {
        'name': user.name,
        'email': user.email?.trim(),
        'password': user.password,
        'avatar': user.avatar,
        'currency_symbol': user.currencySymbol,
        'currency_name': user.currencyName
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        await _saveAuthentication(response.body);
        return {'success': true, 'message': 'Sign up successful'};
      }
      return {
        'success': false,
        'message': response.statusCode == 429
            ? 'Please wait before trying again.'
            : 'Unable to create account. Check your details and password (at least 12 characters).'
      };
    } catch (_) {
      return {
        'success': false,
        'message': 'Unable to connect. Please try again.'
      };
    }
  }

  static Future<List<Transactions>> getTransactionsForCurrentUser() async {
    final userID = await SessionManager().get('id');
    if (userID == null) return [];
    return TransactionService.getTransactionsByUserID(userID);
  }

  static Future<AppUser?> getUserDetails(String email) async {
    final response = await Api.client.request('GET', '/auth/me');
    if (response.statusCode != 200) throw Exception('Unable to load profile');
    final user =
        AppUser.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    await SharedPreferences.storeUserInSession(user);
    return user;
  }

  static Future<bool> restoreSession() async {
    if (await Api.client.session.token() == null) {
      await SessionManager().clear();
      return false;
    }
    try {
      await getUserDetails('');
      return true;
    } catch (_) {
      await Api.client.session.clear();
      await SessionManager().clear();
      return false;
    }
  }

  static Future<String> requestRecovery(String email) async {
    final response = await Api.client.request('POST', '/auth/recover',
        authenticated: false, body: {'email': email.trim()});
    if (response.statusCode == 429) {
      return 'Please wait before requesting another email.';
    }
    if (response.statusCode != 202) {
      throw Exception('Unable to request recovery. Please try again.');
    }
    return 'If this email has an account, a recovery link will arrive shortly. Check your spam folder too.';
  }
}
