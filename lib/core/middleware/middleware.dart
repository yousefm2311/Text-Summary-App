import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text_summary_edit/core/services/settings/SettingsServices.dart';
import 'package:text_summary_edit/routes/routes.dart';

class AuthMiddleWare extends GetMiddleware {
  var shared = Get.put(SettingsServices());

  @override
  RouteSettings? redirect(String? route) {
    if (shared.sharedPref!.getBool('uId') == true) {
      return RouteSettings(name: AppRoutes.initState);
    } else if (shared.sharedPref!.getBool('uId') == false) {
      return RouteSettings(name: AppRoutes.initState);
    }
    return null;
    // return RouteSettings(name: AppRoutes.login);
  }
}
