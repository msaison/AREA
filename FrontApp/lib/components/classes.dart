// ignore_for_file: avoid_catches_without_on_clauses, always_specify_types
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: missing_return, type_annotate_public_apis

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'constants.dart';
import 'using_func.dart';

class Api {
  Dio dio = Dio();

  Future<List> getServices(id) async {
    try {
      final Response response = await Dio().get(
        '$url/auths',
        queryParameters: {
          'auth0_id': id,
        },
      );
      final List applets = response.data;
      return applets;
    } catch (e) {
      await Fluttertoast.showToast(
        toastLength: Toast.LENGTH_SHORT,
        msg: 'Error to received services!',
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.redAccent,
      );
    }
  }

  Future<Response> pushID(id) async {
    try {
      return await Dio().get(
        '$url/user/id',
        queryParameters: {
          'auth0_id': id,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );
    } catch (e) {
      await Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return Response(statusCode: 400, requestOptions: null);
    }
  }

    Future<Response> deleteAuth(id, authid) async {
    try {
      return await Dio().post(
        '$url/user/auth/destroy',
        data: {
          'auth0_id': authid,
          'auth_id': id,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );
    } catch (e) {
      await Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return Response(statusCode: 400, requestOptions: null);
    }
  }

  Future<Response> deleteApplet(id, reactionid) async {
    try {
      return await Dio().get('$url/user/applets/destroy', queryParameters: {
        'auth0_id': id,
        'reaction_id': reactionid,
      });
    } catch (e) {
      await Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return Response(statusCode: 500, requestOptions: null);
    }
  }

  Future<Response> pushTriggerAction() async {
    Response response_;
    try {
      response_ = await Dio().post(
        '$url/user/services/reaction/create',
        data: {
          'auth0_id': globalActionReaction.reaction['auth0_id'] ??
              userUse.reactionIfNoModif['auth0_id'],
          'service_type': globalActionReaction.reaction['service_type'] ??
              userUse.reactionIfNoModif['service_type'],
          'reaction_type': globalActionReaction.reaction['reaction_type'] ??
              userUse.actionIfNoModif['reaction_type'],
          'params': [
            concatParamsAndKey(
                globalActionReaction.reaction['key_params'] ??
                    userUse.actionIfNoModif['key_params'],
                globalActionReaction.reaction['params'] ??
                    userUse.actionIfNoModif['params'])
          ],
        },
        // options: Options(
        //   contentType: Headers.jsonContentType,
        // ),
      );
    } catch (e) {
      await Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
    try {
      return await Dio().post(
        '$url/user/services/action/create',
        data: {
          'auth0_id': globalActionReaction.action['auth0_id'] ??
              userUse.actionIfNoModif['auth0_id'],
          'service_type': globalActionReaction.action['service_type'] ??
              userUse.actionIfNoModif['service_type'],
          'action_type': globalActionReaction.action['reaction_type'] ??
              userUse.actionIfNoModif['reaction_type'],
          'params': [
            concatParamsAndKey(
                globalActionReaction.action['key_params'] ??
                    userUse.actionIfNoModif['key_params'],
                globalActionReaction.action['params'] ??
                    userUse.actionIfNoModif['params'])
          ],
          'reaction_id': response_.data['id'],
        },
        // options: Options(
        //   contentType: Headers.jsonContentType,
        // ),
      );
    } catch (e) {
      await Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<List> getApplet(id) async {
    try {
      final Response response =
          await Dio().get('$url/user/applets', queryParameters: {
        'auth0_id': id,
      });
      final List applets = response.data;
      userUse.responseListUpdate = response.data[0];
      return applets;
    } catch (e) {
      // await Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<String> getUri(id, type) async {
    try {
      final Response response = await Dio().post(
        '$url/user/auth/create',
        data: {'auth0_id': id, 'auth_type': type},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );
      if (response.statusCode == 201) return '201';
      final String applets = response.data['redirect_uri'];
      return applets;
    } catch (err) {
      await Fluttertoast.showToast(msg: 'error : $err');
    }
  }

  Future<List> getServicesActionOrReaction(String trigger) async {
    try {
      final Response response = await Dio().get('$url/services/$trigger',
          options: Options(
            receiveTimeout: 20 * 1000,
            sendTimeout: 20 * 1000,
          ));
      final List applets = response.data;
      return applets;
    } catch (e) {
      await Fluttertoast.showToast(
        toastLength: Toast.LENGTH_SHORT,
        msg: e.toString(),
        timeInSecForIosWeb: 3,
      );
    }
  }

  Future<bool> isConnected(id, type) async {
    try {
      final Response response = await Dio().post(
        '$url/user/services/connected',
        data: {'auth0_id': id, 'service_type': type},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );
      return response.data['is_connected'];
    } catch (e) {
      await Fluttertoast.showToast(
        toastLength: Toast.LENGTH_SHORT,
        msg: e.toString(),
        timeInSecForIosWeb: 3,
      );
    }
  }
}

class ActionReaction {
  final action = {};
  final reaction = {};

  void allSet(
      String type,
      String serviceType,
      String reactionType,
      List<String> params,
      String auth0Id,
      List<dynamic> keyParams,
      String descType,
      String logoType,
      String colorType) {
    if (type == 'action') {
      action['service_type'] = serviceType;
      action['reaction_type'] = reactionType;
      action['params'] = params;
      action['auth0_id'] = auth0Id;
      action['key_params'] = keyParams;
      action['desc_type'] = descType;
      action['color_type'] = colorType;
      action['logo_type'] = logoType;
    } else if (type == 'reaction') {
      reaction['service_type'] = serviceType;
      reaction['reaction_type'] = reactionType;
      reaction['params'] = params;
      reaction['auth0_id'] = auth0Id;
      reaction['key_params'] = keyParams;
      reaction['desc_type'] = descType;
      reaction['color_type'] = colorType;
      reaction['logo_type'] = logoType;
    }
  }

  void clearActionReaction() {
    action.clear();
    reaction.clear();
  }
}

class Profile {
  String name;
  String picture;
  String id;
  Future<void> Function() logoutAction;
  String nickname;
  String email;
}

class Using {
  Map<String, dynamic> responseList = {};
  Map<String, dynamic> responseListUpdate = {};
  Map<String, dynamic> actionIfNoModif = {};
  Map<String, dynamic> reactionIfNoModif = {};
  bool update = false;

  void clearActionReactionModif() {
    actionIfNoModif.clear();
    reactionIfNoModif.clear();
  }

  void clearResponselist() {
    responseList.clear();
    responseListUpdate.clear();
  }
}
