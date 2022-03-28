// ignore_for_file: always_specify_types
// ignore_for_file: diagnostic_describe_all_properties

import 'package:avatars/avatars.dart';
import 'package:flutter/cupertino.dart';

import '../../../components/classes.dart';
import '../../profile/profile_main.dart';

class HomeHeader extends StatelessWidget {
  final Future<void> Function() logoutAction;
  final String name;
  final String picture;
  final String id;

  const HomeHeader(this.logoutAction, this.name, this.picture, this.id,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Row(
      children: <Widget>[
        Image.asset(
          'assets/images/arealogo_white.png',
          scale: 10,
        ),
        SizedBox(
          width: width - 300,
        ),
        Avatar(
          sources: [NetworkSource(picture)],
          border: Border.all(color: CupertinoColors.activeBlue, width: 3),
          onTap: () {
            Api()
                .getServices(id.substring(id.indexOf('|') + 1))
                .then((value) => {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (BuildContext context) => ProfileMain(
                                logoutAction, name, picture, id, value)),
                      ),
                    });
          },
        )
      ],
    );
  }
}
