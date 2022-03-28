// ignore_for_file: diagnostic_describe_all_properties, must_be_immutable
// ignore_for_file: avoid_positional_boolean_parameters
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'using_func.dart';

class ButtonAppletIfThen extends StatelessWidget {
  // True print if and false print Then
  final bool if_or_then;
  final String text_trigger_action;
  final String image;
  final String background_color;
  final Function() press;

  const ButtonAppletIfThen(this.if_or_then, this.text_trigger_action,
      this.press, this.image, this.background_color,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String if_then;
    if (if_or_then) {
      if_then = 'If';
    } else {
      if_then = 'Then';
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
          color: getColorFromHex(background_color),
        ),
        child: Row(
          children: <Widget>[
            const SizedBox(width: 15,),
            Text(
              if_then,
              style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 15,),
            Image.network(
              image,
              scale: 5,
            ),
            const SizedBox(width: 15,),
            Text(
              text_trigger_action,
              style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
