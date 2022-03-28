// ignore_for_file: diagnostic_describe_all_properties, always_specify_types
// ignore_for_file: must_be_immutable,

import 'package:flutter/material.dart';

import '../../components/using_func.dart';
import 'components/params_body.dart';
import 'components/params_header.dart';

class ParamsMain extends StatelessWidget {
  Map<String, dynamic> responseList;
  int index;
  String type;
  ParamsMain(this.responseList, this.index, this.type,
  {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: getColorFromHex(responseList['code_hex']),
      body: Stack(
        children: <Widget>[
          const ParamsHeader(),
          ParamsBody(responseList, index, type),
          // ParamsBottom(type),
          // No more here, for simplicity (in params_body)
        ],
      ),
    );
  }
}
