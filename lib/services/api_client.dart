import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hisaab_rakho/services/auth_session.dart';
import 'package:hisaab_rakho/utils/constants.dart';

class SessionExpired implements Exception {
  const SessionExpired();
  @override
  String toString() => 'Your session has expired. Please sign in again.';
}

class ApiClient {
  final http.Client httpClient;
  final AuthSession session;
  final String baseUrl;
  ApiClient(
      {http.Client? httpClient,
      AuthSession? session,
      this.baseUrl = Constants.DATABASE_URL})
      : httpClient = httpClient ?? http.Client(),
        session = session ?? AuthSession();

  Future<http.Response> request(String method, String path,
      {Map<String, dynamic>? body, bool authenticated = true}) async {
    final headers = <String, String>{'Accept': 'application/json'};
    if (body != null) headers['Content-Type'] = 'application/json';
    if (authenticated) {
      final token = await session.token();
      if (token == null) {
        await session.invalidate();
        throw const SessionExpired();
      }
      headers['Authorization'] = 'Bearer $token';
    }
    final request = http.Request(method, Uri.parse('$baseUrl$path'))
      ..headers.addAll(headers);
    if (body != null) request.body = jsonEncode(body);
    Future<http.Response> send() async =>
        http.Response.fromStream(await httpClient.send(request));
    final response = await send().timeout(const Duration(seconds: 20));
    if (authenticated && response.statusCode == 401) {
      await session.invalidate();
      throw const SessionExpired();
    }
    return response;
  }
}

class Api {
  static ApiClient client = ApiClient();
}
