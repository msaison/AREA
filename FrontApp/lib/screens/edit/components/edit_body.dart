// ignore_for_file: always_specify_types, diagnostic_describe_all_properties,
// ignore_for_file: must_be_immutable, avoid_positional_boolean_parameters

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../../components/constants.dart';
import '../../../components/preview_if_then_button.dart';
import '../../services/services_main.dart';
import '../../trigger_action/trigger_action_main.dart';

class EditBody extends StatelessWidget {
  Color buttonColor;
  Map<String, dynamic> responseList;

  EditBody(this.buttonColor, this.responseList, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Column(
        children: <Widget>[
          buttonActionReaction(
            context,
            globalActionReaction.action['desc_type'] ??
                responseList['action']['service']['actions'][0]['desc'],
            'action',
            globalActionReaction.action['logo_type'] ??
                responseList['action']['service']['logo'],
            globalActionReaction.action['color_type'] ??
                responseList['action']['service']['code_hex'],
            true,
          ),
          Container(
            width: 5,
            height: 20,
            decoration: const BoxDecoration(color: Colors.white),
          ),
          buttonActionReaction(
            context,
            globalActionReaction.reaction['desc_type'] ??
                responseList['reaction']['service']['reactions'][0]['desc'],
            'reaction',
            globalActionReaction.reaction['logo_type'] ??
                responseList['reaction']['service']['logo'],
            globalActionReaction.reaction['color_type'] ??
                responseList['reaction']['service']['code_hex'],
            false,
          ),
        ],
      ),
    );
  }
}

Widget buttonActionReaction(
    BuildContext context,
    String textTriggerAction,
    String actionReaction,
    String image,
    String backgroundColor,
    bool actionreaction_) {
  return ButtonAppletIfThen(actionreaction_, textTriggerAction, () {
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
              userUse.update = true;
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.bottomToTop,
                  child: ServicesMain(actionReaction),
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
              userUse.update = true;
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.bottomToTop,
                  child: TriggerActionMain(
                      actionreaction_
                          ? userUse.actionIfNoModif['service']
                          : userUse.reactionIfNoModif['service'],
                      actionReaction),
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
  }, image, backgroundColor);
}

      // action['service_type'] = serviceType;
      // action['reaction_type'] = reactionType;
      // action['params'] = params;
      // action['auth0_id'] = auth0Id;
      // action['key_params'] = keyParams;
      // action['desc_type'] = descType;
      // action['color_type'] = colorType;
      // action['logo_type'] = logoType;