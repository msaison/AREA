// ignore_for_file: must_be_immutable, parameter_assignments, missing_return,
// ignore_for_file: diagnostic_describe_all_properties, always_specify_types

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../../components/using_func.dart';
import '../../trigger_action/trigger_action_main.dart';

class ServicesGrid extends StatelessWidget {
  AsyncSnapshot<dynamic> responseList;
  final String type;

  ServicesGrid(this.responseList, this.type, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 250,
              childAspectRatio: 1.3,
              crossAxisSpacing: 13,
              mainAxisSpacing: 13),
          itemCount: responseList.data.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: TriggerActionMain(responseList.data[index], type),
                  ),
                );
              },
              hoverColor: Colors.black,
              child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color:
                          getColorFromHex(responseList.data[index]['code_hex']),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 25,
                      ),
                      Image.network(
                        responseList.data[index]['logo'],
                        scale: 5,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        responseList.data[index]['name'],
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )),
            );
          }),
    );
  }
}
