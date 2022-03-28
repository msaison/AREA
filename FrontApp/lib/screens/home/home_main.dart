// ignore_for_file: diagnostic_describe_all_properties, always_specify_types
// ignore_for_file: unused_field

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/classes.dart';
import '../../components/constants.dart';
import 'components/display_applets.dart';
import 'components/home_bottom.dart';
import 'components/home_header.dart';
import 'components/no_applet.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({Key key}) : super(key: key);

  @override
  State<HomeMain> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  bool asWidget = false;
  Response responseJSON;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.darkBackgroundGray,
      body: FutureBuilder(
          future: Api()
              .getApplet(profile_.id.substring(profile_.id.indexOf('|') + 1)),
          builder: (context, snapshot) {
            return Column(
              children: <Widget>[
                const SizedBox(
                  height: 40,
                ),
                HomeHeader(profile_.logoutAction, profile_.name,
                    profile_.picture, profile_.id),
                if (!snapshot.hasData)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        NoApplet(profile_.logoutAction, profile_.name,
                            profile_.picture, profile_.id),
                      ],
                    ),
                  )
                else
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                            child: Text(
                              'Created (${snapshot.data.length})',
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DisplayApplets(snapshot.data, snapshot.data.length),
                      ],
                    ),
                  ),
                const HomeBottom(),
              ],
            );
          }),
    );
  }
}
