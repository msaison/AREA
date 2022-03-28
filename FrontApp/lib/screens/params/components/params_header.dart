import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

class ParamsHeader extends StatelessWidget {
  const ParamsHeader({Key key}) : super(key: key);

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
                icon: const Icon(LineIcons.angleLeft),
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                }),
            SizedBox(
              width: (width / 2) - 165,
            ),
            Text(
              'Complete action fields',
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
