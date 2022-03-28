// ignore_for_file: diagnostic_describe_all_properties, must_be_immutable
// ignore_for_file: always_specify_types, cascade_invocations

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../../components/constants.dart';
import '../../create/create_main.dart';
import '../../edit/edit_main.dart';

class ParamsBottom extends StatelessWidget {
  String type;
  List<String> form;
  Map<String, dynamic> responseList;
  int index;
  ParamsBottom(this.type, this.form, this.responseList, this.index, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: width,
            height: 60,
            child: CupertinoButton(
              onPressed: () {
                form.removeWhere((value) => value == null || value == '');
                for (var i = 0;
                    form.length <
                        responseList['${type}s'][index]['params'].length;
                    i++) {
                  form.add(null);
                }
                globalActionReaction.allSet(
                  type,
                  responseList['type'],
                  responseList['${type}s'][index]['type'],
                  form,
                  profile_.id.substring(profile_.id.indexOf('|') + 1),
                  responseList['${type}s'][index]['params'],
                  responseList['${type}s'][index]['desc'],
                  responseList['logo'],
                  responseList['code_hex'],
                );
                if (userUse.update) {
                  userUse.update = false;
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.bottomToTop,
                      child: EditMain(userUse.responseListUpdate),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.bottomToTop,
                      child: const CreateMain(),
                    ),
                  );
                }
              },
              color: Colors.black26,
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              child: Text(
                'Create $type',
                style: GoogleFonts.montserrat(
                    fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        )
      ],
    );
  }
}
