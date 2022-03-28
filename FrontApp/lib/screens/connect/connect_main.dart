// ignore_for_file: diagnostic_describe_all_properties, must_be_immutable

import 'package:flutter/material.dart';

import '../../components/using_func.dart';
import 'components/connect_body.dart';
import 'components/connect_header.dart';

class ConnectMain extends StatelessWidget {
  Map<String, dynamic> responseList;
  final String type;
  final int index;

  ConnectMain(this.responseList, this.type, this.index,
  {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorFromHex(responseList['code_hex']),
      body: Column(
        children: <Widget>[
          const ConnectHeader(),
          ConnectBody(responseList, type, index),
        ],
      ),
    );
  }
}
