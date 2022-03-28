// ignore_for_file: camel_case_types
// ignore_for_file: diagnostic_describe_all_properties

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// import 'package:flutter/cupertino.dart';

class LoginButtom extends StatelessWidget {
  final Future<void> Function() loginAction;
  final String loginError;

  const LoginButtom(this.loginAction, this.loginError, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: width,
            height: 60,
            child: CupertinoButton(
              onPressed: () async {
                await loginAction();
              },
              color: Colors.black,
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              child: Text(
                'Continue',
                style: GoogleFonts.montserrat(
                    fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }
}
