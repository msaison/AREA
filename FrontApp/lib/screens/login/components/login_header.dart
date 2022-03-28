import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 50,
        ),
        Row(
          children: <Widget>[
            const SizedBox(
              width: 15,
            ),
            Image.asset(
              'assets/images/arealogo.png',
              scale: 10,
            ),
          ],
        ),
      ],
    );
  }
}
