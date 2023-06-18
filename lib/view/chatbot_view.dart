// ignore_for_file: unused_element, unrelated_type_equality_checks

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:text_summary_edit/core/services/settings/SettingsServices.dart';
import 'package:text_summary_edit/core/view_model/chatbot_view_model.dart';
import 'package:text_summary_edit/view/widget/icon_broken.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  ChatBotViewModel controller = Get.put(ChatBotViewModel());
  var sharedPref = Get.put(SettingsServices());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller.messageChat.isEmpty
        ? null
        : WidgetsBinding.instance
            .addPostFrameCallback((_) => controller.scrollToBottom());
    return Scaffold(
      body: GetBuilder<ChatBotViewModel>(builder: (c) {
        return sharedPref.sharedPref!.getBool("uId") == true
            ? Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: c.messageChat.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset('assets/images/chat.json'),
                                const Text("Chat is Empty"),
                              ],
                            )
                          : ListView.builder(
                              controller: c.scrollController,
                              physics: const BouncingScrollPhysics(),
                              itemCount: c.messageChat.length,
                              itemBuilder: (context, index) {
                                return _buildMessage(
                                    c.messageChat[index]['message'].text
                                        .text[0],
                                    c.messageChat[index]['isUserMessage'],
                                    index,
                                    context);
                              },
                            ),
                    ),
                  ),
                  c.isLoadingData.value
                      ? SpinKitThreeBounce(
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                          size: 18,
                        )
                      : Container(),
                  SizedBox(
                    height: 90,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.72,
                            child: GetBuilder<ChatBotViewModel>(builder: (c) {
                              return TextFormField(
                                onFieldSubmitted: (v) {
                                  c.chatBotMessage();
                                  SchedulerBinding.instance
                                      .addPostFrameCallback((_) {
                                    c.scrollController.animateTo(
                                        c.scrollController.position
                                            .maxScrollExtent,
                                        duration:
                                            const Duration(microseconds: 300),
                                        curve: Curves.slowMiddle);
                                  });
                                },
                                controller: controller.messageController,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                    left: 15,
                                  ),
                                  hintText: "Enter Message",
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(width: 10),
                          GetBuilder<ChatBotViewModel>(
                            builder: (cont) {
                              return Container(
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    SchedulerBinding.instance
                                        .addPostFrameCallback((_) {
                                      cont.scrollController.animateTo(
                                          cont.scrollController.position
                                              .maxScrollExtent,
                                          duration:
                                              const Duration(microseconds: 300),
                                          curve: Curves.slowMiddle);
                                    });
                                    cont.chatBotMessage();
                                  },
                                  icon: const Icon(
                                    IconBroken.Send,
                                    size: 20,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            : SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/images/login.json', width: 250),
                    const Text("Login to use ChatBot"),
                  ],
                ),
              );
      }),
    );
  }

  _buildMessage(String text, bool data, index, context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
          ),
          // child: Align(
          //   alignment: controller.messageChat[index]['isUserMessage']
          //       ? Alignment.topRight
          //       : Alignment.topLeft,
          //   child: Padding(
          //     padding: controller.messageChat[index]['isUserMessage']
          //         ? const EdgeInsets.only(left: 100)
          //         : const EdgeInsets.only(right: 100),
          //     child: Container(
          //       padding: const EdgeInsets.symmetric(
          //           vertical: 10.0, horizontal: 15.0),
          //       decoration: BoxDecoration(
          //         color: controller.messageChat[index]['isUserMessage']
          //             ? Colors.blue.withOpacity(.7)
          //             : Colors.grey.shade300,
          //         borderRadius: controller.messageChat[index]['isUserMessage']
          //             ? const BorderRadius.only(
          //                 topLeft: Radius.circular(12.0),
          //                 topRight: Radius.circular(4.0),
          //                 bottomLeft: Radius.circular(12.0),
          //                 bottomRight: Radius.circular(12.0),
          //               )
          //             : const BorderRadius.only(
          //                 topLeft: Radius.circular(4.0),
          //                 topRight: Radius.circular(12.0),
          //                 bottomRight: Radius.circular(12.0),
          //                 bottomLeft: Radius.circular(12.0)),
          //       ),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             text,
          //             style: TextStyle(
          //               color: controller.messageChat[index]['isUserMessage']
          //                   ? Colors.white
          //                   : Colors.black,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          child: Padding(
            padding: controller.messageChat[index]['isUserMessage']
                ? const EdgeInsets.only(left: 80)
                : const EdgeInsets.only(right: 80),
            child: GetBuilder<ChatBotViewModel>(
              builder: (c) {
                c.isTyping = c.messageChat.length - 1 == index;
                return Align(
                  alignment: controller.messageChat[index]['isUserMessage']
                      ? AlignmentDirectional.centerEnd
                      : AlignmentDirectional.centerStart,
                  child: GestureDetector(
                    onLongPress: () {
                      Get.bottomSheet(
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12.0),
                            topLeft: Radius.circular(12.0),
                          )),
                          height: MediaQuery.of(context).size.height * 0.16,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                    Clipboard.setData(ClipboardData(
                                        text: text.replaceFirst(':', '')));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Copied to clipboard'),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.copy,
                                        size: 16.0,
                                        color: Colors.black87,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'Copy to clipboard',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  color: Colors.black87,
                                ),
                                InkWell(
                                  onTap: () async {
                                    Get.back();
                                    await Share.share(
                                        text.replaceFirst(':', ''));
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.share,
                                        size: 16.0,
                                        color: Colors.black87,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'Share results',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  color: Colors.black87,
                                ),
                                InkWell(
                                  onTap: () async {
                                    Get.back();
                                    controller.saveAsPdf(
                                      text.replaceFirst(':', ''),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(
                                        IconBroken.Document,
                                        size: 16.0,
                                        color: Colors.black87,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'Save Pdf',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        backgroundColor: Colors.white,
                      );
                    },
                    child: BlurryContainer(
                      color: controller.messageChat[index]['isUserMessage']
                          ? Colors.blue.withOpacity(0.6)
                          : Get.isDarkMode
                              ? Colors.grey.withOpacity(0.05)
                              : Colors.grey.withOpacity(0.21),
                      blur: 7,
                      padding: const EdgeInsets.all(15),
                      child: controller.messageChat[index]['isUserMessage']
                          ? Text(
                              text,
                              style: TextStyle(
                                color: c.messageChat[index]['isUserMessage']
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            )
                          : c.isTyping
                              ? AnimatedTextKit(
                                  totalRepeatCount: 1,
                                  isRepeatingAnimation: false,
                                  animatedTexts: [
                                    TyperAnimatedText(
                                      text.trim(),
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Get.isDarkMode
                                                ? Colors.white54
                                                : Colors.black87,
                                          ),
                                      speed: const Duration(
                                        milliseconds: 15,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  text,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Get.isDarkMode
                                            ? Colors.white54
                                            : Colors.black87,
                                      ),
                                ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: controller.messageChat[index]['isUserMessage']
              ? const EdgeInsets.only(right: 10.0, top: 4.0)
              : const EdgeInsets.only(left: 10.0, top: 4.0),
          child: Align(
            alignment: controller.messageChat[index]['isUserMessage']
                ? AlignmentDirectional.centerEnd
                : AlignmentDirectional.centerStart,
            child: Text(
              "${controller.messageChat[index]['date']}",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 12,
                    color: Get.isDarkMode ? Colors.white54 : Colors.black,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
