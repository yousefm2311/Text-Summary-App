// ignore_for_file: must_be_immutable

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:text_summary_edit/core/services/settings/SettingsServices.dart';
import 'package:text_summary_edit/core/view_model/home_view_model.dart';
import 'package:text_summary_edit/view/widget/MyBotton.dart';
import 'package:text_summary_edit/view/widget/MyText.dart';
import 'package:text_summary_edit/view/widget/circleDesgin.dart';
import 'package:text_summary_edit/view/widget/icon_broken.dart';

class HomeView extends GetWidget<HomeViewModel> {
  HomeView({super.key});

  var shared = Get.put(SettingsServices());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: InkWell(
      //   onTap: () {
      //     controller.signOut();
      //   },
      //   child: MyText(text: 'Log Out'),
      // ),
      // appBar: CustomAppBar(
      //   title: MyText(
      //     text: 'Summary',
      //     textStyle:
      //         Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 22.0),
      //   ),
      //   action: [
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 10),
      //       child: IconButton(
      //         padding: EdgeInsets.zero,
      //         onPressed: () {},
      //         icon: const Icon(IconBroken.Info_Circle),
      //       ),
      //     )
      //   ],
      // ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
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
                        blur: 7,
                        padding: const EdgeInsets.all(20),
                        child: _buildTextFormField(context)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            GetX<HomeViewModel>(builder: (data) {
              return MyBotton(
                color: const [
                  Colors.blue,
                  Colors.purple,
                ],
                onPressed: () {
                  data.postData();
                },
                text: data.isLoadingData.value
                    ? const CupertinoActivityIndicator(
                        color: Colors.white,
                      )
                    : MyText(
                        text: 'Summary',
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                      ),
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.07,
              );
            })
          ],
        ),
      ),
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
                  text: 'Text',
                  textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    controller.textSummary.clear();
                    controller.countWords();
                  },
                  icon: const Icon(
                    IconBroken.Delete,
                  ),
                )
              ],
            ),
            Expanded(
              child: SizedBox(
                child: TextFormField(
                  controller: controller.textSummary,
                  // maxLength: 10000,
                  maxLines: 100,
                  maxLength:
                      shared.sharedPref!.getBool("uId") == true ? 10000 : 1000,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  // inputFormatters: [
                  //   shared.sharedPref!.getBool("uId") == true
                  //       ? LengthLimitingTextInputFormatter(2000)
                  //       : LengthLimitingTextInputFormatter(500)
                  // ],
                  onSaved: (value) {
                    controller.textSummary.text = value.toString();
                  },
                  onChanged: (value) {
                    controller.countWords();
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter text',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                GetX<HomeViewModel>(builder: (contr) {
                  return IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      // controller.text();
                      controller.pickPDFFile();
                      // controller.requestStorgePermission(context);
                      // }
                    },
                    icon: contr.isLo.value
                        ? const CupertinoActivityIndicator()
                        : const Icon(
                            IconBroken.Document,
                          ),
                  );
                }),
                GetBuilder<HomeViewModel>(builder: (cont) {
                  return IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      controller.requestGalleryPermission(context);
                      controller.imagePicker();
                    },
                    icon: cont.loading.value
                        ? const CupertinoActivityIndicator()
                        : const Icon(
                            IconBroken.Image,
                          ),
                  );
                }),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    if (controller.textSummary.text.isEmpty) {
                    } else {
                      Clipboard.setData(
                          ClipboardData(text: controller.textSummary.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Copied to clipboard'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.copy,
                  ),
                ),
                const Spacer(),
                // GetBuilder<HomeViewModel>(builder: (c) {
                //   return shared.sharedPref!.getBool('uId') == true
                //       ? MyText(text: '${c.wordCount} / 2000')
                //       : MyText(text: '${c.wordCount} / 500');
                // })
              ],
            )
          ],
        ),
      );
}
