// ignore_for_file: file_names

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_summary_edit/core/services/firebase_options.dart';
import 'package:text_summary_edit/core/services/network/dio_helper.dart';

class SettingsServices extends GetxService {
  SharedPreferences? sharedPref;
  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    if (kDebugMode) {
      print(message.toString());
    }
  }

  Future<SettingsServices> init() async {
    sharedPref = await SharedPreferences.getInstance();

    Dio_Helper.init();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).then((value) async {
      // token = await FirebaseMessaging.instance.getToken();
      // if (kDebugMode) {
      //   print("token $token");
      // }
    });
    return this;
  }
}
