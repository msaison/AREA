// ignore_for_file: diagnostic_describe_all_properties, must_be_immutable
// ignore_for_file: always_specify_types

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:page_transition/page_transition.dart';

import '../../../components/constants.dart';
import '../../home/home_main.dart';

class EditHeader extends StatelessWidget {
  String linkActionImage;
  String linkReactionImage;
  List<Color> backgroundColor;
  String action;
  String reaction;
  String params;
  String nickname;
  EditHeader(this.linkActionImage, this.linkReactionImage, this.backgroundColor,
      this.action, this.reaction, this.params, this.nickname,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          width: double.infinity,
          height: height / 2 - 70,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: backgroundColor,
              begin: Alignment.topLeft,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(LineIcons.angleLeft),
                  iconSize: 30,
                  color: Colors.white,
                  onPressed: () {
                    userUse.update = false;
                    globalActionReaction.clearActionReaction();
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.leftToRight,
                        child: const HomeMain(),
                      ),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.network(
                      linkActionImage,
                      scale: 4,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Image.network(
                      linkReactionImage,
                      scale: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  action + reaction,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (params != null)
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    params,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              else
                Container(),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'by $nickname',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
