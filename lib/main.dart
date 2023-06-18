// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:text_summary_edit/core/services/settings/SettingsServices.dart';
import 'package:text_summary_edit/core/services/themes/darkTheme.dart';
import 'package:text_summary_edit/core/services/themes/lightTheme.dart';
import 'package:text_summary_edit/routes/routes.dart';
import 'package:text_summary_edit/util/binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initService();
  runApp(MyApp());
}

Future initService() async {
  await Get.putAsync(() => SettingsServices().init());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  var getTheme = Get.put(SettingsServices());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      theme: LightTheme().customLightTheme,
      darkTheme: DarkTheme().customDarkTheme,
      themeMode: getTheme.sharedPref!.getBool("theme") == true
          ? ThemeMode.dark
          : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      initialBinding: Binding(),
      getPages: AppRoutes.routes,
    );
  }
}
