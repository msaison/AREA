// ignore_for_file: diagnostic_describe_all_properties, must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/constants.dart';
import 'components/trigger_action_header.dart';
import 'components/trigger_action_tiles.dart';

class TriggerActionMain extends StatelessWidget {
  Map<String, dynamic> responseList;
  final String type;

  TriggerActionMain(this.responseList, this.type, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    userUse.responseList = responseList;
    return Scaffold(
      backgroundColor: CupertinoColors.darkBackgroundGray,
      body: Column(
        children: <Widget>[
          TriggerActionHeader(responseList),
          Expanded(child: TriggerActionTiles(responseList, type)),
        ],
      ),
    );
  }
}
