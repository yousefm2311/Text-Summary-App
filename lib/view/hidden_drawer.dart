// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:text_summary_edit/core/services/settings/SettingsServices.dart';
import 'package:text_summary_edit/core/view_model/home_view_model.dart';
import 'package:text_summary_edit/routes/routes.dart';
import 'package:text_summary_edit/view/widget/icon_broken.dart';

class HiddenDrawer extends GetWidget<HomeViewModel> {
  HiddenDrawer({super.key});

  var shared = Get.put(SettingsServices());

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      slidePercent: 40,
      leadingAppBar: const Icon(IconBroken.More_Square),
      actionsAppBar: [
        shared.sharedPref!.getBool("uId") == true
            ? Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green,
                        blurRadius: 3,
                      )
                    ]),
              )
            : Container(),
        IconButton(
          onPressed: () {
            Get.toNamed(AppRoutes.info);
          },
          icon: const Icon(
            IconBroken.Info_Circle,
          ),
        )
      ],
      // backgroundColorContent: Get.isDarkMode ? Colors.black : Colors.white,
      // backgroundColorAppBar:
      //     Get.isDarkMode ? const Color.fromARGB(221, 17, 16, 16) : Colors.white,
      // backgroundColorMenu: cont.isDarkMode.value
      //     ? const Color.fromARGB(221, 35, 35, 35)
      //     : Get.isDarkMode
      //         ? const Color.fromARGB(221, 35, 35, 35)
      //         : cont.isDarkMode.value == false && Get.isDarkMode == false
      //             ? const Color.fromARGB(255, 220, 220, 220)
      //             : const Color.fromARGB(255, 220, 220, 220),
      backgroundColorMenu: const Color.fromARGB(0, 66, 164, 245),
      elevationAppBar: 0,
      contentCornerRadius: 25,
      screens: controller.pages,
      initPositionSelected: 0,
    );
  }
}
