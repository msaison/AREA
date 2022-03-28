// ignore_for_file: must_be_immutable, diagnostic_describe_all_properties

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

import '../../../components/using_func.dart';

class TriggerActionHeader extends StatelessWidget {
  Map<String, dynamic> responseList;

  TriggerActionHeader(this.responseList, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          width: double.infinity,
          height: (height / 2) - 50,
          decoration:
              BoxDecoration(color: getColorFromHex(responseList['code_hex'])),
        ),
        Column(
          children: <Widget>[
            const SizedBox(height: 70),
            Row(
              children: <Widget>[
                const SizedBox(
                  width: 20,
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      LineIcons.angleLeft,
                      color: Colors.white,
                    )),
                const SizedBox(
                  width: 35,
                ),
                Text(
                  'Choose a trigger',
                  style: GoogleFonts.montserrat(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Image.network(
              responseList['logo'],
              scale: 3.5,
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                responseList['desc'],
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
