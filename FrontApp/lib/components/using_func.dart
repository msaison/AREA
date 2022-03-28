// ignore_for_file: parameter_assignments, missing_return, file_names,
// ignore_for_file: always_specify_types

import 'dart:io' show Platform;

import 'package:flutter/material.dart';

Color getColorFromHex(String hexColor) {
  hexColor = hexColor.replaceAll('#', '');
  if (hexColor.length == 6) hexColor = 'FF$hexColor';
  if (hexColor.length == 8) return Color(int.parse('0x$hexColor'));
}

bool isServiceConnected(
    AsyncSnapshot<dynamic> snapshot, Map<String, dynamic> responseList) {
  if (snapshot.hasData && !snapshot.hasError) {
    snapshot.data.forEach((service) {
      if (service[responseList['name']]['is_connected']) {
        return true;
      } else {
        return false;
      }
    });
  }
}

String choosePlatform() {
  if (Platform.isAndroid) {
    return '10.0.2.2';
  } else if (Platform.isIOS) {
    return 'localhost';
  }
}

Map<String, dynamic> concatParamsAndKey(
    List<dynamic> keyParams, List<dynamic> params) {
  if ((keyParams?.isNotEmpty ?? false) && (params?.isNotEmpty ?? false)) {
    final List<String> key = <String>[];
    for (var i = 0; i < keyParams.length; i++) {
      key.add(keyParams[i]['name']);
    }
    final tmp = Map.fromIterables(key, params);
    return tmp;
  } else {
    return {'': ''};
  }
}
