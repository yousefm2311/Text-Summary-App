// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text_summary_edit/view/widget/MyText.dart';
import 'package:text_summary_edit/view/widget/custom_appBar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebView extends StatefulWidget {
  const WebView({super.key});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  late final WebViewController webController;

  bool isLoad = true;
  @override
  void initState() {
    super.initState();
    webController = WebViewController()
      ..loadRequest(Uri.parse(Get.arguments)).then((value) {
        setState(() {
          isLoad = false;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: MyText(text: 'GitHub')),
      body: Column(
        children: [
          if (isLoad) const LinearProgressIndicator(),
          isLoad
              ? Center(
                  child: CupertinoActivityIndicator(
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                )
              : Expanded(child: WebViewWidget(controller: webController)),
        ],
      ),
    );
  }
}
