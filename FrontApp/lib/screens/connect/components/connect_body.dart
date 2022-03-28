// ignore_for_file: diagnostic_describe_all_properties, must_be_immutable
// ignore_for_file: prefer_interpolation_to_compose_strings
// ignore_for_file: always_specify_types, unused_local_variable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../../components/classes.dart';
import '../../../components/constants.dart';
import '../../create/create_main.dart';
import '../../edit/edit_main.dart';
import '../../params/params_main.dart';

class ConnectBody extends StatefulWidget {
  Map<String, dynamic> responseList;
  final String type;
  final int index;

  ConnectBody(this.responseList, this.type, this.index, {Key key})
      : super(key: key);

  @override
  State<ConnectBody> createState() => _ConnectBodyState();
}

class _ConnectBodyState extends State<ConnectBody> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    // ignore: prefer_typing_uninitialized_variables
    var result, url;
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 50,
        ),
        Image.network(
          widget.responseList['logo'],
          scale: 3,
        ),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Text(
            '${'Connect to ' + widget.responseList['name']} to continue',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: SizedBox(
            width: width,
            child: CupertinoButton(
              onPressed: () async {
                await Api()
                    .getUri(profile_.id.substring(profile_.id.indexOf('|') + 1),
                        widget.responseList['available_auths'][0].toString())
                    .then((value) => {
                          if (value == null && value != '201')
                            {
                              Fluttertoast.showToast(
                                  msg: 'url invalid, please retry $value'),
                            }
                          else
                            {
                              setState(() {
                                url = value;
                              }),
                            }
                        });
                if (url != null && url != '201') {
                  try {
                    result = await FlutterWebAuth.authenticate(
                        url: url, callbackUrlScheme: 'area');
                    if (widget.responseList['${widget.type}s'][0]['params']
                        .isNotEmpty) {
                      await Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.bottomToTop,
                          child: ParamsMain(
                              widget.responseList, widget.index, widget.type),
                        ),
                      );
                    } else {
                      globalActionReaction.allSet(
                        widget.type,
                        widget.responseList['type'],
                        widget.responseList['${widget.type}s'][widget.index]
                            ['type'],
                        [],
                        profile_.id.substring(profile_.id.indexOf('|') + 1),
                        [],
                        widget.responseList['${widget.type}s'][widget.index]
                            ['desc'],
                        widget.responseList['logo'],
                        widget.responseList['code_hex'],
                      );
                      await Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.bottomToTop,
                            child: userUse.update
                                ? EditMain(userUse.responseListUpdate)
                                : const CreateMain()),
                      );
                    }
                  } on PlatformException catch (e) {
                    await Fluttertoast.showToast(msg: 'Got error: $e');
                  }
                } else {
                  if (widget.responseList['${widget.type}s'][0]['params']
                      .isNotEmpty) {
                    await Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.bottomToTop,
                        child: ParamsMain(
                            widget.responseList, widget.index, widget.type),
                      ),
                    );
                  } else {
                    globalActionReaction.allSet(
                      widget.type,
                      widget.responseList['type'],
                      widget.responseList['${widget.type}s'][widget.index]
                          ['type'],
                      [],
                      profile_.id.substring(profile_.id.indexOf('|') + 1),
                      [],
                      widget.responseList['${widget.type}s'][widget.index]
                          ['desc'],
                      widget.responseList['logo'],
                      widget.responseList['code_hex'],
                    );
                    await Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.bottomToTop,
                          child: userUse.update
                              ? EditMain(userUse.responseListUpdate)
                              : const CreateMain()),
                    );
                  }
                }
              },
              color: Colors.black26,
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              child: Text(
                'Connect',
                style: GoogleFonts.montserrat(
                    fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
