// ignore_for_file: must_be_immutable, diagnostic_describe_all_properties,
// ignore_for_file: always_specify_types
// ignore_for_file: avoid_function_literals_in_foreach_calls,
// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../../components/classes.dart';
import '../../../components/constants.dart';
import '../../../components/using_func.dart';
import '../../connect/connect_main.dart';
import '../../create/create_main.dart';
import '../../edit/edit_main.dart';
import '../../params/params_main.dart';

class TriggerActionTiles extends StatelessWidget {
  Map<String, dynamic> responseList;
  final String type;

  TriggerActionTiles(this.responseList, this.type, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        itemCount: responseList['${type}s'].length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                onTap: () {
                  Api()
                      .isConnected(
                          profile_.id.substring(profile_.id.indexOf('|') + 1),
                          responseList['name'].toUpperCase())
                      .then((value) => {
                            if (value)
                              {
                                if (!responseList['${type}s'][index]['params']
                                    .isEmpty)
                                  {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.bottomToTop,
                                        child: ParamsMain(
                                            responseList, index, type),
                                      ),
                                    ),
                                  }
                                else
                                  {
                                    globalActionReaction.allSet(
                                      type,
                                      responseList['type'],
                                      responseList['${type}s'][index]['type'],
                                      [],
                                      profile_.id.substring(
                                          profile_.id.indexOf('|') + 1),
                                      [],
                                      responseList['${type}s'][index]['desc'],
                                      responseList['logo'],
                                      responseList['code_hex'],
                                    ),
                                    if (userUse.update)
                                      {
                                        userUse.update = false,
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type:
                                                PageTransitionType.bottomToTop,
                                            child: EditMain(
                                                userUse.responseListUpdate),
                                          ),
                                        ),
                                      }
                                    else
                                      {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type:
                                                PageTransitionType.bottomToTop,
                                            child: const CreateMain(),
                                          ),
                                        ),
                                      }
                                  },
                              }
                            else
                              {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.bottomToTop,
                                    child:
                                        ConnectMain(responseList, type, index),
                                  ),
                                ),
                              }
                          });
                },
                child: Card(
                  color: getColorFromHex(responseList['code_hex']),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: ListTile(
                    title: Text(
                      responseList['${type}s'][index]['desc'],
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 7,
              ),
            ],
          );
        });
  }
}
