// ignore_for_file: diagnostic_describe_all_properties, must_be_immutable
// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonApplet extends StatelessWidget {
  double alignmentText;
  final String text;
  final bool buttonActivate;
  final Function() press;

  ButtonApplet(this.alignmentText, this.text, this.buttonActivate, this.press,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int backgroundOpacity;
    if (!buttonActivate) {
      alignmentText = 0;
      backgroundOpacity = 200;
    } else {
      backgroundOpacity = 255;
    }
    final double width = MediaQuery.of(context).size.width;
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: press,
      child: Container(
        height: 80,
        width: width - 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color.fromARGB(backgroundOpacity, 255, 255, 255),
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment(alignmentText, 0),
              child: Text(
                text,
                style: GoogleFonts.montserrat(
                    color: CupertinoColors.darkBackgroundGray,
                    fontSize: 30,
                    fontWeight: FontWeight.w700),
              ),
            ),
            if (buttonActivate)
              Align(
                alignment: const Alignment(0.8, 0),
                child: Container(
                  width: 60,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: CupertinoColors.darkBackgroundGray,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Center(
                    child: Text(
                      'Add',
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              )
            else
              Container(),
          ],
        ),
      ),
    );
  }
}
