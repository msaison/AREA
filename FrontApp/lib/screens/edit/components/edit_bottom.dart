// ignore_for_file: diagnostic_describe_all_properties, must_be_immutable
// ignore_for_file: always_specify_types

import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../../components/classes.dart';
import '../../../components/constants.dart';
import '../../home/home_main.dart';

class EditBottom extends StatelessWidget {
  Map<String, dynamic> responseList;
  EditBottom(this.responseList, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            buttonUpdateDelete(context, 'Update', CupertinoColors.activeGreen,
                () async {
              await Api().deleteApplet(
                  profile_.id.substring(profile_.id.indexOf('|') + 1),
                  responseList['reaction']['id']);
              await Api().pushTriggerAction();
              globalActionReaction.clearActionReaction();
              userUse.clearActionReactionModif();
            }),
            const SizedBox(
              height: 20,
            ),
            buttonUpdateDelete(
                context, 'Delete', CupertinoColors.destructiveRed, () async {
              await Api().deleteApplet(
                profile_.id.substring(profile_.id.indexOf('|') + 1),
                responseList['reaction']['id'],
              );
              await Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.bottomToTop,
                  child: const HomeMain(),
                ),
              );
            }),
            const SizedBox(
              height: 20,
            )
          ],
        ));
  }
}

Widget buttonUpdateDelete(
    BuildContext context, String text, Color buttonColor, Function() press) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: SizedBox(
      width: double.infinity,
      height: 60,
      child: CupertinoButton(
        onPressed: press,
        color: buttonColor,
        borderRadius: const BorderRadius.all(Radius.circular(40)),
        child: Text(
          text,
          style:
              GoogleFonts.montserrat(fontSize: 25, fontWeight: FontWeight.w700),
        ),
      ),
    ),
  );
}
