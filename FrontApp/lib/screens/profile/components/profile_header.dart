import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 30,
        ),
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              LineIcons.angleLeft,
              color: Colors.white,
            )),
      ],
    );
  }
}
