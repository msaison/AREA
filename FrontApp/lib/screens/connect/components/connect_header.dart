import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

class ConnectHeader extends StatelessWidget {
  const ConnectHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 60,
        ),
        Row(
          children: <Widget>[
            IconButton(
                iconSize: 35,
                icon: const Icon(LineIcons.times),
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                }),
            SizedBox(
              width: (width / 2) - 145,
            ),
            Text(
              'Connect service',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w800,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
