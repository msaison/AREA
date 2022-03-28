// ignore_for_file: always_specify_types

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../../components/classes.dart';
import '../../../components/constants.dart';
import '../../../components/if_then_button.dart';
import '../../../components/preview_if_then_button.dart';
import '../../home/home_main.dart';
import '../../services/services_main.dart';
import '../../trigger_action/trigger_action_main.dart';

class CreateBody extends StatelessWidget {
  const CreateBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Text(
          'Create an Applet',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        if (globalActionReaction.action.isEmpty)
          ButtonApplet(-0.3, 'If  This', true, () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.bottomToTop,
                child: const ServicesMain('action'),
              ),
            );
          })
        else
          ButtonAppletIfThen(true, globalActionReaction.action['desc_type'],
              () {
            showCupertinoModalPopup(
              barrierColor: Colors.black38,
              context: context,
              builder: (context) => CupertinoActionSheet(
                title: Text(
                  'Edit trigger',
                  style: GoogleFonts.montserrat(fontSize: 10),
                ),
                actions: <Widget>[
                  CupertinoActionSheetAction(
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.bottomToTop,
                          child: const ServicesMain('action'),
                        ),
                      );
                    },
                    child: Text(
                      'Change trigger service',
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  CupertinoActionSheetAction(
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.bottomToTop,
                          child:
                              TriggerActionMain(userUse.responseList, 'action'),
                        ),
                      );
                    },
                    child: Text(
                      'Change trigger',
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            );
          }, globalActionReaction.action['logo_type'],
              globalActionReaction.action['color_type']),
        Container(
          width: 5,
          height: 20,
          decoration: const BoxDecoration(color: Colors.white),
        ),
        if (globalActionReaction.action.isEmpty)
          ButtonApplet(-0.6, 'Then  That', false, () {})
        else
          globalActionReaction.reaction.isEmpty
              ? ButtonApplet(-0.6, 'Then  That', true, () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.bottomToTop,
                      child: const ServicesMain('reaction'),
                    ),
                  );
                })
              : ButtonAppletIfThen(
                  false, globalActionReaction.reaction['desc_type'], () {
                  showCupertinoModalPopup(
                    barrierColor: Colors.black38,
                    context: context,
                    builder: (context) => CupertinoActionSheet(
                      title: Text(
                        'Edit trigger',
                        style: GoogleFonts.montserrat(fontSize: 10),
                      ),
                      actions: <Widget>[
                        CupertinoActionSheetAction(
                          isDefaultAction: true,
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.bottomToTop,
                                child: const ServicesMain('reaction'),
                              ),
                            );
                          },
                          child: Text(
                            'Change trigger service',
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        CupertinoActionSheetAction(
                          isDefaultAction: true,
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.bottomToTop,
                                child: TriggerActionMain(
                                    userUse.responseList, 'reaction'),
                              ),
                            );
                          },
                          child: Text(
                            'Change trigger',
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                      cancelButton: CupertinoActionSheetAction(
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                }, globalActionReaction.reaction['logo_type'],
                  globalActionReaction.reaction['color_type']),
        SizedBox(
          height: height - 540,
        ),
        if (globalActionReaction.action.isNotEmpty &&
            globalActionReaction.reaction.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: SizedBox(
              height: 60,
              width: width,
              child: CupertinoButton(
                onPressed: () async {
                  await Api().pushTriggerAction();
                  globalActionReaction.clearActionReaction();
                  await Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.topToBottom,
                      child: const HomeMain(),
                    ),
                  );
                },
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                child: Text(
                  'Finish',
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.darkBackgroundGray,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
