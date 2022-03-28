// ignore_for_file: diagnostic_describe_all_properties

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoApplet extends StatelessWidget {
  final Future<void> Function() logoutAction;
  final String name;
  final String picture;
  final String id;

  const NoApplet(this.logoutAction, this.name, this.picture, this.id, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 90),
          child: Text(
            'Start connecting your world.',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              height: 1.5,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          height: 100,
        ),
        Image.asset(
          'assets/images/no_widget.png',
          scale: 3,
        ),
      ],
    );
  }
}
