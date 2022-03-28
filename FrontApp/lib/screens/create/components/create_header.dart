// ignore_for_file: always_specify_types

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:page_transition/page_transition.dart';

import '../../../components/constants.dart';
import '../../home/home_main.dart';

class CreateHeader extends StatelessWidget {
  const CreateHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String changes =
        'You have unsaved changes that will be lost if you leave the page.';
    final double width = MediaQuery.of(context).size.width;
    return Row(
      children: <Widget>[
        const SizedBox(
          width: 10,
        ),
        IconButton(
          icon: const Icon(LineIcons.times),
          iconSize: 35,
          onPressed: () {
            if (globalActionReaction.action.isNotEmpty) {
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context_) => AlertDialog(
                        insetPadding: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        content: Builder(
                          builder: (context) {
                            final height = MediaQuery.of(context).size.height;
                            final width = MediaQuery.of(context).size.width;
                            return Container(
                              height: height / 6,
                              width: width - 90,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text('Are you sure?',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black,
                                        )),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      changes,
                                      textAlign: TextAlign.justify,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          InkWell(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(30)),
                                            onTap: () {
                                              Navigator.pop(context_);
                                            },
                                            child: Container(
                                              width: 110,
                                              height: 40,
                                              decoration: const BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30)),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Stay here',
                                                  style: GoogleFonts.montserrat(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(30)),
                                            onTap: () {
                                              globalActionReaction
                                                  .clearActionReaction();
                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                  type: PageTransitionType
                                                      .topToBottom,
                                                  child: const HomeMain(),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: 110,
                                              height: 40,
                                              child: Center(
                                                child: Text(
                                                  'Leave',
                                                  style: GoogleFonts.montserrat(
                                                      color: Colors.red,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                            );
                          },
                        ),
                      ));
            } else {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.topToBottom,
                  child: const HomeMain(),
                ),
              );
            }
          },
          color: Colors.white,
        ),
        SizedBox(
          width: (width / 2) - 150,
        ),
        Text('Create your own',
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            )),
      ],
    );
  }
}
