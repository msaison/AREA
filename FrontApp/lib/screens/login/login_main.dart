// ignore_for_file: diagnostic_describe_all_properties

import 'package:flutter/material.dart';

import '../../components/display_video.dart';
import 'components/login_bottom.dart';
import 'components/login_header.dart';

class LoginScreen extends StatelessWidget {
  final Future<void> Function() loginAction;
  final String loginError;

  const LoginScreen(this.loginAction, this.loginError, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            const DisplayVideo('assets/video/background.mp4'),
            LoginButtom(loginAction, loginError),
            const LoginHeader(),
          ],
        ),
      ),
    );
  }
}
