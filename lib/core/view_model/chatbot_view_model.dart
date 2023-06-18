// ignore_for_file: unused_local_variable, unused_field

import 'dart:io';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart' as service;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';
import 'package:text_summary_edit/core/services/network/dio_helper.dart';
import 'package:text_summary_edit/model/chatbot_model.dart';
import 'package:pdf/widgets.dart' as pw;

class ChatBotViewModel extends GetxController {
  final TextEditingController messageController = TextEditingController();

  late DialogFlowtter dialogFlowtter;

  ChatBotViewModel() {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
  }
  List<Map<String, dynamic>> messageChat = [];
  sendMessage() async {
    if (messageController.text.isEmpty) {
      if (kDebugMode) {
        print("Please enter");
      }
    } else {
      addMessage(
          Message(text: DialogText(text: [messageController.text])), true);
      update();
      DetectIntentResponse response = await dialogFlowtter.detectIntent(
          queryInput:
              QueryInput(text: TextInput(text: messageController.text)));
      update();
      if (response.message == null) return;
      addMessage(response.message!);
      if (kDebugMode) {
        print(messageChat[1]['message'].toString());
      }
      update();
    }
  }

  addMessage(message, [bool isUserMessage = false]) {
    messageChat.add({
      'message': message,
      'isUserMessage': isUserMessage,
      'date': DateFormat("h:mm a").format(DateTime.now())
    });
    update();
  }

  RxBool isLoadingData = false.obs;
  bool isTyping = false;
  ChatBotModel? chatBotModel;
  void chatBotMessage() {
    if (messageController.text.isNotEmpty) {
      isLoadingData.value = true;
      addMessage(
          Message(text: DialogText(text: [messageController.text])), true);
      try {
        Dio_Helper.postData(url: '/text/chat', data: {
          "response_as_dict": true,
          "attributes_as_list": false,
          "show_original_response": false,
          "temperature": 0,
          "max_tokens": 250,
          "providers": "openai",
          "text": messageController.text,
        }).then((value) {
          chatBotModel = ChatBotModel.fromJson(value.data);
          messageController.clear();
          addMessage(Message(
              text: DialogText(text: [chatBotModel!.openai!.generated_text!])));
          if (kDebugMode) {
            print("ChatGpt ${chatBotModel!.openai!.generated_text}");
          }
          SchedulerBinding.instance.addPostFrameCallback((_) {
            scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: const Duration(microseconds: 100),
                curve: Curves.slowMiddle);
          });
          isLoadingData.value = false;
        }).catchError((error) {
          if (kDebugMode) {
            print(error.message);
          }
        });
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
    }
  }

  late ScrollController scrollController = ScrollController();
  scrollToBottom() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
    update();
  }

  shareText(text) async {
    try {
      await Share.share("$text");
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> saveAsPdf(textCreate) async {
    final pdf = pw.Document();

    final fontData =
        await service.rootBundle.load("assets/fonts/open-sans.ttf");
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(
              textCreate,
              style: pw.TextStyle(
                font: ttf,
                fontSize: 20,
              ),
            ),
          );
        },
      ),
    );

    PdfDocument document = PdfDocument();
    final output = await getTemporaryDirectory();
    final output1 = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/my_document.pdf");
    await file.writeAsBytes(await pdf.save()).then((value) {
      if (kDebugMode) {
        print('good');
      }
    });

    OpenFile.open(file.path);
  }
}
