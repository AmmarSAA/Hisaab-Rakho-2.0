import 'package:flutter/material.dart';
import 'package:hisaab_rakho/services/api_client.dart';
import 'package:hisaab_rakho/services/auth_navigation.dart';

class SignOut {
  Future<void> signOut(BuildContext context) async {
    try {
      await Api.client.request('POST', '/auth/logout');
    } catch (_) {
      // Local credentials are removed even when the server is unavailable.
    } finally {
      await Api.client.session.clear();
      await AuthNavigation.returnToSignIn();
    }
  }
}
