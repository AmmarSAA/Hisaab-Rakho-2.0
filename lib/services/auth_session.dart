import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class TokenStore {
  Future<String?> read();
  Future<void> write(String value);
  Future<void> clear();
}

class SecureTokenStore implements TokenStore {
  final FlutterSecureStorage storage;
  SecureTokenStore({this.storage = const FlutterSecureStorage()});
  @override
  Future<String?> read() => storage.read(key: 'hisaab_auth');
  @override
  Future<void> write(String value) =>
      storage.write(key: 'hisaab_auth', value: value);
  @override
  Future<void> clear() => storage.delete(key: 'hisaab_auth');
}

// Browser bearer tokens stay in memory; refreshing requires signing in again.
class MemoryTokenStore implements TokenStore {
  String? value;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String value) async {
    this.value = value;
  }

  @override
  Future<void> clear() async {
    value = null;
  }
}

class AuthSession {
  final TokenStore store;
  final DateTime Function() now;
  Future<void> Function()? onExpired;
  Timer? _timer;
  AuthSession({TokenStore? store, DateTime Function()? now})
      : store = store ?? (kIsWeb ? MemoryTokenStore() : SecureTokenStore()),
        now = now ?? DateTime.now;

  Future<void> save(String token, int expiresAt) async {
    if (token.isEmpty || expiresAt <= now().millisecondsSinceEpoch) {
      throw const FormatException('Invalid authentication session');
    }
    await store.write(jsonEncode({'token': token, 'expires_at': expiresAt}));
    _schedule(expiresAt);
  }

  void _schedule(int expiresAt) {
    _timer?.cancel();
    _timer = Timer(
        Duration(milliseconds: expiresAt - now().millisecondsSinceEpoch),
        invalidate);
  }

  Future<String?> token() async {
    final value = await store.read();
    if (value == null) return null;
    try {
      final data = jsonDecode(value) as Map<String, dynamic>;
      final expiry = data['expires_at'] as int;
      final token = data['token'] as String;
      if (expiry <= now().millisecondsSinceEpoch || token.isEmpty) {
        await invalidate();
        return null;
      }
      _schedule(expiry);
      return token;
    } on FormatException {
      await invalidate();
      return null;
    } on TypeError {
      await invalidate();
      return null;
    }
  }

  Future<void> clear() async {
    _timer?.cancel();
    _timer = null;
    await store.clear();
  }

  Future<void> invalidate() async {
    await clear();
    await onExpired?.call();
  }
}
