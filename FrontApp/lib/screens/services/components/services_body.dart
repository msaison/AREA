// ignore_for_file: always_specify_types, diagnostic_describe_all_properties

import 'package:flutter/material.dart';

import '../../../components/classes.dart';
import 'services_grid.dart';

class ServicesBody extends StatelessWidget {
  final String type;
  const ServicesBody(this.type, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: Api().getServicesActionOrReaction(type),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null || snapshot.data.length <= 0) {
            return Column(
              children: <Widget>[
                SizedBox(
                  height: height / 3,
                ),
                const CircularProgressIndicator(
                  backgroundColor: Colors.black,
                  color: Colors.grey,
                ),
              ],
            );
          } else {
            return ServicesGrid(snapshot, type);
          }
        });
  }
}
