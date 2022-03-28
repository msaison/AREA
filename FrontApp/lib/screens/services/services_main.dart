// ignore_for_file: always_specify_types, diagnostic_describe_all_properties

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/services_body.dart';
import 'components/services_header.dart';

class ServicesMain extends StatelessWidget {
  final String type;

  const ServicesMain(this.type, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.darkBackgroundGray,
      body: Column(
        children: <Widget>[
          const ServicesHeader(),
          Expanded(child: ServicesBody(type)),
        ],
      ),
    );
  }
}
