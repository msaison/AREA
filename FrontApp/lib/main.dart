// ignore_for_file: diagnostic_describe_all_properties, always_specify_types,
// ignore_for_file: unawaited_futures, avoid_catches_without_on_clauses

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    as fluttersecure;
import 'package:http/http.dart' as http;

import 'components/classes.dart';
import 'components/constants.dart';
import 'screens/home/home_main.dart';
import 'screens/login/login_main.dart';

final FlutterAppAuth appAuth = FlutterAppAuth();
const fluttersecure.FlutterSecureStorage secureStorage =
    fluttersecure.FlutterSecureStorage();

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isBusy = false;
  bool isBusyBack = false;
  bool isLoggedIn = false;
  bool isLoggedToback = false;
  String errorMessage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      debugShowCheckedModeBanner: false,
      title: 'Area App',
      home: Scaffold(
        body: Center(
          child: isBusy
              ? const CircularProgressIndicator(
                  backgroundColor: Colors.black,
                  color: Colors.grey,
                )
              : isLoggedIn
                  ? const HomeMain()
                  : LoginScreen(loginAction, errorMessage),
        ),
      ),
    );
  }

  Map<String, Object> parseIdToken(String idToken) {
    final List<String> parts = idToken.split('.');
    assert(parts.length == 3);

    return jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
  }

  Future<Map<String, Object>> getUserDetails(String accessToken) async {
    const String url = 'https://$AUTH0_DOMAIN/userinfo';
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: <String, String>{'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }

  Future<void> loginAction() async {
    setState(() {
      isBusy = true;
      isBusyBack = true;
      errorMessage = '';
    });

    try {
      final AuthorizationTokenResponse result =
          await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          AUTH0_CLIENT_ID,
          AUTH0_REDIRECT_URI,
          issuer: 'https://$AUTH0_DOMAIN',
          scopes: <String>['openid', 'profile', 'offline_access', 'email'],
          // promptValues: ['login']
        ),
      );

      final Map<String, Object> idToken = parseIdToken(result.idToken);
      final Map<String, Object> profile =
          await getUserDetails(result.accessToken);

      await secureStorage.write(
          key: 'refresh_token', value: result.refreshToken);

      setState(() {
        isBusy = false;
        isLoggedIn = true;
        profile_.name = idToken['name'];
        profile_.picture = profile['picture'];
        profile_.id = profile['sub'];
        profile_.nickname = profile['nickname'];
        profile_.email = profile['email'];
        profile_.logoutAction = logoutAction;
      });
    } on Exception catch (e, s) {
      debugPrint('login error: $e - stack: $s');

      setState(() {
        isBusy = false;
        isLoggedIn = false;
        isBusyBack = false;
        isLoggedToback = false;
        errorMessage = e.toString();
      });
    }

    if (isLoggedIn) {
      final Response<dynamic> value = await Api()
          .pushID(profile_.id.substring(profile_.id.indexOf('|') + 1));
      if (value.statusCode != 400) {
        setState(() {
          isBusyBack = false;
          isLoggedToback = value.data['is_connected'];
        });
      } else {
        setState(() {
          isBusy = false;
          isLoggedToback = false;
          isLoggedIn = false;
          isBusyBack = false;
        });
      }
    }
  }

  Future<void> logoutAction() async {
    await secureStorage.delete(key: 'refresh_token');
    setState(() {
      isLoggedIn = false;
      isBusy = false;
      isLoggedToback = false;
      isBusyBack = false;
      // globalActionReaction.clearActionReaction();
    });
  }

  @override
  void initState() {
    initAction();
    super.initState();
  }

  Future<void> initAction() async {
    final String storedRefreshToken =
        await secureStorage.read(key: 'refresh_token');
    if (storedRefreshToken == null) return;

    setState(() {
      isBusy = true;
      isBusyBack = true;
    });

    try {
      final TokenResponse response = await appAuth.token(TokenRequest(
        AUTH0_CLIENT_ID,
        AUTH0_REDIRECT_URI,
        issuer: AUTH0_ISSUER,
        refreshToken: storedRefreshToken,
      ));

      final Map<String, Object> idToken = parseIdToken(response.idToken);
      final Map<String, Object> profile =
          await getUserDetails(response.accessToken);

      await secureStorage.write(
          key: 'refresh_token', value: response.refreshToken);

      setState(() {
        isBusy = false;
        isBusyBack = false;
        isLoggedIn = true;
        isLoggedToback = true;
        profile_.name = idToken['name'];
        profile_.picture = profile['picture'];
        profile_.nickname = profile['nickname'];
        profile_.id = profile['sub'];
        profile_.email = profile['email'];
        profile_.logoutAction = logoutAction;
      });
    } on Exception catch (e, s) {
      debugPrint('error on refresh token: $e - stack: $s');
      await logoutAction();
    }
  }
}
