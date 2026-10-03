import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart' as prefs;
import 'package:hisaab_rakho/services/api_client.dart';
import 'package:hisaab_rakho/services/auth_session.dart';
import 'package:hisaab_rakho/services/user_services.dart';
import 'package:hisaab_rakho/services/transaction_services.dart';
import 'package:hisaab_rakho/models/transactions.dart';
import 'package:hisaab_rakho/utils/session_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AuthSession session;
  setUp(() {
    prefs.SharedPreferences.setMockInitialValues({});
    session = AuthSession(store: MemoryTokenStore());
  });
  tearDown(() async {
    await session.clear();
    await SessionManager().clear();
  });

  test('expired persisted token is erased and not sent to API', () async {
    final store = MemoryTokenStore();
    await store.write(jsonEncode({'token': 'expired', 'expires_at': 1}));
    final expired = AuthSession(store: store);
    var invalidations = 0;
    expired.onExpired = () async {
      invalidations++;
    };
    var requests = 0;
    final api = ApiClient(
        session: expired,
        httpClient: MockClient((r) async {
          requests++;
          return http.Response('{}', 200);
        }));
    await expectLater(
        api.request('GET', '/auth/me'), throwsA(isA<SessionExpired>()));
    expect(requests, 0);
    expect(await store.read(), isNull);
    expect(invalidations, greaterThanOrEqualTo(1));
  });

  test('401 invalidates bearer token and notifies navigation', () async {
    await session.save(
        'secret-test-token', DateTime.now().millisecondsSinceEpoch + 60000);
    var invalidated = false;
    session.onExpired = () async {
      invalidated = true;
    };
    final api = ApiClient(
        session: session,
        httpClient: MockClient((request) async {
          expect(request.headers['Authorization'], 'Bearer secret-test-token');
          return http.Response('{}', 401);
        }));
    await expectLater(
        api.request('GET', '/transaction'), throwsA(isA<SessionExpired>()));
    expect(await session.token(), isNull);
    expect(invalidated, isTrue);
  });

  test(
      'login preserves password, stores secure bearer, and restores owned profile',
      () async {
    final expiry = DateTime.now().millisecondsSinceEpoch + 60000;
    Api.client = ApiClient(
        session: session,
        httpClient: MockClient((request) async {
          if (request.url.path == '/auth/login') {
            expect(jsonDecode(request.body)['password'], ' spaces kept  ');
            expect(request.headers.containsKey('Authorization'), isFalse);
            return http.Response(
                jsonEncode({
                  'token': 'token',
                  'expires_at': expiry,
                  'user': {
                    'id': 'u1',
                    'email': 'test@example.com',
                    'gender': 'true'
                  }
                }),
                200);
          }
          expect(request.url.path, '/auth/me');
          expect(request.headers['Authorization'], 'Bearer token');
          return http.Response(
              jsonEncode(
                  {'id': 'u1', 'email': 'test@example.com', 'income': 12.75}),
              200);
        }));
    expect(
        (await UserService.verifyUser(' test@example.com ', ' spaces kept  '))
            ?.id,
        'u1');
    expect(await UserService.restoreSession(), isTrue);
    expect(await SessionManager().get('id'), 'u1');
    expect(await SessionManager().get('income'), '12.75');
    expect(await SessionManager().get('password'), isNull);
  });

  test('recovery uses generic 202 contract without bearer', () async {
    Api.client = ApiClient(
        session: session,
        httpClient: MockClient((request) async {
          expect(request.url.path, '/auth/recover');
          expect(jsonDecode(request.body), {'email': 'test@example.com'});
          expect(request.headers.containsKey('Authorization'), isFalse);
          return http.Response('{"message":"generic"}', 202);
        }));
    expect(await UserService.requestRecovery(' test@example.com '),
        contains('If this email has an account'));
  });

  test('fractional transactions retain cents and omit nullable request fields',
      () async {
    await session.save('token', DateTime.now().millisecondsSinceEpoch + 60000);
    Api.client = ApiClient(
        session: session,
        httpClient: MockClient((request) async {
          if (request.method == 'POST') {
            final body = jsonDecode(request.body) as Map;
            expect(body.containsKey('avatar'), isFalse);
            expect(body.containsKey('name'), isFalse);
            return http.Response('{}', 201);
          }
          return http.Response(
              '[{"id":"t1","amount":1.75,"income":true},{"id":"t2","amount":0.25,"income":false}]',
              200);
        }));
    expect(await TransactionService.calculateBalance('u1'), 1.5);
    expect(await TransactionService.getExpensesAndIncome('u1'),
        {'income': 1.75, 'expenses': 0.25});
    expect(
        (await TransactionService.createTransaction(
            Transactions(amount: 1.25, income: true)) as Map)['success'],
        isTrue);
  });
  test('session expiry timer clears token without another API request',
      () async {
    var expired = false;
    session.onExpired = () async {
      expired = true;
    };
    await session.save(
        'short-lived', DateTime.now().millisecondsSinceEpoch + 30);
    await Future<void>.delayed(const Duration(milliseconds: 70));
    expect(expired, isTrue);
    expect(await session.token(), isNull);
  });

  test('malformed token storage fails closed', () async {
    final store = MemoryTokenStore();
    await store.write('{"token":123,"expires_at":"bad"}');
    final corrupted = AuthSession(store: store);
    expect(await corrupted.token(), isNull);
    expect(await store.read(), isNull);
  });
}
