// ignore_for_file: diagnostic_describe_all_properties, always_specify_types
// ignore_for_file: type_annotate_public_apis
// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../../components/classes.dart';
import '../../../components/constants.dart';
import '../../../components/using_func.dart';
import '../../home/home_main.dart';

class ProfileBody extends StatelessWidget {
  final Future<void> Function() logoutAction;
  final String name;
  final String picture;
  final List<dynamic> value;

  const ProfileBody(this.logoutAction, this.name, this.picture, this.value,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 80,
          ),
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 4),
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(picture ?? ''),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            name,
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            profile_.email,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 400,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: value != null
                ? ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ConnectedButton(
                          index,
                          value,
                          value[index]['is_connected'],
                          value[index]['is_connected']
                              ? () {
                                  popUpshow(context, value[index]['id']);
                                }
                              : () async {
                                  final String url =
                                      await getUrl(value[index]['type']);
                                  if (url != null) {
                                    await FlutterWebAuth.authenticate(
                                        url: url, callbackUrlScheme: 'area');
                                    await Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.bottomToTop,
                                          child: const HomeMain()),
                                    );
                                  }
                                });
                    })
                : const Center(child: CircularProgressIndicator()),
          ),
          Expanded(
              child: buttonLogout(
                  context, 'Logout', CupertinoColors.destructiveRed, () {}))
        ],
      ),
    );
  }
}

class ConnectedButton extends StatelessWidget {
  final List<dynamic> value;
  final int index;
  final bool connected;
  final Function() press;
  const ConnectedButton(
    this.index,
    this.value,
    this.connected,
    this.press, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Card(
        color: !connected
            ? getColorFromHex(value[index]['code_hex'])
            : CupertinoColors.tertiaryLabel,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: ListTile(
          title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Image.network(
                    value[index]['logo'],
                    scale: 7,
                    color:
                        !connected ? Colors.white : CupertinoColors.systemGrey4,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  !connected
                      ? "Connect with ${value[index]['name']}"
                      : "You're connected with ${value[index]['name']}",
                  style: GoogleFonts.montserrat(
                    color:
                        !connected ? Colors.white : CupertinoColors.systemGrey4,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ]),
        ),
      ),
    );
  }
}

Widget buttonLogout(
    BuildContext context, String text, Color buttonColor, Function() press) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Align(
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
                style: GoogleFonts.montserrat(
                    fontSize: 25, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    ),
  );
}

Future<String> getUrl(String type) async {
  String url;
  await Api()
      .getUri(profile_.id.substring(profile_.id.indexOf('|') + 1), type)
      .then((value) => {
            if (value == null && value != '201')
              {
                Fluttertoast.showToast(msg: 'url invalid, please retry $value'),
                url = value,
              }
            else
              {
                url = value
                // setState(() {
                //   url = value;
                // }),
              }
          });
  return url;
}

void popUpshow(BuildContext context, id) {
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
                          "You're about to disconnect you to the service.",
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
                                    const BorderRadius.all(Radius.circular(30)),
                                onTap: () {
                                  Navigator.pop(context_);
                                },
                                child: Container(
                                  width: 110,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Back',
                                      style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(30)),
                                onTap: () async {
                                  await Api().deleteAuth(
                                      id,
                                      profile_.id.substring(
                                          profile_.id.indexOf('|') + 1));
                                  await Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.bottomToTop,
                                      child: const HomeMain(),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 110,
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      'Disconnect',
                                      style: GoogleFonts.montserrat(
                                          color: Colors.red,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
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
}
