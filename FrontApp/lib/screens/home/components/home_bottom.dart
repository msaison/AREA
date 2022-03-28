// ignore_for_file: always_specify_types

import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../create/create_main.dart';

class HomeBottom extends StatelessWidget {
  const HomeBottom({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 84,
              decoration:
                  const BoxDecoration(color: Color.fromARGB(255, 0, 0, 0)),
            ),
            CupertinoButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.bottomToTop,
                    child: const CreateMain(),
                  ),
                );
              },
              color: const Color.fromARGB(255, 51, 51, 51),
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              child: Text(
                'Create',
                style: GoogleFonts.montserrat(
                    fontSize: 20, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
