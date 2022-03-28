// ignore_for_file: always_specify_types

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:page_transition/page_transition.dart';

import '../../../components/constants.dart';
import '../../create/create_main.dart';
import '../../edit/edit_main.dart';

class ServicesHeader extends StatelessWidget {
  const ServicesHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 50,
        ),
        Row(
          children: <Widget>[
            IconButton(
                iconSize: 35,
                icon: const Icon(LineIcons.times),
                color: Colors.white,
                onPressed: () {
                  if (!userUse.update) {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.topToBottom,
                        child: const CreateMain(),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.topToBottom,
                        child: EditMain(userUse.responseListUpdate),
                      ),
                    );
                  }
                }),
            SizedBox(
              width: (width / 2) - 145,
            ),
            Text(
              'Choose a service',
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
