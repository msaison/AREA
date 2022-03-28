// ignore_for_file: must_be_immutable, diagnostic_describe_all_properties

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/constants.dart';
import '../../components/using_func.dart';
import 'components/edit_body.dart';
import 'components/edit_bottom.dart';
import 'components/edit_header.dart';

class EditMain extends StatelessWidget {
  Map<String, dynamic> responseList;

  EditMain(this.responseList, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.darkBackgroundGray,
      body: Column(
        children: <Widget>[
          EditHeader(
            globalActionReaction.action['logo_type'] ??
            responseList['action']['service']['logo'],
            globalActionReaction.reaction['logo_type'] ??
            responseList['reaction']['service']['logo'],
            <Color>[
              getColorFromHex(globalActionReaction.action['color_type'] ??
                responseList['action']['service']['code_hex']),
              getColorFromHex(globalActionReaction.reaction['color_type'] ??
                responseList['reaction']['service']['code_hex']),
            ],
            globalActionReaction.action['desc_type'] ??
            responseList['action']['service']['actions'][0]['desc_applet'],
            globalActionReaction.reaction['desc_type'] ??
            responseList['reaction']['service']['reactions'][0]['desc_applet'],
            responseList['reaction']['params'][0]['to'],
            profile_.nickname,
          ),
          EditBody(
            getColorFromHex(responseList['action']['service']['code_hex']),
            responseList,
          ),
          Expanded(child: EditBottom(responseList))
        ],
      ),
    );
  }
}