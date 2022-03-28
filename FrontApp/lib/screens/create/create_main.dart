// ignore_for_file: always_specify_types

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'components/create_body.dart';
import 'components/create_header.dart';

class CreateMain extends StatelessWidget {
  const CreateMain({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: CupertinoColors.darkBackgroundGray,
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 60,
          ),
          const CreateHeader(),
          SizedBox(
            height: height / 10,
          ),
          const CreateBody(),
        ],
      ),
    );
  }
}
