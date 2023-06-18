// ignore_for_file: must_be_immutable

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:text_summary_edit/core/services/settings/SettingsServices.dart';
import 'package:text_summary_edit/core/view_model/profile_view_model.dart';
import 'package:text_summary_edit/view/widget/MyText.dart';
import 'package:text_summary_edit/view/widget/icon_broken.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  var sharedPref = Get.put(SettingsServices());

  ProfileViewModel controller = Get.put(ProfileViewModel());

  @override
  void initState() {
    super.initState();
    controller.getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: sharedPref.sharedPref!.getBool("uId") == true
          ? GetBuilder<ProfileViewModel>(
              builder: (cont) {
                if (controller.isLoading.value) {
                  return const Center(child: CupertinoActivityIndicator());
                } else {
                  return controller.historyModel.isNotEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ListView.separated(
                                itemBuilder: (context, index) {
                                  String dateString =
                                      cont.historyModel[index].time!;
                                  DateFormat parser =
                                      DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS');
                                  DateTime date = parser.parse(dateString);
                                  String formatter =
                                      DateFormat('dd-MM-yyyy').format(date);
                                  return BlurryContainer(
                                      color: Get.isDarkMode
                                          ? Colors.grey.withOpacity(0.05)
                                          : Colors.grey.withOpacity(0.21),
                                      blur: 7,
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              MyText(
                                                text: 'Text Summary',
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                              ),
                                              const Spacer(),
                                              InkWell(
                                                onTap: () {
                                                  controller
                                                      .deletehistory(index);
                                                },
                                                child: const Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Icon(
                                                    IconBroken.Delete,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10.0),
                                          MyText(
                                            maxLines: 5,
                                            text:
                                                '${cont.historyModel[index].text}',
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                ),
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            children: [
                                              MyText(text: formatter),
                                              const Spacer(),
                                              InkWell(
                                                onTap: () {
                                                  controller.saveAsPdf(cont
                                                      .historyModel[index]
                                                      .text);
                                                },
                                                child: const Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Icon(
                                                    IconBroken.Document,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              InkWell(
                                                onTap: () {
                                                  Clipboard.setData(
                                                    ClipboardData(
                                                      text: cont
                                                          .historyModel[index]
                                                          .text!,
                                                    ),
                                                  );

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Copied to clipboard'),
                                                      duration:
                                                          Duration(seconds: 3),
                                                    ),
                                                  );
                                                },
                                                child: const Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Icon(
                                                    Icons.copy,
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  await Share.share(cont
                                                      .historyModel[index]
                                                      .text!);
                                                },
                                                child: const Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Icon(
                                                    Icons.share,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ));
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(height: 20);
                                },
                                itemCount: controller.historyModel.length),
                          ),
                        )
                      : SizedBox(
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset('assets/images/notfound.json',
                                  width: 250),
                              MyText(
                                text: 'History is empty',
                                textStyle: const TextStyle(fontSize: 18.0),
                              )
                            ],
                          ),
                        );
                }
              },
            )
          : SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/images/notfound.json', width: 250),
                  MyText(
                    text: 'Login to view the History',
                    textStyle: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 100.0)
                ],
              ),
            ),
    );
  }
}
