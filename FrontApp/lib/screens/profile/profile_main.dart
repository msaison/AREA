// ignore_for_file: diagnostic_describe_all_properties, always_specify_types

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/profile_body.dart';
import 'components/profile_header.dart';

class ProfileMain extends StatelessWidget {
  final Future<void> Function() logoutAction;
  final String name;
  final String picture;
  final String id;
  final List<dynamic> value;

  const ProfileMain(
      this.logoutAction, this.name, this.picture, this.id, this.value,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.darkBackgroundGray,
      body: Stack(
        children: <Widget>[
          const ProfileHeader(),
          ProfileBody(logoutAction, name, picture, value),
        ],
      ),
    );
  }
}
