// ignore_for_file: diagnostic_describe_all_properties, must_be_immutable, lines_longer_than_80_chars, always_specify_types

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../../components/constants.dart';
import '../../../components/using_func.dart';
import '../../edit/edit_main.dart';

class DisplayApplets extends StatelessWidget {
  List<dynamic> responseList;
  int length;

  DisplayApplets(this.responseList, this.length, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Container(
      height: height - 300,
      child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          itemCount: length,
          itemBuilder: (BuildContext context, int index) {
            final double width = MediaQuery.of(context).size.width;
            return Column(
              children: <Widget>[
                InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  onTap: () {
                    userUse.actionIfNoModif = responseList[index]['action'];
                    userUse.reactionIfNoModif = responseList[index]['reaction'];
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: EditMain(responseList[index]),
                      ),
                    );
                  },
                  child: Container(
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      gradient: LinearGradient(
                        colors: <Color>[
                          getColorFromHex(responseList[index]['action']
                              ['service']['code_hex']),
                          getColorFromHex(responseList[index]['reaction']
                              ['service']['code_hex']),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomLeft,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '${responseList[index]['action']['service']['actions'][0]['desc_applet']}${responseList[index]['reaction']['service']['reactions'][0]['desc_applet']}',
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (responseList[index]['reaction']['params'][0]
                                  ['to'] !=
                              null)
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                responseList[index]['reaction']['params'][0]
                                    ['to'],
                                textAlign: TextAlign.right,
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          else
                            Container(),
                          const SizedBox(
                            height: 15,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'by ${profile_.nickname}',
                              textAlign: TextAlign.right,
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              height: 30,
                              width: width / 3,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Colors.black38),
                              child: Center(
                                child: Text(
                                  'Tap to edit',
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Image.network(
                                  responseList[index]['action']['service']
                                      ['logo'],
                                  scale: 8,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Image.network(
                                  responseList[index]['reaction']['service']
                                      ['logo'],
                                  scale: 8,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
              ],
            );
          }),
    );
  }
}
