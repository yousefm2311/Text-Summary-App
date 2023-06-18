// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:text_summary_edit/core/services/firestore_history.dart';
import 'package:text_summary_edit/core/services/settings/SettingsServices.dart';
import 'package:text_summary_edit/model/history_model.dart';
import 'package:pdf/widgets.dart' as pw;

class ProfileViewModel extends GetxController {
  var sharedPref = Get.put(SettingsServices());

  List<HistoryModel> get historyModel => _historyModel;
  List<HistoryModel> _historyModel = [];
  List docsId = [];

  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  ValueNotifier<bool> get isLoading => _isLoading;

  Future<void> refreshData() async {
    await Future.delayed(const Duration(seconds: 1)).then((value) {
      getHistory();
    });
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

    final file = File("${output.path}/my_document.pdf");
    await file.writeAsBytes(await pdf.save()).then((value) {
      if (kDebugMode) {
        print('good');
      }
    });

    OpenFile.open(file.path);
  }

  void getHistory() async {
    try {
      _historyModel = [];
      docsId = [];
      isLoading.value = true;
      await FireStoreHistory()
          .getHistory(sharedPref.sharedPref!.getString('Id')!)
          .then((value) {
        for (QueryDocumentSnapshot documentSnapshot in value.docs) {
          docsId.add(documentSnapshot.id);
        }
        for (int i = 0; i < value.docs.length; i++) {
          _historyModel.add(HistoryModel.fromJson(value.docs[i].data()));
        }
        isLoading.value = false;
        update();
      });
    } catch (e) {
      isLoading.value = false;
      update();
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  void deletehistory(index) async {
    await FireStoreHistory()
        .deleteHitory(sharedPref.sharedPref!.getString('Id')!, docsId[index])
        .then((value) {
      getHistory();
      update();
    });
  }
}
