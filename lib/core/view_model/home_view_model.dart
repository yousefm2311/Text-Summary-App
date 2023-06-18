// ignore_for_file: await_only_futures, unused_local_variable, deprecated_member_use, unnecessary_null_comparison, library_prefixes, unrelated_type_equality_checks, unused_field, no_leading_underscores_for_local_identifiers, unused_element

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tesseract_ocr/android_ios.dart';
// import 'package:flutter_tesseract_ocr/android_ios.dart';

import 'package:get/get.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import 'package:text_summary_edit/core/services/firestore_history.dart';
import 'package:text_summary_edit/core/services/network/dio_helper.dart';
import 'package:text_summary_edit/core/services/settings/SettingsServices.dart';
import 'package:text_summary_edit/core/view_model/settings_view_model.dart';
import 'package:text_summary_edit/model/history_model.dart';
import 'package:text_summary_edit/model/summary_model.dart';
import 'package:text_summary_edit/routes/routes.dart';
import 'package:text_summary_edit/view/chatbot_view.dart';
import 'package:text_summary_edit/view/home_view.dart';
import 'package:text_summary_edit/view/profile_view.dart';
import 'package:text_summary_edit/view/settings_view.dart';
import 'package:text_summary_edit/view/widget/MyText.dart';
import 'package:pdf/widgets.dart' as pw;

class HomeViewModel extends GetxController {
  List<ScreenHiddenDrawer> pages = [];
  @override
  void onInit() {
    // PdfGenerator.init();
    pages = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          colorLineSelected: Colors.deepPurple,
          name: 'Home Page',
          baseStyle: const TextStyle(
            fontSize: 16,
          ),
          selectedStyle: const TextStyle(
            fontSize: 17,
          ),
        ),
        HomeView(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: "ChatBot",
          baseStyle: const TextStyle(
            fontSize: 16,
          ),
          selectedStyle: const TextStyle(
            fontSize: 17,
          ),
          colorLineSelected: Colors.deepPurple,
        ),
        const ChatView(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: "History",
          baseStyle: const TextStyle(
            fontSize: 16,
          ),
          selectedStyle: const TextStyle(
            fontSize: 17,
          ),
          colorLineSelected: Colors.deepPurple,
        ),
        const ProfileView(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: "Settings",
          baseStyle: const TextStyle(
            fontSize: 16,
          ),
          selectedStyle: const TextStyle(
            fontSize: 17,
          ),
          colorLineSelected: Colors.deepPurple,
        ),
        SettingsView(),
      ),
    ];
    super.onInit();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController textSummary = TextEditingController();
  RxBool isLo = false.obs;

  var shared = Get.put(SettingsServices());

  ValueNotifier<bool> get loading => _loading;
  final ValueNotifier<bool> _loading = ValueNotifier(false);

  ValueNotifier<bool> get loadingPdf => _loadingPdf;
  final ValueNotifier<bool> _loadingPdf = ValueNotifier(false);

  // Future<File?> pickPDF() async {
  //   _loadingPdf.value = true;
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['pdf'],
  //   );
  //   if (result != null) {
  //     return File(result.files.single.path!);
  //   }
  //   _loadingPdf.value = false;
  //   update();
  //   return null;
  // }
  // Future<String?> extractText(File file) async {
  //   isLo.value = true;
  //   String text = "";
  //   try {
  //     text = await ReadPdfText.getPDFtext(file.path);
  //     return text;
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e.toString());
  //     }
  //   }
  //   return text;
  // }
  // void text() async {
  //   File? file = await pickPDF();
  //   if (file != null) {
  //     String? text = await extractText(file);
  //     if (text != null) {
  //       if (kDebugMode) {
  //         textSummary.text = text.replaceFirst(' ', '');
  //         _wordCount = textSummary.text.trim().split(' ').length;
  //         isLo.value = false;
  //         update();
  //       }
  //     } else {
  //       if (kDebugMode) {
  //         print('Failed to extract text from PDF');
  //         isLo.value = false;
  //         update();
  //       }
  //     }
  //   } else {
  //     if (kDebugMode) {
  //       print('No file selected');
  //       isLo.value = false;
  //       update();
  //     }
  //   }
  //   isLo.value = false;
  //   update();
  // }

  String _pickedFilePath = '';
  final String _extractedText = '';
  Future<void> pickPDFFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      _pickedFilePath = result.files.single.path!;
      update();
      await getPDFtext(_pickedFilePath);
    }
  }

  Future<String> getPDFtext(String path) async {
    String text = "";
    try {
      isLo.value = true;
      text = await ReadPdfText.getPDFtext(path);

      textSummary.text = text;
      if (kDebugMode) {
        print(text);
      }

      isLo.value = false;
      update();
    } on PlatformException {
      if (kDebugMode) {
        print('Failed to get PDF text.');
      }
    }
    return text;
  }

  File? image;
  var picker = ImagePicker();
  Future<void> getImageProfile() async {
    try {
      final pickerFile = await picker.getImage(source: ImageSource.gallery);
      if (pickerFile != null) {
        image = File(pickerFile.path);
      } else {
        if (kDebugMode) {
          print("No image selected");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    update();
  }

  void imagePicker() async {
    await getImageProfile();

    try {
      File? imageFile = image!;

      if (imageFile != null) {
        recognizeText(imageFile.path);
      } else {
        SnackBar(content: MyText(text: 'No image selected'));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  void requestGalleryPermission(context) async {
    PermissionStatus permissionStatus = await Permission.photos.request();
    if (permissionStatus.isGranted) {
    } else if (permissionStatus.isDenied) {
    } else if (permissionStatus.isPermanentlyDenied) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Permission Request'),
            content: const Text('Please grant access to your gallery.'),
            actions: <Widget>[
              MaterialButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              MaterialButton(
                child: const Text('Open Settings'),
                onPressed: () {
                  openAppSettings();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<String?> recognizeText(imagePath) async {
    _loading.value = true;
    try {
      final text = await FlutterTesseractOcr.extractText(imagePath);
      textSummary.text = text.replaceFirst(' ', '');
      // _wordCount = textSummary.text.trim().split(' ').length;
      _loading.value = false;
      update();
      return text;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    update();
    return null;
  }

  int _wordCount = 0;
  int get wordCount => _wordCount;
  void countWords() {
    String text = textSummary.text.trim();
    _wordCount = (text.isEmpty ? 0 : text.split(' ').length);
    if (kDebugMode) {
      print(_wordCount);
    }
    update();
  }

  RxBool isLoadingData = false.obs;

  SummaryModel? summaryModel;

  void postData() {
    try {
      if (textSummary.text.isNotEmpty) {
        isLoadingData.value = true;
        Dio_Helper.postData(url: '/text/summarize', data: {
          "response_as_dict": true,
          "attributes_as_list": false,
          "show_original_response": false,
          "output_sentences": 1,
          "providers": "openai",
          "text": textSummary.text
        }).then((value) {
          isLoadingData.value = false;

          summaryModel = SummaryModel.fromJson(value.data);
          if (kDebugMode) {
            print('result : ${summaryModel!.openai!.result!}');
          }
          if (shared.sharedPref!.getBool("uId") == true) {
            addHistoryToFirebase(
                summaryModel!.openai!.result!.replaceFirst(':', ""));
          }

          Get.toNamed(AppRoutes.textSummary);
        });
      } else {
        Get.snackbar('Error', 'Text is empty please try again ');
      }
    } catch (e) {
      isLoadingData.value = false;
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> saveAsPdf(textCreate) async {
    final pdf = pw.Document();

    final fontData = await rootBundle.load("assets/fonts/open-sans.ttf");
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

  var user = Get.put(SettingsViewModel());
  // DateTime now = DateTime.now();

  DateTime now = DateTime.now();
  void addHistoryToFirebase(text) async {
    HistoryModel historyModel = HistoryModel(
      time: now.toString(),
      text: text,
    );
    await FireStoreHistory().addHistory(historyModel, user.userModel!);
  }
}
