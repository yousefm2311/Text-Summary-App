// ignore_for_file: must_be_immutable

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:text_summary_edit/core/view_model/home_view_model.dart';
import 'package:text_summary_edit/view/widget/MyText.dart';
import 'package:text_summary_edit/view/widget/circleDesgin.dart';
import 'package:text_summary_edit/view/widget/custom_appBar.dart';
import 'package:text_summary_edit/view/widget/icon_broken.dart';

class TextSummary extends StatelessWidget {
  TextSummary({super.key});

  HomeViewModel controller = Get.put(HomeViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        centerTitle: true,
        title: MyText(
          text: 'Result Page',
          textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 20.0,
              ),
        ),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                child: GradientBall(
                  colors: [
                    Colors.deepOrange.withOpacity(0.6),
                    Colors.amber.withOpacity(0.5),
                  ],
                ),
              ),
              Positioned(
                right: 1,
                child: GradientBall(
                  size: const Size.square(200),
                  colors: [
                    Colors.blue.withOpacity(0.6),
                    Colors.purple.withOpacity(1)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: BlurryContainer(
                  color: Get.isDarkMode
                      ? Colors.grey.withOpacity(0.05)
                      : Colors.grey.withOpacity(0.21),
                  blur: 30,
                  padding: const EdgeInsets.all(20),
                  child: _buildTextFormField(context),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buildTextFormField(context) => SizedBox(
        height: MediaQuery.of(context).size.height * 1,
        width: MediaQuery.of(context).size.width * 1,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                  text: 'Text Summary',
                  textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Get.isDarkMode ? Colors.white : Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: MyText(
                  maxLines: controller.summaryModel!.openai!.result!.length,
                  text: controller.summaryModel!.openai!.result!
                      .replaceFirst(':', ''),
                  textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Get.isDarkMode ? Colors.white70 : Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                ),
              ),
            ),
            Row(
              children: [
                GetBuilder<HomeViewModel>(
                  builder: (cont) {
                    return IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        // controller.writeTextToPdf(controller.textSummary.text);
                        controller.saveAsPdf(
                          controller.summaryModel!.openai!.result!
                              .replaceFirst(':', ''),
                        );
                      },
                      icon: cont.loading.value
                          ? const CupertinoActivityIndicator()
                          : const Icon(
                              IconBroken.Paper_Download,
                            ),
                    );
                  },
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    if (controller.textSummary.text.isEmpty) {
                    } else {
                      Clipboard.setData(ClipboardData(
                          text: controller.summaryModel!.openai!.result!
                              .replaceFirst(':', '')));

                      // Get.snackbar('copy', 'copy in clipboard',
                      //     snackPosition: SnackPosition.BOTTOM,
                      //     borderRadius: 10,
                      //     maxWidth: 150,
                      //     duration: const Duration(seconds: 1));
                    }
                  },
                  icon: const Icon(
                    Icons.copy,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    if (controller.textSummary.text.isEmpty) {
                    } else {
                      await Share.share(controller.summaryModel!.openai!.result!
                          .replaceFirst(':', ''));
                    }
                  },
                  icon: const Icon(
                    Icons.share,
                  ),
                ),
              ],
            )
          ],
        ),
      );
}
